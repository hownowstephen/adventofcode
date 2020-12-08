class Part1 {
    static public function main():Void {
      trace("Hello, December 8th");

      var acc = 0;
      var cursor = 0;
      var lines:Array<String> = [];
      var seen:Array<Int> = [];      

      var fin = sys.io.File.read("input.txt", false);

      try {
            while(true) {
                if(seen.contains(cursor)){
                    trace("infinite loop found at position", cursor);
                    break;
                }

                while(lines.length <= cursor){
                    lines.push(fin.readLine());
                }
                seen.push(cursor);
                switch(lines[cursor].split(" ")){
                    case ["acc", var x]: acc += Std.parseInt(x);
                    case ["jmp", var x]: cursor += Std.parseInt(x); continue;
                    case _:
                }
                
                cursor++;
            }
            
        } catch (e:haxe.io.Eof) { 
            fin.close();
        }

        trace("accumulator", acc);
    }
  }