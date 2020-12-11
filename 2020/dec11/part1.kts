import java.io.File
import java.util.Arrays

println("Hello, Dec 11th")

var input = mutableListOf<ByteArray>()
File("input.txt").forEachLine {
    input.add(it.toByteArray())
}

val empty: Byte = 'L'.toByte()
val floor: Byte = '.'.toByte()
val person: Byte = '#'.toByte()


// All decisions are based on the number of occupied seats adjacent to a given seat (one of the eight positions immediately up, down, left, right, or diagonal from the seat). The following rules are applied to every seat simultaneously:

// If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
// If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
// Otherwise, the seat's state does not change.


fun occupy(seats: MutableList<ByteArray>): MutableList<ByteArray> {
    val output = mutableListOf<ByteArray>()

    val maxY = seats.size-1
    val maxX = seats[0].size-1

    for(i in 0..maxY) {
        val b = ByteArray(maxX+1);
        for(j in 0..maxX){
            if(seats[i][j] == floor) { b[j] = floor; continue }
            var adj = 0
            
            for(ii in i-1..i+1) {
                for(jj in j-1..j+1){
                    if(ii < 0 || jj < 0 || ii > maxY || jj > maxX || (ii == i && jj == j)) { continue }
                    if(seats[ii][jj] == person) { adj ++ }
                    if(adj == 4){ break }
                }
                if(adj == 4){ break }
            }
            if(seats[i][j] == empty && adj == 0) { b[j] = person }
            else if(adj == 4 && seats[i][j] == person) { b[j] = empty }
            else { b[j] = seats[i][j] }
        }
        output.add(b)
    }

    return output
}

fun check(curr: MutableList<ByteArray>, prev: MutableList<ByteArray>): Boolean {
    if(curr.size != prev.size) { return false }
    for(i in 0..curr.size-1){
        if(!Arrays.equals(curr[i], prev[i])) { return false }
    }
    return true
}

while(true) {

    val next = occupy(input)
    if(check(next, input)) {
        var occupied = 0
        for(line in input){
            // println(line.contentToString())
            for(seat in line){
                if(seat == empty) { print("L")}
                if(seat == floor) { print(".")}
                if(seat == person) { print("#"); occupied++ }
            }
            print("\n")
        }
        println(occupied)
        break
    }
    input = next;
}

