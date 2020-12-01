package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"regexp"
	"strconv"
	"strings"
)

// const spreadsheet = `5 1 9 5
// 7 5 3
// 2 4 6 8`

var splitter = regexp.MustCompile(`\s+`)

func main() {

	if len(os.Args) == 1 {
		fmt.Println("specify a file")
		return
	}

	f, err := os.Open(os.Args[1])
	if err != nil {
		panic(err)
	}
	defer f.Close()

	spreadsheet, err := ioutil.ReadAll(f)
	if err != nil {
		panic(err)
	}

	var total, total2 int
	for _, line := range strings.Split(strings.TrimSpace(string(spreadsheet)), "\n") {

		values := splitter.Split(strings.TrimSpace(line), -1)

		ints := make([]int, len(values))
		intMap := make(map[int]struct{})
		for i, value := range values {
			v, err := strconv.Atoi(value)
			if err != nil {
				panic(err)
			}
			ints[i] = v
			intMap[v] = struct{}{}
		}

		var min, max int
		for _, i := range ints {
			if i < min || min == 0 {
				min = i
			}
			if i > max {
				max = i
			}
		}
		total += max - min

		for _, i := range ints {
			for j := 2; j <= max/min; j++ {
				if _, ok := intMap[i*j]; ok {
					total2 += j
					break
				}
			}
		}
	}
	fmt.Println("part1:", total)
	fmt.Println("part2:", total2)
}
