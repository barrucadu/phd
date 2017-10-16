#!/usr/bin/env python

import sys

def lines(fname):
    out = set()
    with open(fname, 'r') as f:
        for line in f:
            out.add(line)
    return out

f1 = sys.argv[1]
f2 = sys.argv[2]
f3 = sys.argv[3]

lines1 = lines(f1)
lines2 = lines(f2)
lines3 = lines(f3)

print "In %s: %d" % (f1, len(lines1))
print "In %s: %d" % (f2, len(lines2))
print "In %s: %d" % (f3, len(lines3))
print "Only in %s: %d" % (f1, len(lines1 - lines2 - lines3))
print "Only in %s: %d" % (f2, len(lines2 - lines1 - lines3))
print "Only in %s: %d" % (f3, len(lines3 - lines1 - lines2))
print "Only in %s and %s: %d" % (f1, f2, len((lines1 & lines2) - lines3))
print "Only in %s and %s: %d" % (f1, f3, len((lines1 & lines3) - lines2))
print "Only in %s and %s: %d" % (f2, f3, len((lines2 & lines3) - lines1))
print "Only in %s and %s and %s: %d" % (f1, f2, f3, len(lines1 & lines2 & lines3))
