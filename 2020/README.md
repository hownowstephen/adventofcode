# [Advent of Code 2020](https://adventofcode.com/2020)

Goal is to use a new language every day, [alphabetically](https://en.wikipedia.org/wiki/List_of_programming_languages)

### Dec 1st: [Ada](https://www.adacore.com/get-started)

run with `make run` (I didn't save two discrete files for this one, would have to revert to the older commit to make both available, so it'll only give the solution to part two by default)

Using gnat-2020-20200429-x86_64-darwin-bin.dmg installed to `~/opt/GNAT/2020/bin/`

Starting with tutorial from https://riptutorial.com/ada

```
export PATH=$PATH:~/opt/GNAT/2020/bin/
make run
```

- Array basics https://learn.adacore.com/courses/intro-to-ada/chapters/arrays.html#simpler-array-declarations
- Reading file line by line https://rosettacode.org/wiki/Read_a_file_line_by_line#Ada
- String to Integer https://www.programming-idioms.org/idiom/22/convert-string-to-integer/1310/ada
[Set value in an array](https://stackoverflow.com/questions/42336795/ada-how-to-get-input-a-list-of-integer-from-a-user-and-put-it-into-an-array) using the `Array(Idx) := Value` syntax
- Type casting [can be done directly](https://stackoverflow.com/questions/38679423/how-to-transform-integer-to-float-and-vice-versa-in-ada)
- Control flow https://en.wikibooks.org/wiki/Ada_Programming/Control and https://learn.adacore.com/courses/Ada_For_The_CPP_Java_Developer/chapters/04_Statements_Declarations_and_Control_Structures.html#loops
- Long_Integer https://www.adaic.org/resources/add_content/standards/05rm/html/RM-3-5-4.html


### Dec 2nd: Bash

run with
```
./part1.sh
./part2.sh
```

Lines are formatted as `I-J C: password` which could also be formatted as a regexp matcher like `C{I-J}` and passed through to a grep? To make it easier it'd be a good idea to sort the strings in the input as well

Start with generating the regexps

```
$ echo "1-2 a: aabbaa" | sed -r 's/([0-9]+-[0-9]+) ([a-z]): [a-z]+/^[^\2]*\2{\1}[^\2]*$/'
^[^a]a{1-2}[^a]$
```
which will search for a single sequence of the values

https://stackoverflow.com/questions/17420994/how-can-i-match-a-string-with-a-regex-in-bash

```
echo "1-2 a: aabbaa" | sed -r 's/([0-9]+-[0-9]+) ([a-z]): ([a-z]+)/"[[ \3 =~ ^[^\2]*\2{\1}[^\2]*$ ]]"/' | xargs -n1 bash -c
```

but that matching is kind of weird, and curly braces are fraught in the bash world! Seems like it's better to use awk here so... https://stackoverflow.com/questions/15590549/curly-braces-in-awk-reg-exp

```
echo "aaaaaa" | awk '/^a{3,6}[^a]*$/ {print $1;}'
```

To start again, this'll print out the awk we need
```
echo "1-2 a: aabbaa" | sed -r "sX([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)Xawk '/^[^\3]*\3{\1,\2}[^\3]*$/ {print \$1;}' X"
awk '/^[^a]*a{1,2}[^a]*$/ {print $1;}'
```

and then

```
echo "1-2 a: aabb" | sed -r "sX([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)Xecho \"\4\" | awk '/^[^\3]*\3{\1,\2}[^\3]*$/ {print \$1;}' X"
```

generates the eval-able string. But we still need to split it! You can split a string using another seq https://stackoverflow.com/questions/2373874/how-to-sort-characters-in-a-string which we could encode into the output probably? someting like

```
echo "1-2 a: abcabca" | sed -r "sX([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)Xecho \"\4\" | grep -o . | sort |tr -d \"\n\" | awk '/^[^\3]*\3{\1,\2}[^\3]*$/ {print \$1;}' X"
```

which works! so now to put it together into something we can run, I think we'll need intermediate output, and then we can count the lines

```
cat input.txt | sed -r "sX([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)Xecho \"\4\" | grep -o . | sort |tr -d \"\n\" | awk '/^[^\3]*\3{\1,\2}[^\3]*$/ {print \$1;}' X" > intermediate.sh; bash ./intermediate.sh | wc -l
```

Part Two can use some of the same principles, but going to actually write a bash script instead. The idea:
- Grab which indices we need
- Pull those specific characters
- Check for exactly-once matches

- First to loop over the file https://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash
- Grabbing the pieces I'm using individual sed-s. there is likely a smarter way. Here's an error I ran into https://stackoverflow.com/questions/28072190/sed-error-1-not-defined-in-the-re-on-macosx-10-9-5 because I wasn't using -E
- Getting the characters https://unix.stackexchange.com/questions/9468/how-to-get-the-char-at-a-given-position-of-a-string-in-shell-script but that expects parameter expansion which doesn't seem to be a POSIX (so not available on OSX. hurry up, meerkat!). Oh no wait, I was using round braces and not curly ones
- increment/decrement https://linuxize.com/post/bash-increment-decrement-variable/
- took me two tries, my first attempt used a complicated regex similar to part I where I was looking for only one of the char. seemed smarter to just check the value of each char against the target char and look for exactly one. Which worked! It's mega slow, but it is done :D

### Dec 3rd: COBOL

run with 

```
# part 1
make run

# part 2
make run2
```

I am probably going to regret this decision.

Going to start with a simple reading file line-by-line https://stackoverflow.com/questions/49444910/reading-cobol-file-line-by-line-seperated-by-new-line-character

But actually I had some trouble getting gnu-cobol to actaully compile, turns out it was because I either need to set the line numbers explicitly or use the -free flag https://www.thegeekstuff.com/2010/02/cobol-hello-world-example-how-to-write-compile-and-execute-cobol-program-on-linux-os/

And then the stackoverflow was no help since it was a partial program and cobol needs some pretty explicit structures. But I took this https://turreta.com/2014/11/27/how-to-read-file-in-cobol/ and was able to get it to print out the entire tree file. Now to do some maths.

Sorted out how to add a new variable, I assumed the 01 in the WORKING-STORAGE section meant the second var should be 02, but it's some sort of hierachical data structuring instead. https://riptutorial.com/cobol/example/32550/sections-in-data-division

And here's the maths https://www.techagilist.com/mainframe/cobol/intrinsic-functions-cobol-reference/ 

For part two, going to structure my counters as arrays https://www.tutorialbrain.com/mainframe/cobol_arrays_internal_table/ and get all loopy up in here https://craftofcoding.wordpress.com/2018/03/15/coding-cobol-a-program-with-loops-and-an-array/

Had to figure out some multiplication https://www.tutorialride.com/cobol/multiply-verb-in-cobol.htm

Mostly did things right, except in trying to simplify the code I removed a block of read from the beginning, which changed the answers wildly. On further inspection I realised that the read loop from the sample code I pulled from loads the first line, checks for EOF and then loops and loads the second line within the loop. Could probably refactor to do the read at the top of the loop, but putting it back in made the solution work so I Am Out. Thanks for the laughs, COBOL. 

Actually ended up not being too tough of a language to work with, kind of liked some of the explicit structures. Docs online are kind of sparse. Wouldn't want to maintain a real-world system built on it.

### Dec 4th: [Dart](https://dart.dev/)

run with 
```
dart run part1.dart
dart run part2.dart
```

To install

```
brew tap dart-lang/dart
brew install dart
```

Short delay, had to install latest XCode. thanks, Obama

```
dart --disable-analytics
```

uh yeah. no phoning home to the mothergoogle please.

Dart has cool async javascript-y futures, but I'm just going to read synchronously https://fluttermaster.com/how-to-read-file-using-dart/ I guess I could figure out how to farm out checker work by passport. Probably not worth it

Splitting strings is just a method. Still feeling pretty ECMA https://www.tutorialkart.com/dart/dart-split-string/ and looks like for loops are pretty familiar https://www.codevscolor.com/dart-iterate-list

Going to just pull them out using a regexp https://api.dart.dev/stable/2.10.4/dart-core/RegExp-class.html and then drop the keys into a Set, which I can then compare against a reference Set of required fields. https://www.geeksforgeeks.org/dart-sets/

nevermind, used the standard dart docs which are quite good https://api.dart.dev/stable/2.10.4/dart-core/Set-class.html

Part two should just be a list of checks, gotta do some parsing!
Parsing int https://dev.to/wangonya/how-you-turn-a-string-into-a-number-or-vice-versa-with-dart-392h but that raises an exception, so I can have my parse func catch exceptions and bail out

### Dec 5th: [Elixir](https://elixir-lang.org/)

run with 
```
elixir part1.exs
elixir part2.exs
```

Time to do some binary searching with Elixir. As usual, need to start with reading a file line by line https://joyofelixir.com/11-files/ except that expects to be using an iex prompt and I want a binary. looks like I can do that with the `elixir` command https://blog.mclaughlinsoftware.com/2020/05/20/fedora-exlixir-install/

Going to have to define a function to handle the binary search https://www.tutorialspoint.com/elixir/elixir_functions.htm might as well try using pattern matching https://elixirschool.com/en/lessons/basics/functions/

Or maybe just an enum.reduce can work here https://elixirschool.com/en/lessons/basics/enum/ if we can convert the string to a list, which we can using `String.graphemes/1` https://elixir-examples.github.io/examples/string-to-list-of-characters

Still need to sort out some struct knowledge though, because I need a struct to track position https://micaelnussbaumer.com/2019/05/11/pattern-matching-in-elixir.html  or maybe just a map? https://www.tutorialspoint.com/elixir/elixir_maps.htm

Getting there, managed to get a reducer, once I did some casting of floats https://hexdocs.pm/elixir/master/Float.html

For part two my idea is to write each of the rows into a map[row]->[sorted cols] and then check for whichever one does not match [0...7] and that'll be my row and column

So I'll need to be able to sort https://rosettacode.org/wiki/Sort_three_variables#Elixir and more importantly, to figure out how to build out that map. Here's some good info on maps https://joyofelixir.com/10-maps/. 

because the value won't be set, going to need to do some pattern matching on the initial append https://www.tutorialspoint.com/elixir/elixir_decision_case.htm. Can't use pipe merging since we're adding new keys, so I'll use `Map.merge`

I think this solution would work, but I'm going to change it to use only seat IDs, which turns out to be far simpler. That said, I was almost at the right answer with the map approach, I had the candidates as one of rows `64, 104 or 6` and the possible columns were respectively
```
#MapSet<[5]>
#MapSet<[1, 2, 3, 4, 5, 6, 7]>
#MapSet<[0, 1, 2]>
```
(the actual row/column of the result was row 64, seat 5)

### Dec 6th: [F#](https://fsharp.org/)

to run
```
dotnet fsi part1.fsx
dotnet fsi part2.fsx
```

Installing the dotnet core with
```
brew install --cask dotnet-sdk
```

getting started using the tutorial for osx https://fsharp.org/use/mac/

reading a file https://stackoverflow.com/questions/2365527/how-read-a-file-into-a-seq-of-lines-in-f, I chose to use File.ReadLines, seems the most straightforward. Also imports use the `open ImportName` syntax

Now to consult the Expert F# 4.0. Amazingly the first example is kind of exactly what we need for this problem. The idea is to create a set for each group and then sum the set lengths

Turns out to be very similar to Elixir, maybe I should've done FORTRAN or something. Anyway, here's the docs on sets http://www.visualfsharp.com/fsharp/examples/HashSet.htm and splitting strings into characters https://stackoverflow.com/questions/45879292/how-do-i-split-a-string-into-a-list-of-chars-in-f-sharp

Useful format verbs `%O` gives the ToString() which for `HashSet...` is just the type. `%A` is for printing complex types, and in this case prints out the values in my set https://www.c-sharpcorner.com/article/printing-and-formatting-outputs-in-fsharp/

Next we need to handle them as groups https://docs.microsoft.com/en-us/dotnet/fsharp/language-reference/conditional-expressions-if-then-else

Got 6147 and it was WRONG because I forgot to add the final length of my set to the total. whoops! I double checked my work in the python cli and then worked this out

```
count = 0
for group in open("input.txt").read().split("\n\n"):
    count += 

print(count)
```

could even be a oneliner
```
print sum(len({x: 1 for x in group if x != "\n"}) for group in open("input.txt").read().split("\n\n"))
```


Part two should be a one line change, changing from the union of all sets to the intersection. nice! I was wrong, because I was doing it line-by-line, I needed to add some tracking to know which line I was on, since the _first_ line of the group needed to be a union, and subsequent needed to be intersections. I tried just doing an if block with `answers.Count = 0` and got the wrong result, because it meant that if I was partway through a group and already there was no intersection, it was applying that block, instead of doing so only once per group


### Dec 7th: [Groovy](https://groovy-lang.org/)

Diving into the JVM for an adventure in ~trees~ graphs (sort of)

to run (both parts)
```
groovy bags.groovy
```

installing groovy on OSX

```
brew install groovy
export GROOVY_HOME=/usr/local/opt/groovy/libexec
```

starting off with a hello world since I'm not 100% on what groovy looks like https://code-maven.com/groovy-hello-world turns out it can be pretty simple, at least. 

Can steal some ideas for idiomatic trees from https://codereview.stackexchange.com/questions/99245/is-my-binary-tree-correct, but first lets learn how to parse a file https://subscription.packtpub.com/book/application_development/9781849519366/4/ch04lvl1sec45/reading-a-text-file-line-by-line and then do some string parsin'

Actually might be not so fun / efficient to do this as a tree, it's more like a directed graph. Started by thinking about this one https://yongouyang.blogspot.com/2013/04/solving-farmer-wolf-goat-cabbage-riddle.html but I think my basic idea is going to be:

- for each line in the file, add a list of edges to the graph
- to find the parents of the gold bag you find all edges pointing at gold, then all pointing at those outer bags until you run outs

Appending to an array can take many forms https://stackoverflow.com/questions/44214845/how-to-append-to-an-array-in-groovy, and constructors are java-y https://stackoverflow.com/questions/2043218/groovy-constructors. 

Kept getting `push() is applicable for argument types` which was because I was using an Array (`Edge[]`) instead of a List `List<Edge>` per https://stackoverflow.com/questions/59416532/using-add-or-push-to-add-items-to-an-array-in-groovy

time for some regex parsing to get the bag details out https://e.printstacktrace.blog/groovy-regular-expressions-the-definitive-guide/ and looks like the number can be pulled out as integer pretty easily https://stackoverflow.com/questions/1713481/converting-a-string-to-int-in-groovy

Grab the result as a recursive `Set` and we're off to the races. Also can use the `as Set` operator to cast a list into a set. Neat

Part two is about doing the same but sort of in reverse. And took less than 3 minutes. Thankfully the dataset isn't recursive, because I definitely did not account for that in this part (although I guess if it was, then the answer would've been infinity, so makes sense).

### Dec 8th: [Haxe](https://haxe.org)

to run
```
haxe --main Part1 --interp
haxe --main Part2 --interp
```

Installing haxe on pop for my first solve on the meerkat

```
sudo add-apt-repository ppa:haxe/releases -y
sudo apt-get update
sudo apt-get install haxe -y
mkdir ~/haxelib && haxelib setup ~/haxelib
```

and starting with the tutorial at https://haxe.org/manual/introduction-hello-world.html

should be a straightforward solve, the idea is to keep a running list of visited lines while iterating through the file. Going to need a couple arrays https://api.haxe.org/Array.html and some string parsing https://api.haxe.org/String.html and to be able to convert string to int https://api.haxe.org/Std.html

might be able to use pattern matching to run commands https://haxe.org/manual/lf-pattern-matching-variable-capture.html

that worked a treat and after researching some logging https://haxe.org/manual/debugging-trace-log.html we have a solution to part one! 

Part two. The naive solution would be to backtrack on the first failed jmp and swap it, but that didn't work. I think the most straightforward approach will be instead to:
- load the entire program into a list
- try substitutions incrementally

going to do this by tracking which subsitutions we've tried and running the program inside a loop until it reaches the end

after a few false starts (tried tracking just the last attempt cursor, but since cursors jump around it wasn't able to capture what I actaully wanted to know -- which replacements have been made already and failed) got to a solution that works by accumulating the attempts in another array and using guards to check for a fixable moment in the switch. Useful bit of syntax, this pattern matching stuff

### Dec 9th: [Io](https://iolanguage.org)

to run 
```
io part1.io
io part2.io
```

This one's a bit more obscure, so not available in package managers. Going to have to grab a binary or compile from source https://github.com/IoLanguage/io

ran into 
```
[ 46%] Building C object libs/iovm/CMakeFiles/iovmall.dir/source/IoSystem.c.o
/home/stephen/Downloads/io/libs/iovm/source/IoSystem.c:26:11: fatal error: sys/sysctl.h: No such file or directory
   26 | # include <sys/sysctl.h>
```

which is enough for me to say whatever, I'll use a prebuilt binary

lots of sample code available in their source repo https://github.com/IoLanguage/io/tree/master/samples that is nice

as usual, lets start with reading a file line by line http://iolanguage.org/guide/guide.html#Primitives-File -- not easy to find docs for io, so going to be a bit more of an exploratory day I guess. Here's how to readlines https://github.com/IoLanguage/io/blob/fa791321d1921f0feef2f35ae0418bab0a662436/libs/iovm/tests/correctness/FileTest.io and then iterating over them is as simple as http://iolanguage.org/guide/guide.html#Primitives-List `lines foreach`

not much to note today, since it's all just directly from the iolanguage.org docs -- I definitely am not writing idiomatic io, kind of feels like I just shoved my logic in how I wanted it. But not feeling up to a refactor though, and it works!

### Dec 10th [Julia](https://julialang.org)

to run
```
julia part1.jl
julia part2.jl
```

Today's puzzle starts with what seems to be a simple-ish sorting problem, so back I go to parsing inputs from a file. 

Julialang site recommends installing their latest binary directly, but I want to make it easy on myself to roll back, so I'll install whatever is in apt `sudo apt install julia` should do the trick

Reading the file is a oneliner https://stackoverflow.com/questions/58169711/how-to-read-a-file-line-by-line-in-julia and then converting to int using parse https://www.geeksforgeeks.org/string-to-number-conversion-in-julia/

docs are pretty good, using https://docs.julialang.org/en/v1/base/collections/#General-Collections fairly extensively

having some trouble with variable scoping https://docs.julialang.org/en/v1/manual/variables-and-scoping/
```
Hello, December 10th
ERROR: LoadError: UndefVarError: ones not defined
Stacktrace:
 [1] top-level scope at /home/stephen/code/hownowstephen/adventofcode/2020/dec10/part1.jl:16
 [2] include(::Module, ::String) at ./Base.jl:377
 [3] exec_options(::Base.JLOptions) at ./client.jl:288
 [4] _start() at ./client.jl:484
in expression starting at /home/stephen/code/hownowstephen/adventofcode/2020/dec10/part1.jl:12
```

from the scoping rules you have to determine which scope you're applying to when doing the += so `global x += 1` - interesting way to avoid implicit shadowing problems!

for part two my initial hypothesis is that for every element after the third, I can multiply by two or three the result depending on whether the preceding 2 elements are necessary. This didn't really work right, though I'm not convinced it is entirely a wrong strat

my new idea is counting which adapters are unnecessary and then doing something mathematical with that result

that's also wrong since removing an element can mean others can't be removed, so I think it'll have to be a recursive calculation, which means i'll need a function https://docs.julialang.org/en/v1/manual/functions/

tried that but my implementation was pretty awful https://discourse.julialang.org/t/how-to-merge-arrays-in-julia/51520/5 basically recursed every time that it found an optional value, which seems to be way too intensive on the system. So back to the drawing board, my brain just is not lightbulbing on this one

Did some math on paper, basically for any spread of numbers, assuming all numbers are unique, the replacement set will be of maximum length 4, and for that set there are 4 combinations. For length 3 it is 2 combos and 2 or 1 has only one combination

That didn't work. I'm sure there's a faster solution, but what I've got now that works is just a recursive func that works but is mega inefficient. So now I have something I can optimize anyway. 

```
Allocations: 3486627628 (Pool: 3486627572; Big: 56); GC: 37217
```

yep that's not going to fly (didn't even finish running)

so the approach there was
1. find the first element you can remove
2. run same func on a list without that element
3. add 1 for every run.
4. which since it already says there's more than a trillion valid ways, clearly I will run into some Problems trying to run all trillion

Here's a new idea:
- start by finding a run of numbers
- determine number of permutations of that group
- continue to next
- multiply results

so it works, except that for the actual input file I get a value 2x below the winning one (which I already submitted) and that behaviour only happens for the actual input. To be revisited

### Dec 11th: [Kotlin](https://kotlinlang.org/)

to run
```
kotlinc -script part1.kts
kotlinc -script part2.kts
```

Needs JRE and kotlin command line tools https://kotlinlang.org/docs/tutorials/command-line.html which I don't want to keep around since I'm already not liking the docs -- so we'll go with just keeping it in downloads and setting the path

```
sudo apt-get install openjdk-15-jre-headless
export PATH=$PATH:~/Downloads/kotlin-native-linux-1.4.21/bin
```

for "A modern programming language that makes developers happier." I've not had any success even compiling on linux, and I don't feel happy. Going to move this over to the macbook I guess.

And doing a quick `brew install kotlin` worked, so we're off to the races

Starting with reading the file into a 2d array https://www.baeldung.com/kotlin-read-file which for whatever reason leaves off the import. Also looks like imports have to be at top of file

No need to handle the data as strings though, because we're just doing pattern matching based on adjacent squares. Very game of life. Need to read the file into a list, going to use a MutableList I think https://kotlinlang.org/docs/reference/collections-overview.html

And then need a function that does the transform, and one that does the compare https://kotlinlang.org/docs/reference/functions.html

had to do some learning about initializing types https://stackoverflow.com/questions/45122521/how-to-create-a-fixed-size-intarray-and-initializing-the-array-later-in-kotlin but aside from that and the compare function needing fixing, nearly there

for comparison https://discuss.kotlinlang.org/t/bytearray-comparison/1689 looks like easiest is to go non-idiomatic and use java Arrays.equals. Otherwise I probably would need to zip or iterate, either of which feels no better.

Onto part two which should just be a minor-ish modification to the mapper, instead of doing the 3x3 nested for loop, going to send out feelers in all directions until we're out of bounds or hit a person

using maxOf https://www.codevscolor.com/kotlin-maxof-find-maximum-value to figure out the max distance you'd need to plausibly go on a diagonal

not to outdo myself from earlier, but I again misread the prompt. we're only checking the first seat the person sees https://stackoverflow.com/questions/46401879/boolean-int-conversion-in-kotlin going to change my func to return a value we can accumulate

### Dec 12th: [LOLCODE](http://www.lolcode.org/)

to run
```
go run runner.go ./part1.lol
go run runner.go ./part2.lol
```

This is going to be a weird one, as I'm going to have to type the navigation instructions one-by-one I think? I'll see if I can get the sample working and then decide if there's hope

There isn't good enough array support to use one of those, I don't think (I'll look at that later) but for now I'll start with just reading from user input in an infinite loop until the input is blank I guess. Going to use `lci` since it seems to be the most well-defined interpreter

```
git clone https://github.com/justinmeza/lci.git
cd lci
cmake .
make && sudo make install
```

Whew, had to do some fun gymnastics for this one but it has been mega fun. No links to docs really, everything I needed was in https://www.tutorialspoint.com/lolcode/

There's no file IO, and no string manipulation. That means in order to make it work I had to do a bit of input doctoring - it accepts the first character of each line, followed by the numeric value following, and then runs the `IMTERPRET` function on those.

To end the program just send in a blank line

I needed a way to encapsulate the state, which I used a `BUKKIT` (array) for. Or the docs all say array, but it is definitely a struct, exactly what I need for state. Initially I had hoped that even without any file IO, I'd be able to hardcode all the commands into the array, but since it's a struct that was a no-go. Anyways, then it was matter of defining the logic and doing some fun maths

Once I had the program working for the sample input (thankfully it was short) I wrote a quick go program that automates the passing of the input to the lolcode program, since there's 790 commands in the input file and I am not typing 2x that by hand.

The next one we don't actuall care where the ship is pointed, so I just need to maintain two points, the ship and the waypoint. Did some math on paper as to how we translate the points when turning (it's just swapping the values and `-1*Y` for left and `-1*X` for right). Made a mistake in the first attempt because I was always turning once, needed to turn `BIGNESS/90` times. Looping on that and we're all done

### Dec 13: [Mercury](http://www.mercurylang.org/)

Skipped haskell on the 8th so time to circle back to a haskell-like. Unfortunately it looks like mercury is a bit of a pain to install, so going to have to wait on a compiler. In the meantime will get started with figuring out some basics I guess!

This should be a good starting point https://mercury-in.space/crash.html

I installed just the bootstrap version of mercury and will see if that's enough for solving a toy problem like this.

Reading files https://rosettacode.org/wiki/Read_entire_file#Mercury and what else is available in the io module https://mercurylang.org/information/doc-release/mercury_library/io.html

So I think the basic math here is we want the number in the list which, when divided by our arrival time has the smallest remainder. Possibly just min(busnum % interval) * interval

I think since we only have two lines I can do this with reading each line and then parsing them. Pulled some ideas from https://rosettacode.org/wiki/Guess_the_number#Mercury to how to implement, and have it pulling

Looks like when things are `semidet` you need to use the https://mercury-in.space/crash.html#org793ecc9 `( this_might_fail -> it_succeeded; it_failed )` syntax, like with `string.to_int`. Failed because the string was unchomped, and boy am I glad to see `string.chomp` - it's been awhile old friend

Not sure yet how to factor this so going to be stuck with a deep nesting structure I guess

Going to take a break from the string parsing part to work on the actual logic with hardcoded data. Might just end up skipping file parsing altogether since it's a major pain. Figured out how to use foldl and now the plan is to use `foldl2` (dual accumulator foldl) to track both the lowest modulo I've seen and the result that gives.

Spent quite awhile fiddling with defining predicates and sorted out a way to factor out my calculation into one, which means I can probably actually do my read-from file with where I'm at now.

Part two is quite different, I think I have a better grasp on the lang now so it shouldn't take forever this time. I'm going to foldl to check the list, and return a -1 if it fails, otherwise return the timestamp from the parent func

Ok well I solved it twice using brute force before realizing it's just a math problem using systems of modular equations https://www.wolframalpha.com/input/?i=systems+of+equations+calculator&assumption=%7B%22F%22%2C+%22SolveSystemOf3EquationsCalculator%22%2C+%22equation1%22%7D+-%3E%22x+mod+17+%3D+0%22&assumption=%22FSelect%22+-%3E+%7B%7B%22SolveSystemOf3EquationsCalculator%22%7D%7D&assumption=%7B%22F%22%2C+%22SolveSystemOf3EquationsCalculator%22%2C+%22equation2%22%7D+-%3E%22%28x+%2B+2%29+mod+13+%3D+0%22&assumption=%7B%22F%22%2C+%22SolveSystemOf3EquationsCalculator%22%2C+%22equation3%22%7D+-%3E%22%28x+%2B+3%29+mod+19+%3D+0%22 for example

```
Reduce[{Mod[x, 67] == 0, Mod[1 + x, 7] == 0, Mod[2 + x, 59] == 0, Mod[3 + x, 61] == 0}, {x}]
```

Day two, now that I've pinpointed the maths involved it's just a matter of actually working out how they apply. Also have moved to my macbook and looks like some of my notes from yesterday didn't get committed (relinquished my monitor and forgot to set up sshd on the meerkat). But basically some variant of the chinese remainder theorem here will work, since we know that:

sum(T % Mi...(T + n) % Mn) = 0

which means we just need to find the minimum T that fits the distribution. I was able to get the right value using wolfram alpha, but just need to figure out how to implement it in code now. Starting with golang and then will translate that to Mercury once I have a solution. Found an impl in python https://fangya.medium.com/chinese-remainder-theorem-with-python-a483de81fbb8 that may be a good jumping off point.

I'm only about 80% on the math, but after some translation from python to Mercury, got a solve. Also thinking it might be fun to submit the unmodified version to https://rosettacode.org/wiki/Chinese_remainder_theorem

### Dec 14th: [Nim](https://nim-lang.org/)

to run
```
make clean && make run
make clean && make run2
```

Phew, back to a language that I feel more comfortable with. Last couple days the approach of hardcoding some sample input to prove the algo has been pretty effective, so going to start with that and then figure out the file i/o. Easy to install (using the mac today) with `brew install nim`

Nim docs seem reasonably good, also looks like there's a bitops library which should be useful for doing this masking stuff https://nim-lang.org/docs/lib.html also nim by example will likely be very handy https://nim-by-example.github.io/ and https://nim-by-example.github.io/primitives/ looks like it's easy to declare binary data. Going to sub the `X` values in the mask with `1` since then I can `&` my values

For hardcoded version going to just use two arrays `memidx` and `value`. Going to hardcode the memory size as well for now just to get things going.

So it'll be the truth table
```
A B Q
0 0 0
0 1 1
1 0 0
1 1 1
```

Having thought it through some more, and double checked with some [truth tables](https://www.bzfar.org/publ/boolean_logic/boolean_logic/boolean_logic_truth_tables/20-1-0-38) - mask should be applied in two ways: `v and zeros` and `v or ones` where zeros contains all the zeros and ones otherwise, and ones contains all the ones and zeros otherwise. I don't _think_ there's an operator that does it in a single mask, but who knows.

Ok, now to resolve a bunch of the shims I put in to get the base solve. Starting with memory being a static array, instead lets use a [hash table](https://nim-lang.org/docs/tables.html)

Cool, reading files by line looks like it'll be a breeze https://stackoverflow.com/questions/41397499/how-to-load-file-line-by-line-in-nim and then string parsing using strutils should be my easiest move https://nim-by-example.github.io/strings/ - since it's got predictable input seems safe, and a bit of [bit magic](https://www.gamedev.net/forums/topic/492094-how-do-you-write-to-a-single-bit-in-a-integer/4213759/) and we're at solution #1

for solution 2 we need to keep track of some floating bits. My basic idea is:
- keep a list of which bits need to float
- for each element in the list, and the list of subsequent elements generate all possible masks
- then apply them

say these were my two floating bits `0X00X00X` if I generate
```
b1 = 00000001
b2 = 00001000
b3 = 01000000
```

```
0 0 0
0 0 1
0 1 0 
0 1 1
1 0 0
1 0 1
1 1 0
1 1 1
```

which means that for each list of masks, there's 2^n addresses to generate

struggled a bit with the logic and was really baffled, but got saved by the nim compiler from my own mistake
```
nim c -r --verbosity:0 part2.nim
............
/Users/stephen/devel/hownowstephen/adventofcode/2020/dec14/part2.nim(16, 13) Hint: 'addrIn' is declared but not used [XDeclaredButNotUsed]
```

I had been setting the mask bits just to the ones in the mask, instead of starting it out as the address. Otherwise the final logic came down to:

- generate a list of integers with single bits set (our floating bits)
- apply all ones directly to the input address since they're always set
- the 2 ^ the length of the floating bits will be the number of memory addresses that we need to set so loop over that
- grab which bits are set in the loop var (so 0->0; 1->1, 2->2, 3->1,2, 4->3)
    - if it is set, `or` with the corresponding mask
    - otherwise `and` with the inverse of the mask (set to zero)
- and then set that memory address to the value provided

I quite enjoyed working with Nim, the compiler is expressive, the documentation is good, and the syntax really does pull good things from ada, python, c++. Definitely the easiest language I've worked with so far

### Dec 15th: [OCaml](https://ocaml.org/)

to run
```
make clean && make run
make clean && make run2
```

Apparently this isn't the first of the ML family on my list, F# was also an ML variant. But nevertheless, something's always stuck in my head about OCaml (possibly just the camel logo tbh) so interested to give it a go. Starting with some tutorials from https://riptutorial.com/ocaml/example/7096/hello-world

As is the new norm, going to start with hardcoding my inputs and then figure out file io afterwards. So we'll need to start with a list https://ocaml.org/releases/4.11/htmlman/libref/List.html here's a tutorial http://xahlee.info/ocaml/ocaml_list.html

Was running into an error with variables being generalized - this seems to be tied to strong typing and also examples I was pulling from being for REPL code? Explicit type setting https://stackoverflow.com/questions/32489771/variables-that-cannot-be-generalized worked `let table : (int, int) Hashtbl.t`

My plan is just to loop from 1...2020 and calculate values as we go, so going to use a plain loop https://ocaml.org/learn/tutorials/if_statements_loops_and_recursion.html#For-loops-and-while-loops instead of the functional side for now. Best I can tell things are zero-indexed https://alhassy.github.io/OCamlCheatSheet/ just in case I end up needing the loop var will have to remember to sub 1

Going to define it as a function https://ocaml.org/learn/tutorials/basics.html#Defining-a-function. Also useful to know some ways of discarding returns to satisfy type constraints https://stackoverflow.com/questions/7382002/ocaml-print-statements

Fought with imperative for awhile then realized it really wanted me to recurse instead. So I did that, tracking state using the Hashtbl. The initial input set was a bit tricky, since instead of returning zeros they return their own value, but made that a branch in the process func and it all seems to work now.

Wasn't expecting part II to be just the same with a higher target, I guess they expected a less optimized solution for part one - the other way I'd considered was to generate a new array on each pass with the extra element, which for sure wouldnt've scaled to 30M

```
Hello, December 15th part II
573522

real	0m18.510s
user	0m15.935s
sys	0m0.275s
```

So good design choices in the beginning mean I'm done way quicker than expected, and part2 is identical with a different target. IMO runtime of <20s is pretty reasonable, there's probably some other way of storing the values that'd be even faster but I'm calling this Good Enough

### Dec 16th: [Pascal](https://www.freepascal.org/)

to run
```
make clean && make run
make clean && make run2
```

Time to take it back to 1970 with some Pascal. Looks like freepascal is pretty well supported, recent release was in June, phew. Let's hope that in the 50 years it's been around there's been some decent docs written. [This tutorial](https://wiki.freepascal.org/Category:Basic_Pascal_Introduction) seems promising. [Also this one](https://www.pascal-programming.info/lesson1.php)

Will need File IO later, but for now let's just hardcode some rules. Going to still use a [dynamic array](https://wiki.freepascal.org/Dynamic_array) since I'll need that later.

~Looks like since I'm using FPC I may need to be careful about what sources I use for language ref, syntax appears to maybe differ? The [type definition](https://wiki.freepascal.org/Type)~ nevermind, what I actually need to be careful about is reading things properly haha I misread the [var section](https://www.pascal-programming.info/lesson9.php) here as type and defined my type using `:` instead of `=`

seems like non-verbose static definition of variables isn't exactly a strong suit for pascal, that or there's tricks I've yet to come across. Anyway hardcoding these
```
    // class: 1-3 or 5-7
    names[0] := "class";
    rules[0][0][0] := 1;
    rules[0][0][1] := 3;
    rules[0][1][0] := 5;
    rules[0][1][1] := 7;

    // row: 6-11 or 33-44
    names[1] := "row";
    rules[1][0][0] := 6;
    rules[1][0][1] := 11;
    rules[1][1][0] := 33;
    rules[1][1][1] := 44;

    // seat: 13-40 or 45-50
    names[2] := "seat";
    rules[2][0][0] := 13;
    rules[2][0][1] := 40;
    rules[2][1][0] := 45;
    rules[2][1][1] := 50;
```

is fine for now, since when I get to the file side of things, that'll all be wrapped into the file reading.

Cool fact: pascal does memory alignment such that accessing elements out of array bounds will just return whatever's next in memory. Was iterating from `0 to length(x)` instead of `0 to length(x)-1` and getting some wacky results.

Anyway, that works now, so on we go to [File IO](https://wiki.freepascal.org/File_Handling_In_Pascal)

```
part1.pas(23,5) Error: Identifier not found "AssignFile"
part1.pas(26,5) Error: Identifier not found "try"
part1.pas(28,9) Fatal: Syntax error, ";" expected but "identifier RESET" found
```

which requires a different mode, fpc assumes turbopascal, but I should be using delphi mode [says stackoverflow](https://stackoverflow.com/questions/26553801/pascal-closefile-not-found) -- that seems to have solved my problems for now. Let's see about some string parsing after lunch

[string to int](https://www.freepascal.org/docs-html/rtl/sysutils/strtoint.html), string split seems like it's got all sorts of solutions, I think I'll use strutils though https://stackoverflow.com/questions/2625707/split-a-string-into-an-array-of-strings-based-on-a-delimiter. Pretty wild that string comparison is not native to the syntax https://stackoverflow.com/questions/33279216/how-do-i-compare-2-strings-in-pascal but with the delphi extensions I at least get something usable 

I think for parsing the three sections I'll use three `REPEAT UNTIL` blocks https://www.pascal-programming.info/lesson4.php. Also maybe overkill but I wrote [a function](https://www.tutorialspoint.com/pascal/pascal_functions.htm) to parse the actual rules. Had to use a custom return type, pascal doesn't allow bare array returns for some reason.

Also TStringlist doesn't work in `length` which junked me up for awhile, the [proper way](https://stackoverflow.com/questions/5183754/how-to-check-length-of-tstringlist-in-delphi) to grab length is with `TStringList.count`. Just needed to account for spaces in the original names (splitting the string twice instead of once) and we've got a solve

Now for part two what I'll need is
    - something to track potential valid rulesets for each field
    - something to find the fields I care about (the departure rules)

I think I might be able to use sets for the first, and the second I'll just generate a list of indices with the [departure prefix](https://www.programming-idioms.org/idiom/96/check-string-prefix/1231/pascal) as I parse the rules

Pascal sets can't be a set of integers, because that would let them be way too big - but we only need the set to be at most the length of the ticket. If we assume the ticket length is always < 256 (max size of a set) then we're ok here. And since I've seen the input, we are safe.

Ok I have some sets now, but in order to drill down to fields, I need to do something like
- for each set
- try to subtract all other sets
- if it comes up with one element, add that element to the base removal set
- and continue until we've calculated them all

Got a working program hours ago, and then got the wrong answer. Tricky because the sample wasn't long enough to actually validate the program in the specific bug I'd done, which was setting my mapping of `rule -> target` backwards, which gave the absolute wrong indexes but a reasonable-looking answer. Wasn't really in the headspace to do a pascal-only solve, so as a bonus I solved part2 in python and used that result to double-check my answers for the pascal version, and therein found the bug. Double P today, and I am DONE

### Dec 17th: [Racket](https://racket-lang.org/)

to run
```
racket part1.rkt
racket part2.rkt
```

What, no Q? Turns out there don't seem to be any mature languages that start with Q. Maybe this is a niche I can fill, but for now anyway I've got one skip because advent is shorter than the alphabet and I'm using it to skip through to Racket. Definitely needed to fit a lisp in somewhere!

Today we're doing a three dimensional game of life, I've never actually implemented GoL so should be an interesting one. Also it's on an infinite grid which will mean some clever work around growing the matrices. Also my new monitor arrived so I'm back on the meerkat, though it's not yet mounted to the monitor

```
sudo add-apt-repository ppa:plt/racket
sudo apt update
sudo apt install racket
```

Going to steal some ideas from https://github.com/kflu/game-of-life-racket/blob/master/life.rkt mostly to bootstrap myself into some basics by example. But also trying to do it mostly from the racket docs, starting with how do you print things out more generally https://docs.racket-lang.org/reference/Writing.html

Not sure if I should use vector or list, going to stick with vector for the time being, no particular reason.

So far mostly just playing with different ways of iteration etc, also discovering that negation isn't sugared https://stackoverflow.com/questions/39114564/why-are-not-equal-and-similar-negated-comparisons-not-built-into-racket which is pretty wild.

Got a basic implementation in 2d that just expands the matrix every time, which is probably going to be a problem going forward but I'll burn that bridge when I come to it. In the meantime, I think I might be able to just apply all the same ideas in 3d, let's find out

Going good so far, dropping in to note that `for*` is [a shorthand](https://docs.racket-lang.org/guide/for.html) for nested for loops, which maybe works also for `for/vector*` which would be a useful refactor for readability

Looking at the visual outputter was messing with me. I just had to believe in myself and use the values that made sense mathematically for offsetting. Got me to the right answer for part 1, and great news: part two is identical to the path I took - we're going to four dimensions BABY

Time to expand the dimensions one more time, which worked a treat. There's definitely plenty I could've done better in this one namely:
    - generalizing most of the functions to work with n-dimensional vectors
    - only expanding a vector if necessary
    - the print functionality didn't seem to be right, probably something was flipped around
    - using `for*` and `let*` to do some cleaner definitions (maybe not even necessary if we're supporting n-dimensions)

But that's where I'll be leaving it since it works and it took me less than 15 mins to go from 3 to 4 dimensions anyway.

### Dec 18th: [Swift](https://swift.org)

to run
```
swift part1.swift
swift part2.swift
```

Figure might as well give Swift a go. Also my chance to use some [emoji as variables](https://wolfmcnally.com/121/programming-with-fruit-using-emoji-swift/)

Today we're exploring a world without operator precedence, and doing some quick maffs on strings. Should be a fairly straightforward solve, going to start with a solution that works for non-bracket strings, then figure out a best way to split out bracketed groups (spoiler: probably just consuming the entire string up to the next closed bracket and applying the func to the internal)

Lots of unexpected functionality differences, like string subscripting isn't really a thing https://www.agnosticdev.com/content/how-get-first-or-last-characters-string-swift-4

also the types seem unnecessarily overdefined, like the suffix of a string comes out as a String.Subsequence so can't be assigned to a string and [needs to be cast](https://stackoverflow.com/questions/40186330/convert-subsequence-of-collection-to-string).

Nevermind, actually looks like there's just a whole other syntax for subscripting and it takes a `String.Index` type instead TIHI

Class constructor syntax also seems a little weird. why [two names](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html)

String [appending](https://reactgo.com/swift-append-character-string/) will help accumulate values in the numbers (to support multi-character numbers).

For simplicity, since the input is all space-delimited, I'll be using spaces as a signal, but if we wanted to support less strictly delimited maffs we'd need to check for ops as we go and if we run into one, interpret accordingly

OK got my maffs in place, now time to [read from a file](https://forums.swift.org/t/read-text-file-line-by-line/28852). Looks like this explains the constructor thing, I guess you can do different constructors and it interprets them based in the input vars? After a ton of fighting it turns out the issue I was running into:

```
error: extraneous argument label 'contentsOfFile:' in call
```

was because I didn't `import Foundation` - the main `Swift` stdlib seems to not have much for file IO I guess?

To do part two I can use more or less the same deal, except that we want an accumulator for the values to multiply - so instead of applying multiplication immediately, we drop `a` into a list whenever we encounter a multiplication operator and then we defer multiplication to the end of the evaluated block.

about a 20 min change, with some debugging (I was appending `b!` to mul instead of `a`, and zeroing `a` instead of setting it to `b!`) but otherwise we have another solve