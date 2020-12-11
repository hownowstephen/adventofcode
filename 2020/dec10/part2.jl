println("Hello, December 10th part II")

ints = [0]
for line in readlines("input.txt")
    push!(ints, parse(Int64, line))
end
sort!(ints)
push!(ints, ints[lastindex(ints)]+3)

function perms(list, seen)
    p = 1
    if length(list) <= 2
        return p
    end
    
    for i in 2:lastindex(list) - 1
        if list[i+1] - list[i-1] <= 3
            sub = vcat(list[1:i-1], list[i+1:lastindex(list)])
            if sub in seen
                continue
            end
            push!(seen, sub)
            println("SUB ",sub)
            p += perms(sub, seen)
        end
    end
    return p
end

groups = []
start = 1
result = 1
for i in 2:lastindex(ints)-1
    if ints[i+1] - ints[i-1] <= 3
        continue
    end
    if i - start > 2
        push!(groups, ints[start:i])
    end
    global start = i
end

for group in groups
    println(group, " => ", perms(group, []))
    global result *= perms(group, [])
end
println(result*2*2)