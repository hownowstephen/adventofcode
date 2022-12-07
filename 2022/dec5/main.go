package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {

	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	s := bufio.NewScanner(f)

	s.Split(bufio.ScanLines)

	var buckets [][]byte
	for s.Scan() {

		t := s.Text()
		if strings.TrimSpace(t) == "" {
			break
		}

		var b []byte
		for i := 0; i < len(t); i += 4 {
			b = append(b, t[i+1])
		}

		buckets = append(buckets, b)
	}

	// bucket ids, not needed
	buckets = buckets[:len(buckets)-1]

	stacks := make([][]byte, len(buckets[0]))
	for i := len(buckets) - 1; i >= 0; i-- {
		for j, e := range buckets[i] {
			if e == byte(' ') {
				continue
			}
			stacks[j] = append(stacks[j], e)
		}
	}

	for s.Scan() {
		command := strings.Split(s.Text(), " ")

		count, src, dst := fi(command[1]), fi(command[3])-1, fi(command[5])-1

		stacks[dst] = append(stacks[dst], stacks[src][len(stacks[src])-count:]...)
		stacks[src] = stacks[src][:len(stacks[src])-count]
	}

	for _, stack := range stacks {
		fmt.Print(string(stack[len(stack)-1]))
	}
	fmt.Println()

}

func fi(s string) int {
	i, _ := strconv.Atoi(s)
	return i
}
