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

fun firstSeatAdjacent(seats: MutableList<ByteArray>, x: Int, y: Int, f: (Int, Int) -> List<Int>): Int {
    var r = listOf(x, y)
    while(true){
        r = f(r[0], r[1])
        if(r[0] < 0 || r[0] >= seats[0].size || r[1] < 0 || r[1] >= seats.size) { return 0 }
        if(seats[r[1]][r[0]] == floor) { continue }
        return (seats[r[1]][r[0]] == person).toInt()
    }
}

fun Boolean.toInt() = if (this) 1 else 0

fun occupy(seats: MutableList<ByteArray>): MutableList<ByteArray> {
    val output = mutableListOf<ByteArray>()

    val maxY = seats.size-1
    val maxX = seats[0].size-1

    for(y in 0..maxY) {
        val bytes = ByteArray(seats[0].size);
        for(x in 0..maxX){

            if(seats[y][x] == floor) { bytes[x] = floor; continue }
            var adj = 0

            for(i in listOf(-1, 1)){
                adj += firstSeatAdjacent(seats, x, y, {a, b -> listOf(a+i, b)})
                adj += firstSeatAdjacent(seats, x, y, {a, b -> listOf(a, b+i)})
                adj += firstSeatAdjacent(seats, x, y, {a, b -> listOf(a+i, b+i)})
                adj += firstSeatAdjacent(seats, x, y, {a, b -> listOf(a-i, b+i)})
            }
            
            if(seats[y][x] == empty && adj == 0) { bytes[x] = person }
            else if(adj >= 5 && seats[y][x] == person) { bytes[x] = empty }
            else { bytes[x] = seats[y][x] }
        }
        output.add(bytes)
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

