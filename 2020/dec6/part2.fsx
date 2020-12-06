printfn "Hello, December 6th"

open System;
open System.IO;
open System.Collections.Generic;

let lines = File.ReadLines("input.txt")       


let mutable count = 0
let mutable newGroup = true
let answers :HashSet<char> = new HashSet<char>();
for line in lines do
    if line = "" then
        count <- count + answers.Count
        newGroup <- true
        answers.ExceptWith(answers)
    else if newGroup then
        newGroup <- false
        answers.UnionWith(Set.ofList(Seq.toList(line)))
    else answers.IntersectWith(Set.ofList(Seq.toList(line)))


count <- count + answers.Count
printfn "%d" count