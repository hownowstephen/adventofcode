printfn "Hello, December 6th"

open System;
open System.IO;
open System.Collections.Generic;

let lines = File.ReadLines("input.txt")       


let mutable count = 0
let answers :HashSet<char> = new HashSet<char>();
for line in lines do
    if line = "" then
        count <- count + answers.Count
        answers.ExceptWith(answers)
    else answers.UnionWith(Set.ofList(Seq.toList(line)));


count <- count + answers.Count
printfn "%d" count