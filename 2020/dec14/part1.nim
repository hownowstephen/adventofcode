import tables
import strutils
echo "Hello, Dec 14th"

var
    memory = initTable[int, int]()
    sum: int


var
    onemask: int = 0
    zeromask: int = not onemask

for line in lines "input.txt":
    let parts = line.split(" = ")
    if parts[0] == "mask":
        onemask = 0
        zeromask = not onemask
        for i in 0..high(parts[1]):
            case parts[1][high(parts[1])-i]:
                of '1':
                    onemask = onemask or 1 shl i
                of '0':
                    zeromask = zeromask and not (1 shl i)
                else:
                    continue
    else:
        let memidx = parts[0][4..^2].parseInt()
        memory[memidx] = zeromask and (parts[1].parseInt() or onemask)

for k in memory.keys:
    sum += memory[k]

echo sum

