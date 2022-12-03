package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

var values = map[string]int{
	"A": 0,
	"B": 1,
	"C": 2,
	"X": 0,
	"Y": 1,
	"Z": 2,
}

func score(opponent, me string) int {
	if values[opponent] == values[me] {
		return 3
	} else if values[opponent] == (values[me]+1)%3 {
		return 0
	} else {
		return 6
	}
}

func main() {

	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	s := bufio.NewScanner(f)
	s.Split(bufio.ScanLines)

	var total int
	for s.Scan() {
		round := strings.SplitN(s.Text(), " ", 2)
		opponent, me := round[0], round[1]
		total += values[me] + 1 + score(opponent, me)
	}

	fmt.Println(total)

}
