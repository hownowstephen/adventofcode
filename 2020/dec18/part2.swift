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
    var a = 0 // accumulator, treats the first op as a mul always
    var op = ops.add
    var mul:[Int] = []

    var v = ""
    var stream:reader?

    init(reader r:reader) {
        stream = r
    }

    func advanced() -> Int {
        if stream == nil {
            return 0
        }
        while stream!.next(){
            if stream!.curr == " " {
                interpret()
                continue
            }else if stream!.curr == "(" {
                v = String(maffs(reader: stream!).advanced())
                continue
            }else if stream!.curr == ")" {
                interpret()
                return result()
            }
            v.append(stream!.curr)
        }
        interpret()
        return result()
    }

    func result() -> Int{
        var r = a
        for b in mul {
            print(a, "x", b)
            r *= b
        }
        return r
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
            print(a, "+", b!)
            a += b!
        }else if op == ops.mul {
            mul.append(a)
            a = b!
        }
        op = ops.none
    }
}

// print(maffs(reader: reader(input: "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")).advanced())

import Foundation

let someFile = "input.txt"
let input = try! String(contentsOfFile: someFile)
var result = 0

let lines = input.split(separator:"\n")

for line in lines {
    let m = maffs(reader: reader(input: String(line)))
    result += m.advanced()
}

print(result)