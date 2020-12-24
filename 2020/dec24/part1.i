write, "Hello, December 24th"

// gridSize should be even, we'll offset it by one to create a center point
gridSize = 50
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

            if(strpart(instr, i:i) == "w" && cmd == "n") x = x - 1
            if(strpart(instr, i:i) == "e" && cmd == "s") x = x + 1
        }else if(cmd == "w") x = x - 1
        else if(cmd == "e") x = x + 1
    }

    write, x, y, out(x, y)
    out(x, y) = out(x, y) ~ 1
}

// mode defaults to read
f = open("input.txt")
while(1){
    cmd = rdline(f)
    if(strlen(cmd) == 0) break // read until we get an empty string
    write, cmd
    flipTile(cmd)
}
close, f

// identity tile flip
// flipTile("nwwswee")

print, out
print, sum(out)
