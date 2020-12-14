import tables
import strutils
import math
echo "Hello, Dec 14th part II"

var
    memory = initTable[int, int]()
    sum: int
    maskSpec: string # storing the mask as a string now since the X has meaning

for line in lines "input.txt":
    let parts = line.split(" = ")
    if parts[0] == "mask":
        maskSpec = parts[1]
    else:
        var floatingBits = newSeq[int]()
        var addrMask = parts[0][4..^2].parseInt()
        for i in 0..high(maskSpec):
            case maskSpec[high(maskSpec)-i]:
                of '1':
                    addrMask = addrMask or 1 shl i
                of 'X':
                    floatingBits.add(1 shl i)
                else:
                    continue

        # find all mapped addresses
        for i in 0..2^len(floatingBits):
            var a = addrMask
            for j in 0..high(floatingBits):
                if (i shr j and 1) == 1:
                    a = a or floatingBits[j]
                else:
                    a = a and not floatingBits[j]
            memory[a] = parts[1].parseInt()

for k in memory.keys:
    sum += memory[k]

echo sum


# 0010

# 0000 -> 0010
# 0001 -> 0001
# 0010 -> 0010
# 0011 -> 0011