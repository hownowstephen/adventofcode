package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

func fi(s string) int {
	i, _ := strconv.Atoi(s)
	return i
}

func main() {

	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	s := bufio.NewScanner(f)

	s.Split(bufio.ScanLines)

	re := regexp.MustCompile(`([0-9]+)-([0-9]+),([0-9]+)-([0-9]+)`)
	var total int
	for s.Scan() {
		matches := re.FindAllStringSubmatch(s.Text(), -1)

		start1, end1, start2, end2 := fi(matches[0][1]), fi(matches[0][2]), fi(matches[0][3]), fi(matches[0][4])

		if start1 >= start2 && end1 <= end2 || start2 >= start1 && end2 <= end1 {
			total++
		}

	}

	fmt.Println(total)

}
