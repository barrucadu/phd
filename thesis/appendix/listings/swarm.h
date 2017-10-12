#ifndef SYSTEMATIC_SWARM_H_
#define SYSTEMATIC_SWARM_H_

#include "core/basictypes.h"
#include "systematic/scheduler.h"
#include <random>

namespace systematic {
  class SwarmScheduler : public Scheduler {
  public:
    std::default_random_engine random;

    explicit SwarmScheduler(ControllerInterface *controller);
    ~SwarmScheduler();

    void Register();
    bool Enabled();
    void Setup();
    void ProgramStart();
    void ProgramExit();
    void Explore(State *init_state);

  protected:
    std::pair<systematic::Thread* const, systematic::Action*>
      PickNextRandom(State *state);
    void AssignWeights(State *state);
    void AssignWeightTo(uint32 uid);
    void RestoreWeights();
    void PersistWeights();

  private:
    uint32 runs;
    std::map<uint32, uint8> weights;
    std::vector<unsigned int> changePoints;
    DISALLOW_COPY_CONSTRUCTORS(SwarmScheduler);
  };
}

#endif

