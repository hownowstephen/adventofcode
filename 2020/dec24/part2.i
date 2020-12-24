write, "Hello, December 24th, part 2"

// gridSize should be even, we'll offset it by one to create a center point
gridSize = 150
out = array(0, gridSize+1, gridSize+1)

func flipTile(instr){
    x = (gridSize / 2) + 1
    y = (gridSize / 2) + 1
    for (i=1 ; i <= strlen(instr) ; i++){
        cmd = strpart(instr, i:i)
        if(cmd == "n" || cmd == "s") {
            // handle y-axis
            if(cmd == "n") y = y - 1
            else y = y + 1

            i = i+1
            if(cmd == "n" && strpart(instr, i:i) == "w") x = x - 1
            if(cmd == "s" && strpart(instr, i:i) == "e") x = x + 1
        }else if(cmd == "w") x = x - 1
        else if(cmd == "e") x = x + 1
    }
    out(y, x) = out(y, x) ~ 1
}

func runDay(prev){
    next = array(0, gridSize+1, gridSize+1)

    for(y=0;y<gridSize+1;y++){
        for(x=0;x<gridSize+1;x++){

            neighbours = [
                prev(y-1, x-1),    // nw
                prev(y-1,x),      // ne
                prev(y,x-1),      // w
                prev(y,x+1),      // e
                prev(y+1,x),      // sw
                prev(y+1,x+1)     // se
            ]

            count = sum(neighbours)

            // Any black tile with zero or more than 2 black tiles immediately adjacent to it is flipped to white.
            if(prev(y,x) == 1 && (count == 0 || count > 2))
                next(y, x) = 0
            // Any white tile with exactly 2 black tiles immediately adjacent to it is flipped to black.
            else if (prev(y, x) == 0 && count == 2)
                next(y, x) = 1
            else
                next(y, x) = prev(y, x)
        }
    }

    return next
}

// mode defaults to read
f = open("input.txt")
while(1){
    cmd = rdline(f)
    if(strlen(cmd) == 0) break // read until we get an empty string
    flipTile(cmd)
}
close, f

for(i=0;i<100;i++) out = runDay(out)

print, sum(out)