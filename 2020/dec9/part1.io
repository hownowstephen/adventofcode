writeln("Hello, December 9th")

f := File with("input.txt")
lines := f readLines

values := List clone
offset := 0

doCheck := method(v, l, 
    if(l size < 25, return true)
    l foreach(i, a,
        l foreach(j, b,
            if(a+b == v, return true)
        )
    )
    return false
)

lines foreach(i, v,
    n := v asNumber
    doCheck(n, values) ifFalse(
        writeln(v)
        break
    )
    if(values size < 25, values append(n), values atPut(offset, n))
    offset = (offset + 1) % 25
)
f close