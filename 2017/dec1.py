from sys import argv as a;
print "part1:", sum(int(x) for (j,x) in enumerate(a[1]) if a[1][(j+1)%len(a[1])] == x)
print "part2:", sum(int(x) for (j,x) in enumerate(a[1]) if a[1][(j+len(a[1])/2)%len(a[1])] == x)