package main

import (
	"bufio"
	"fmt"
	"os"
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

	var max, curr int
	for s.Scan() {
		i, err := strconv.Atoi(s.Text())
		if err != nil || i == 0 {
			curr = 0
		}
		curr += i
		if curr > max {
			max = curr
		}
	}

	fmt.Println(max)

}
