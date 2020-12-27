import x10.io.Console;

public class Part2 {

    class Node {
        public var next:long;
        
        def this(n:long){
            next = n;
        }
    }

    public static def main(Rail[String]) {
        Console.OUT.println("Hello, Dec 23rd part two");

        var proc:Part2 = new Part2();

        proc.run();
    }

    def run(){

        // var startData:Rail[long] = [3,8,9,1,2,5,4,6,7]; // sample data
        var startData:Rail[long] = [1, 9, 3, 4, 6, 7, 2, 5, 8]; // puzzle input

        val modulo:long = 1000000;
        var current:long = startData(0) - 1;

        var cups:Rail[Node] = new Rail[Node](modulo, (i:long)=>new Node((i+1) % modulo));

        for(var i:long =0; i < startData.size - 1; i ++){
            cups(startData(i)-1).next = startData((i+1) % modulo) - 1;
        }

        cups(startData(startData.size-1)-1).next = startData.size;

        if(modulo > startData.size){
            cups(cups.size-1).next = current;
        }

        val numRounds = 10000000;

        for(var round:long = 0 ; round < numRounds; round ++){
        
            var pickedUp:Rail[long] = new Rail[long](3);

            var ptr:long = current;
            for(var i:long = 0; i < pickedUp.size ; i ++){
                pickedUp(i) = cups(ptr).next;
                ptr = cups(ptr).next;
            }

            // cut out the next values
            cups(current).next = cups(ptr).next;

            var dest:long = current - 1;
            if(dest < 0) { dest = modulo - 1; }

            // dumb-ish way to figure out the dest value
            for(var i:long=0; i< pickedUp.size; i++){
                for(var j:long=0; j < pickedUp.size; j++){
                    if(dest == pickedUp(j)){
                        dest = dest - 1;
                        if(dest < 0) { dest = modulo - 1; }
                        break;
                    }
                }
            }

            // insert these cups between the two destination nodes
            cups(pickedUp(2)).next = cups(dest).next;
            cups(dest).next = pickedUp(0);
            
            current = cups(current).next;
        }


        var result:long = 1;
        var idx:long = 0;
        var display:Rail[long] = new Rail[long](3);
        for(var i:long=0; i < 3; i ++){
            display(i) = idx+1;
            result *= (idx+1);
            idx = cups(idx).next % modulo;
        }

        Console.OUT.println(display);
        Console.OUT.println(result);

    }
} 


    