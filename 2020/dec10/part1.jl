println("Hello, December 10th")

ints = [0]
for line in readlines("input.txt")
    push!(ints, parse(Int64, line))
end
sort!(ints)
push!(ints, ints[lastindex(ints)]+3)

ones = 0
threes = 0
for (idx, e) in enumerate(ints)
    # Julia arrays are 1-indexed,
    if idx == 1
        continue
    end

    if e - ints[idx-1] == 1
        global ones +=1
    elseif e - ints[idx-1] == 3
        global threes += 1
    end
end

println(ones * threes)