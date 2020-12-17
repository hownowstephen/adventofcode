matchers = []
tickets = []

import re

dest = {}

# parse the input
with open("input.txt") as f:
    for idx, line in enumerate(f):
        res = re.findall("(.*): (\d+)-(\d+) or (\d+)-(\d+)", line)
        if len(res) > 0:
            name, start, end, start2, end2 = res[0]
            if "departure" in name:
                dest[idx] = name
            matchers.append([(int(start), int(end)), (int(start2), int(end2))])
        elif re.match("([\d+,])+\d+", line):
            tickets.append([int(x) for x in line.split(",")])

myTicket = tickets[0]
tickets = tickets[1:]

from collections import defaultdict
import functools

opts = {}
for i, ticket in enumerate(tickets):
    valid = True
    sets = []
    for n in ticket:
        s = set()
        for j, rule in enumerate(matchers):
            if any(n >= r[0] and n <= r[1] for r in rule):
                s.add(j)
        sets.append(s)
        # print [(n, r[0], r[1], n >= r[0] and n <= r[1]) for r in rule]
    if all(len(s) > 0 for s in sets):
        for i, s in enumerate(sets):
            try:
                opts[i] &= s
            except KeyError:
                opts[i] = s

found = set()
while len(found) < len(myTicket):
    for idx, opt in opts.items():
        a = opt - set(f[1] for f in found)
        c = len([x for x, _ in enumerate(matchers) if x in a])
        if c == 1:
            found.add((idx, next(iter(a))))


for (idx, rule) in found:
    print idx, " -> ", rule

res = 1
for offset, _ in enumerate(dest):
    val = [i for i, r in found if r == offset][0]
    print offset, val, myTicket[val]
    res *= myTicket[val]

print res
# for (idx, rule) in found:
#     print "mine", myTicket[rule]

