#!/bin/bash

for mode in random pct swarm1; do
  echo -ne "$mode:\t\t"
  if [[ ! -e $mode.txt ]] || [[ "$1" == "force" ]]; then
    grep -i assert benchmarks/__results/*/*-$mode-*.txt 2>/dev/null | sed 's/^.*\.txt://' | sort | uniq > $mode.txt
  fi
  wc -l < $mode.txt
done

for mode in swarm10 swarm100 swarm1000 swarm1c1 swarm1c2 swarm1c3; do
  echo -ne "$mode:\t"
  if [[ ! -e $mode.txt ]] || [[ "$1" == "force" ]]; then
    grep -hi assert benchmarks/__results/*/*-$mode-*.txt 2>/dev/null | sed 's/^.*\.txt://' | sort | uniq > $mode.txt
  fi
  wc -l < $mode.txt
done
