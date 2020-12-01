expect = ARGV[0].to_i

def elements(x)
    (x + x - 1) ** 2
end

numRings = 1
loop do
    if (2 * numRings - 1) ** 2 >= expect
        break
    end
    numRings += 1
end

indexInRing = expect - (2 * (numRings - 1) - 1) ** 2
sideLength = (2 * numRings - 1)
centre = (sideLength / 2).floor + 1

elementX = elementY = 0

if indexInRing < sideLength
    elementX = sideLength
    elementY = sideLength - indexInRing
elsif indexInRing + 1 < sideLength * 2
    elementX = sideLength - (indexInRing + 1) % sideLength
    elementY = 1
elsif indexInRing + 2 < sideLength * 3
    elementX = 1
    elementY = (indexInRing + 2) % sideLength + 1
else
    elementX = indexInRing - (3 * sideLength - 4)
    elementY = sideLength
end


p "part1: #{(elementX - centre).abs + (elementY - centre).abs}"
p "part2: #{}"