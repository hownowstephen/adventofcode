class Part2 {
    static public function main():Void {
        trace("Hello, December 8th, part II");

        var lines:Array<String> = [];
        var attempted:Array<Int> = [];
              

        // read in the entire file to our lines list
        var fin = sys.io.File.read("input.txt", false);
        try {
            while(true) {  lines.push(fin.readLine()); }
        } catch (e:haxe.io.Eof) { 
            fin.close();
        }

        // assume it is actually fixable
        // if we didn't we'd need to figure out if all the possible attempts have been made
        // also this will loop forever if the program is not broken
        while(true) {
            var acc = 0;
            var cursor = 0;
            var fixed = false;
            var failed = false;
            var seen:Array<Int> = [];

            while(cursor < lines.length){
                if(seen.contains(cursor)){
                    failed = true;
                    break;
                }
                seen.push(cursor);
                switch(lines[cursor].split(" ")){
                    case ["acc", var x]: acc += Std.parseInt(x);
                    case ["nop", var x] if(!fixed && !attempted.contains(cursor)):
                        fixed=true;
                        attempted.push(cursor);
                        cursor += Std.parseInt(x); continue;
                    case ["jmp", var x] if(!fixed && !attempted.contains(cursor)):
                        fixed=true;
                        attempted.push(cursor);
                    case ["jmp", var x]: cursor += Std.parseInt(x); continue;
                    case _:
                }
                
                cursor++;
            }

            if(!failed){
                trace("fix line", attempted[attempted.length-1], "accumulator", acc);
                break;
            }
        }
    }
  }