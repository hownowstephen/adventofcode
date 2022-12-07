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

	for s.Scan() {
		t := s.Text()

		b := []byte(t[:4])
		for i := 4; i < len(t); i++ {
			if uniq(b) {
				fmt.Println(i)
				break
			}
			b[i%4] = t[i]
		}
	}

}

func uniq(b []byte) bool {
	m := make(map[byte]struct{})
	for _, elem := range b {
		if _, ok := m[elem]; ok {
			return false
		}
		m[elem] = struct{}{}
	}
	return true
}

func fi(s string) int {
	i, _ := strconv.Atoi(s)
	return i
}
