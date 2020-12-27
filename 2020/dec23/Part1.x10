import x10.io.Console;

public class Part1 {

    public static def main(Rail[String]) {
        Console.OUT.println("Hello, Dec 23rd");


        var current:Long = 0;
        // var cups:Rail[Long] = [3,8,9,1,2,5,4,6,7]; // sample data
        var cups:Rail[Long] = [1, 9, 3, 4, 6, 7, 2, 5, 8]; // puzzle input

        val modulo = 9;
        val numRounds = 100;


        Console.OUT.println(cups);

        for(var round:Long = 0 ; round < numRounds; round ++){

            var newCups:Rail[Long] = new Rail[Long](cups.size); // set up an empty rail for my new cups

            // I think you could possibly use a constrained type here?
            var dest:Long = cups(current) - 1;
            if(dest < 1) { dest = cups.size; }


            // The crab selects a destination cup: the cup with a label equal to the current cup's label minus one. If this would select one of the cups that was just picked up, the crab will keep subtracting one until it finds a cup that wasn't just picked up. If at any point in this process the value goes below the lowest value on any cup's label, it wraps around to the highest value on any cup's label instead.
            for(var i:Long=0;i<3;i++){
                for(var j:Long=1;j<4;j++){
                    val v = cups((current+j) % modulo);
                    if(cups((current+j) % modulo) == dest){
                        dest = dest - 1;
                        if(dest < 1) { dest = cups.size; }
                        break;
                    }
                }
            }


            var count:Long = 0;
            var i:Long = current;
            var idx:Long = current;
            while(count < cups.size) {

                // if we're at the destination, add the next three elements from cups
                if(cups(i) == dest){
                    newCups(idx) = cups(i);
                    for(var j:Long=1;j<4;j++){
                        newCups((idx+j) % modulo) = cups((current+j) % modulo);
                    }
                    idx = (idx + 4) % modulo;
                    i = (i + 1) % modulo;
                    count = count + 4;
                    continue;
                }

                newCups(idx) = cups(i);
                count = count + 1;
                idx = (idx + 1) % modulo;
                
                if(i == current) { 
                    i = (i + 4) % modulo;
                }else{
                    i = (i + 1) % modulo;
                }
            }

            cups = newCups;
            current = (current + 1) % modulo;
        }
        Console.OUT.println(cups);
    }
} 


    