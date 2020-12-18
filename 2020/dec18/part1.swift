import Swift

print("Hello, December 18th")

enum ops {
    case none
    case add
    case mul
}

class reader {
    var input = ""
    var curr: Character = "\u{00}"

    init(input i: String) {
        input = i
    }

    func next() -> Bool {
        if input.count  == 0 {
            return false
        }
        curr = input[input.startIndex]
        input = String(input.suffix(input.count - 1))
        return true
    }
}

class maffs {
    var a = 0 // accumulator, treats the first op as an add always
    var op = ops.add

    var v = ""
    var stream:reader?

    init(reader r:reader) {
        stream = r
    }

    func quick() -> Int {
        if stream == nil {
            return 0
        }
        while stream!.next(){
            if stream!.curr == " " {
                interpret()
                continue
            }else if stream!.curr == "(" {
                v = String(maffs(reader: stream!).quick())
                continue
            }else if stream!.curr == ")" {
                interpret()
                return a
            }
            v.append(stream!.curr)
        }
        interpret()
        return a
    }

    func interpret() {
        if op == ops.none {
            if v == "+" {
                op = ops.add
            }else if v == "*" {
                op = ops.mul
            }
            v = ""
            return
        }
        
        let b = Int(v)
        v = ""

        if op == ops.add {
            a += b!
        }else if op == ops.mul {
            a *= b!
        }
        op = ops.none
    }
}

import Foundation

let someFile = "input.txt"
let input = try! String(contentsOfFile: someFile)
var result = 0

let lines = input.split(separator:"\n")

for line in lines {
    let m = maffs(reader: reader(input: String(line)))
    result += m.quick()
}

print(result)