package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {

	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)

	scanner.Split(bufio.ScanLines)

	var vis [][]bool
	var trees [][]byte
	for scanner.Scan() {
		b := scanner.Bytes()
		line := make([]byte, len(b))
		for i := range b {
			line[i] = b[i]
		}
		trees = append(trees, line)
		vis = append(vis, make([]bool, len(trees[0])))
	}

	var n = make([]byte, len(trees[0]))
	var s = make([]byte, len(trees[0]))
	for i := 0; i < len(trees); i++ {
		var w, e byte
		for j := 0; j < len(trees[i]); j++ {
			if trees[i][j] > n[j] {
				vis[i][j] = true
				n[j] = trees[i][j]
			}

			if inv := len(trees) - i - 1; trees[inv][j] > s[j] {
				vis[inv][j] = true
				s[j] = trees[inv][j]
			}

			if trees[i][j] > w {
				vis[i][j] = true
				w = trees[i][j]
			}

			if inv := len(trees[0]) - j - 1; trees[i][inv] > e {
				vis[i][inv] = true
				e = trees[i][inv]
			}
		}
	}

	var total int
	for i := 0; i < len(vis); i++ {
		for j := 0; j < len(vis[0]); j++ {
			if vis[i][j] {
				total++
			}
		}
	}
	fmt.Println(total)

}
