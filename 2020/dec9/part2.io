writeln("Hello, December 9th")

f := File with("input.txt")
lines := f readLines

checkSum := method(l, 
    result := 0
    l foreach(i, a, result = result + a)
    return result
)

run := method(target, lines,
    values := List clone
    lines foreach(i, v,
        n := v asNumber
        while(true,
            c := checkSum(values) 
            if(c == target,
                values = values sort
                writeln(values at(0) + values at(values size - 1))
                return
            )

            if(c < target, break)

            values remove(values at(0))
        )
        values append(n)
    )
)

run(41682220, lines)
f close