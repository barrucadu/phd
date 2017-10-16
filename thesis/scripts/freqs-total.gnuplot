#!/usr/bin/env gnuplot

set terminal epslatex
set output "gen/freqs-total.tex"

set xlabel "Executions"
set ylabel "Buggy Executions (freq)"
set border 3
set key bottom right reverse
set tics nomirror

set datafile separator ','

plot "data/counts.csv" index 0 using 1:3 with lines title "Swarm" lw 4, \
     "data/counts.csv" index 1 using 1:3 with lines title "PCT" lw 4, \
     "data/counts.csv" index 2 using 1:3 with lines title "Random" lw 4
