package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
)

func main() {

	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	s := bufio.NewScanner(f)

	s.Split(bufio.ScanLines)

	max := make([]int, 3)
	var curr int
	for s.Scan() {
		i, err := strconv.Atoi(s.Text())
		if err != nil || i == 0 {
			curr = 0
		}
		curr += i
		if curr > max[0] {
			max[0] = curr
			sort.Ints(max)
		}
	}

	fmt.Println(max[0] + max[1] + max[2])

}
