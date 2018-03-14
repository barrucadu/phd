#!/usr/bin/env gnuplot

set terminal epslatex
set output "gen/bugs-seminar.tex"

set xlabel "Executions"
set ylabel "Bugs Found"
set border 3
set key bottom right reverse
set tics nomirror

set datafile separator ','

plot "data/counts.csv" index 0 using 1:4 with lines title "Weighted" lw 4, \
     "data/counts.csv" index 1 using 1:4 with lines title "PCT" lw 4, \
     "data/counts.csv" index 2 using 1:4 with lines title "Uniform" lw 4
