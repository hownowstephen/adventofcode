# [Advent of Code 2020](https://adventofcode.com/2020)

Goal is to use a new language every day, [alphabetically](https://en.wikipedia.org/wiki/List_of_programming_languages)

### Dec 1st: [Ada](https://www.adacore.com/get-started)

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