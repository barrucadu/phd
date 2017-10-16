#!/usr/bin/env python

import os
import sys

algos = ["swarm1", "pct", "random"]
benchs = ["chess--InterlockedWorkStealQueue", "chess--InterlockedWorkStealQueueWithState", "chess--StateWorkStealQueue", "chess--WorkStealQueue", "conc-bugs--aget-bug2", "conc-bugs--pbzip2-0.9.4", "conc-bugs--stringbuffer-jdk1.4", "concurrent-software-benchmarks--account_bad", "concurrent-software-benchmarks--arithmetic_prog_bad", "concurrent-software-benchmarks--bluetooth_driver_bad", "concurrent-software-benchmarks--carter01_bad", "concurrent-software-benchmarks--circular_buffer_bad", "concurrent-software-benchmarks--deadlock01_bad", "concurrent-software-benchmarks--din_phil2_sat", "concurrent-software-benchmarks--din_phil3_sat", "concurrent-software-benchmarks--din_phil4_sat", "concurrent-software-benchmarks--din_phil5_sat", "concurrent-software-benchmarks--din_phil6_sat", "concurrent-software-benchmarks--din_phil7_sat", "concurrent-software-benchmarks--fsbench_bad", "concurrent-software-benchmarks--lazy01_bad", "concurrent-software-benchmarks--phase01_bad", "concurrent-software-benchmarks--queue_bad", "concurrent-software-benchmarks--reorder_10_bad", "concurrent-software-benchmarks--reorder_20_bad", "concurrent-software-benchmarks--reorder_3_bad", "concurrent-software-benchmarks--reorder_4_bad", "concurrent-software-benchmarks--reorder_5_bad", "concurrent-software-benchmarks--stack_bad", "concurrent-software-benchmarks--sync01_bad", "concurrent-software-benchmarks--sync02_bad", "concurrent-software-benchmarks--token_ring_bad", "concurrent-software-benchmarks--twostage_100_bad", "concurrent-software-benchmarks--twostage_bad", "concurrent-software-benchmarks--wronglock_3_bad", "concurrent-software-benchmarks--wronglock_bad", "parsec-2.0--streamcluster", "parsec-2.0--streamcluster2", "parsec-2.0--streamcluster3", "parsec-2.0--ferret", "inspect_examples--ctrace-test", "inspect_benchmarks--qsort_mt", "radbench--bug1", "radbench--bug2", "radbench--bug6", "safestack--bug1", "splash2--barnes", "splash2--fft", "splash2--lu"]

bugs = { a: [] for a in algos }

for algo in algos:
    for bench in benchs:
        i = -1
        for d in os.listdir("benchmarks/__results/"):
            for f in os.listdir("benchmarks/__results/" + d):
                bits = f.split("--")
                if bits[1] + "--" + bits[2] == bench and bits[3] == algo:
                    with open("benchmarks/__results/" + d + "/" + f, "r") as fp:
                        if i == 9999:
                            print("> 10000 executions!")
                            sys.exit(1)
                        i = i + 1
                        if i >= 10000:
                            i = 0
                        first = True
                        if i == len(bugs[algo]):
                            bugs[algo].append(set())
                        for line in fp:
                            if "assert" in line or "Assert" in line:
                                bugs[algo][i].add(line)
                            elif line.strip() == "Starting execution":
                                if first:
                                   first = False
                                else:
                                    i = i + 1
                                    if i > 9999:
                                        print("> 10000 executions!")
                                        sys.exit(1)
                                    if i == len(bugs[algo]):
                                        bugs[algo].append(set())


for algo in algos:
    print "# %s" % algo
    print "# executions, total, total (freq), bugs, bugs (freq)"
    total_so_far = 0
    bugs_so_far = set()
    executions = 1
    for step in bugs[algo]:
        total_so_far += len(step)
        bugs_so_far |= step
        print str([executions, total_so_far, float(executions) / total_so_far, len(bugs_so_far), float(executions) / len(bugs_so_far)])[1:-1]
        executions += 1
    print ""
    print ""



