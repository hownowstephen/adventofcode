println "Hello, December 7th"

File input = new File("input.txt")

class BagGraph {
    List<Edge> bags

    BagGraph(){
        this.bags = []
    }

    void add(String colour, String[] contains) {
        contains.each { desc ->
            Edge e = new Edge(colour, desc)
            this.bags.push(e)
        }
    }

    Set<String> part1OuterBags(String colour) {
        Set<String> result = [] as Set;
        this.bags.each{ bag ->
            if(bag.inner == colour && !result.contains(bag.outer)){
                result << bag.outer
                result += part1OuterBags(bag.outer)
            }
        }
        return result
    }
}

import java.util.regex.Pattern

class Edge {
    String outer
    String inner
    Integer count

    Edge(String outer, String desc) {
        this.outer = outer
        
        def matcher = desc =~ /(?<count>[0-9]+) (?<type>.*) bags?/
        matcher.find()

        this.inner = matcher.group("type")
        this.count = matcher.group("count").toInteger()
    }

    String toString() { "$outer contains $count $inner bags" }
}


BagGraph graph = new BagGraph();

input.eachLine { String line ->
    String[] parts = line.replace(".", "").split(" bags contain ")
    if(parts[1] != "no other bags"){
        graph.add(parts[0], parts[1].split(", "))
    }
}

def part1 = graph.part1OuterBags("shiny gold").size();
println "part one: $part1"