package main

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"iter"
	"log"
	"os"
	"strings"
)

func main() {
	f, err := os.Open("input.txt")
	if err != nil {
		log.Fatal("could not open file", err)
	}
	defer f.Close()

	if err := solution1(f); err != nil {
		log.Fatal(err)
	}
}

func lineReader(f io.Reader) iter.Seq2[[]string, error] {
	return func(yield func([]string, error) bool) {

		r := bufio.NewReader(f)
		for i := 0; ; i++ {
			l, _, err := r.ReadLine()
			if err != nil {
				if errors.Is(err, io.EOF) {
					break
				}
				yield(nil, err)
				break
			}

			if !yield(strings.Split(string(l), ""), err) {
				return
			}
		}

	}
}

func solution1(f io.Reader) error {
	matrix := make([][]string, 0)
	for l := range lineReader(f) {
		matrix = append(matrix, l)
	}

	var count int
	for i := 0; i < len(matrix); i++ {
		for j := 0; j < len(matrix[i]); j++ {
			if matrix[i][j] == "X" {
				for direction := range findAdjacent(matrix, j, i, "M") {
					if check(matrix, j+direction.x, i+direction.y, direction, "A", "S") {
						count++
					}
				}
			}
		}
	}

	fmt.Println("total instances", count)
	return nil
}

func check(matrix [][]string, x, y int, d direction, chars ...string) bool {
	for _, c := range chars {
		x += d.x
		y += d.y
		if y < 0 || y >= len(matrix) || x < 0 || x >= len(matrix[y]) {
			return false
		}
		if matrix[y][x] != c {
			return false
		}
	}
	return true
}

type direction struct {
	x int
	y int
}

func findAdjacent(matrix [][]string, sx, sy int, adj string) iter.Seq[direction] {
	return func(yield func(direction) bool) {
		if len(adj) == 0 {
			return
		}

		for y := sy - 1; y <= sy+1; y++ {
			if y < 0 || y >= len(matrix) {
				continue
			}
			for x := sx - 1; x <= sx+1; x++ {
				if x < 0 || x >= len(matrix[y]) || (x == sx && y == sy) {
					continue
				}
				if matrix[y][x] == adj {
					if !yield(direction{x: x - sx, y: y - sy}) {
						return
					}
				}
			}
		}
	}
}
