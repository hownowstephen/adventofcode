import x10.io.Console;

public class Part1 {

    public static def main(Rail[String]) {
        Console.OUT.println("Hello, Dec 23rd");


        var current:Long = 0;
        // var cups:Rail[Long] = [3,8,9,1,2,5,4,6,7]; // sample data
        var cups:Rail[Long] = [1, 9, 3, 4, 6, 7, 2, 5, 8]; // puzzle input

        val numRounds = 100;

        Console.OUT.println(cups);

        for(var round:Long = 0 ; round < numRounds; round ++){

            var newCups:Rail[Long] = new Rail[Long](cups.size); // set up an empty rail for my new cups

            // I think you could possibly use a constrained type here?
            var dest:Long = cups(current) - 1;
            if(dest < 1) { dest = 9; }


            // The crab selects a destination cup: the cup with a label equal to the current cup's label minus one. If this would select one of the cups that was just picked up, the crab will keep subtracting one until it finds a cup that wasn't just picked up. If at any point in this process the value goes below the lowest value on any cup's label, it wraps around to the highest value on any cup's label instead.
            for(var i:Long=0;i<3;i++){
                for(var j:Long=1;j<4;j++){
                    val v = cups((current+j) % 9);
                    if(cups((current+j) % 9) == dest){
                        dest = dest - 1;
                        if(dest < 1) { dest = 9; }
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
                        newCups((idx+j) % 9) = cups((current+j) % 9);
                    }
                    idx = (idx + 4) % 9;
                    i = (i + 1) % 9;
                    count = count + 4;
                    continue;
                }

                newCups(idx) = cups(i);
                count = count + 1;
                idx = (idx + 1) % 9;
                
                if(i == current) { 
                    i = (i + 4) % 9;
                }else{
                    i = (i + 1) % 9;
                }
            }

            cups = newCups;
            current = (current + 1) % 9;
        }
        Console.OUT.println(cups);
    }
} 


    