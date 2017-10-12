#include "core/logging.h"
#include "systematic/swarm.h"
#include <cstdlib>

namespace systematic {
  SwarmScheduler::SwarmScheduler(ControllerInterface *controller)
    : Scheduler(controller) {
  }

  SwarmScheduler::~SwarmScheduler() {
  }

  void SwarmScheduler::Register() {
    knob()->RegisterBool("enable_swarm_scheduler",
      "whether use the swarm scheduler", "0");
    knob()->RegisterInt("seed",
      "seed for swarm algorithm", "0");
    knob()->RegisterBool("use_seed",
      "use the seed parameter", "0");
    knob()->RegisterInt("swarm_maxruns",
      "number of executions to use the same weight for", "10");
    knob()->RegisterStr("swarm_file",
      "file to persist swarm weights to", "/tmp/swarm-weights");
    knob()->RegisterInt("swarm_wcp",
      "number of weight change points", "0");
    knob()->RegisterInt("swarm_k",
      "max number of scheduling points", "100");
  }
  bool SwarmScheduler::Enabled() {
    return knob()->ValueBool("enable_swarm_scheduler");
  }

  static unsigned long long rdtsc(){
    // read the processor's clock to get a random seed
    unsigned int lo,hi;
    __asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
    return ((unsigned long long)hi << 32) | lo;
  }

  void SwarmScheduler::Setup() {
    // seed the random number generator
    if(knob()->ValueBool("use_seed")) {
      int seed = knob()->ValueInt("seed");
      random.seed(seed);
      std::cout << "SEED: " << seed << std::endl;
    } else {
      unsigned long long seed = rdtsc();
      random.seed(seed);
      std::cout << "SEED: " << seed << std::endl;
    }
    srand(0);

    // attempt to read weights from file
    RestoreWeights();

    // change points
    int k = knob()->ValueInt("swarm_k");
    std::uniform_int_distribution<int> intDist(1, k);
    for(int i=1; i <= knob()->ValueInt("swarm_wcp")-1; ++i) {
      changePoints.push_back(intDist(random));
    }
  }

  void SwarmScheduler::ProgramStart() {
  }

  void SwarmScheduler::ProgramExit() {
    runs++;
    PersistWeights();
  }
  void SwarmScheduler::Explore(State *init_state) {
    // start with the initial state
    State *state = init_state;

    unsigned int steps = 0;
    // run until no enabled thread
    while (!state->IsTerminal()) {
      // give any new enabled threads weightings
      AssignWeights(state);

      // randomly pick the next thread to run
      auto it = PickNextRandom(state);

      // execute the action and move to next state
      state = Execute(state, it.second);

      // Are we at a change point?
      for(unsigned int cp : changePoints) {
        if(steps == cp) {
          std::cout << "Change point" << std::endl;
          AssignWeightTo(it.first->uid());
        }
      }

      steps++;
    }
  }

  void SwarmScheduler::AssignWeights(State *state) {
    auto enabled = state->enabled();
    for(auto it = enabled->begin(); it != enabled->end(); it++) {
      auto thread = it->first;
      auto uid = thread->uid();
      if(weights.find(uid) == weights.end()) {
        // new thread!
        AssignWeightTo(uid);
      }
    }
  }

  std::pair<systematic::Thread* const, systematic::Action*>
  SwarmScheduler::PickNextRandom(State *state) {
    auto enabled = state->enabled();
    assert(enabled->size() > 0);

    // get the list of enabled thread weightings
    std::list<uint8> e_ws;
    for(auto it = enabled->begin(); it != enabled->end(); it++) {
      auto thread = it->first;
      e_ws.push_back(weights[thread->uid()]);
    }

    // pick an enabled thread with a weighted random choice
    std::discrete_distribution<int> dist(e_ws.begin(), e_ws.end());
    int chosen = dist(random);

    // return the chosen thread
    auto it = enabled->begin();
    std::advance(it, chosen);
    return *it;
  }

  void SwarmScheduler::AssignWeightTo(uint32 uid) {
    std::uniform_int_distribution<uint8> weightDist(1, 50);
    uint8 weight = weightDist(random);
    std::cout << "Assigning thread " << uid <<
      " weight " << uint32(weight) << std::endl;
    weights[uid] = weight;
  }

  void SwarmScheduler::PersistWeights() {
    std::ofstream f(knob()->ValueStr("swarm_file"), std::ios::binary);
    if(f.is_open()) {
      std::cout << "Writing weights file" << std::endl;
      f.write(reinterpret_cast<const char*>(&runs), 4);
      uint8 numweights = weights.size();
      f.write(reinterpret_cast<const char*>(&numweights), 1);
      for(auto it = weights.begin(); it != weights.end(); it++) {
        f.write(reinterpret_cast<const char*>(&it->first), 4);
        f.write(reinterpret_cast<const char*>(&it->second), 1);
      }
    } else {
      std::cout << "Could not write to " <<
        knob()->ValueStr("swarm_file") << std::endl;
    }
  }

  void SwarmScheduler::RestoreWeights() {
    std::ifstream f(knob()->ValueStr("swarm_file"), std::ios::binary);
    if(f.is_open()) {
      f.read(reinterpret_cast<char*>(&runs), 4);
      if(runs == uint32(knob()->ValueInt("swarm_maxruns"))) {
        std::cout << "Weights in " <<
          knob()->ValueStr("swarm_file") << " too old" << std::endl;
        runs = 0;
      } else {
        uint8 numweights;
        f.read(reinterpret_cast<char*>(&numweights), 1);
        std::cout << "Restoring " << uint32(numweights) <<
          " weights:" << std::endl;
        for(uint8 i = 0; i < numweights; i++) {
          uint32 uid;
          uint8  weight;
          f.read(reinterpret_cast<char*>(&uid), 4);
          f.read(reinterpret_cast<char*>(&weight), 1);
          std::cout << "\tRestoring weight " << uint32(weight) <<
            " for thread " << uid << std::endl;
          weights[uid] = weight;
        }
      }
    } else {
      std::cout << "Could not read from " <<
        knob()->ValueStr("swarm_file") << std::endl;
    }
  }
}

