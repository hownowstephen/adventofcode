package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func mod(v int, m int) int {
	if v < 0 {
		return mod(v+m, m)
	}
	return v % m
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
		opponent, goal := int(round[0][0])-65, int(round[1][0])-88

		total += goal*3 + mod(opponent+(goal-1), 3) + 1
	}

	fmt.Println(total)

}
