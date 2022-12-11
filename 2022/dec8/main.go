package main

import (
	"bufio"
	"fmt"
	"os"
)

const (
	n int = iota
	s
	e
	w
)

func main() {

	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)

	scanner.Split(bufio.ScanLines)

	var trees [][]byte
	var scores [][]int
	for scanner.Scan() {
		b := scanner.Bytes()
		line := make([]byte, len(b))
		for i := range b {
			line[i] = b[i]
		}
		trees = append(trees, line)
		scores = append(scores, make([]int, len(trees[0])))
	}

	var maxScore int
	for i := 0; i < len(trees); i++ {
		for j := 0; j < len(trees[i]); j++ {

			var scoreE int
			for x := j + 1; x < len(trees[i]); x++ {
				scoreE++
				if trees[i][x] >= trees[i][j] {
					break
				}
			}

			var scoreW int
			for x := j - 1; x >= 0; x-- {
				scoreW++
				if trees[i][x] >= trees[i][j] {
					break
				}
			}

			var scoreS int
			for y := i + 1; y < len(trees); y++ {
				scoreS++
				if trees[y][j] >= trees[i][j] {
					break
				}
			}

			var scoreN int
			for y := i - 1; y >= 0; y-- {
				scoreN++
				if trees[y][j] >= trees[i][j] {
					break
				}
			}

			total := scoreE * scoreW * scoreN * scoreS

			if total > maxScore {
				maxScore = total
			}
		}
	}

	fmt.Println(maxScore)

}
