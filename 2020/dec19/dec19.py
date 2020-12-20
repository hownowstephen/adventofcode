f = open("input.txt")

rules = {}
for line in f:
    line = line.strip()
    if line == "":
        break
    x, y = line.split(":")
    if '"' in y:
        rules[int(x)] = y.strip(' "')
    else:
        rules[int(x)] = [[int(a.strip()) for a in l.strip().split(" ")] for l in y.split("|")]

# rules[8] = [[42], [42,8]]
# rules[11] = [[42,31], [42,11,31]]

def all_match(s, idx, rule):
    for sub in rule:
        i = match(s, idx, sub)
        if i <= idx:
            return 0
        idx = i
    return idx

def first_match(s, idx, rule):
    for sub in rule:
        i = match(s, idx, sub)
        if i > idx and i <= len(s):
            return i
    return 0

def match(s, idx, rule):
    if type(rule) is int:
        return match(s, idx, rules[rule])
    elif type(rule) is str:
        if idx >= len(s):
            return 0
        if s[idx] == rule:
            return idx + 1
        return 0
    elif type(rule[0]) is int:
        return all_match(s, idx, rule)
    return first_match(s, idx, rule)



# for s in ["ababbb", "bababa", "abbbab", "aaabbb", "aaaabbb"]:
#     matched, i =  match(s, 0, 0)
#     print s, i, matched and i == len(s)
#     # break

s = "bbbbbbbaaaabbbbaaabbabaaa"
print len(s)

print match(s, 0, 0)

count = total = 0
for idx, line in enumerate(f):
    total += 1
    val = line.strip()
    i =  match(val, 0, 0)
    if i == len(val):
        count += 1
        print val
        # else:
        #     print idx, val, i, len(val)

print count, total




