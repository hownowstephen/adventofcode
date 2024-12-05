package main

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"iter"
	"log"
	"os"
	"slices"
	"strings"
)

func main() {
	f, err := os.Open("input.txt")
	if err != nil {
		log.Fatal("could not open file", err)
	}
	defer f.Close()

	if err := solution2(f); err != nil {
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

func solution2(f io.Reader) error {
	matrix := make([][]string, 0)
	for l := range lineReader(f) {
		matrix = append(matrix, l)
	}

	var count int
	for i := 0; i < len(matrix); i++ {
		for j := 0; j < len(matrix[i]); j++ {
			if matrix[i][j] == "A" {
				if corners(matrix, j, i) {
					count++
				}
			}
		}
	}

	fmt.Println("total instances", count)
	return nil
}

func corners(matrix [][]string, x, y int) bool {
	if y-1 < 0 || y+1 >= len(matrix) || x-1 < 0 || x+1 >= len(matrix[y]) {
		return false
	}

	c1 := []string{matrix[y-1][x-1], matrix[y+1][x+1]}
	c2 := []string{matrix[y-1][x+1], matrix[y+1][x-1]}
	slices.Sort(c1)
	slices.Sort(c2)

	return slices.Equal(c1, []string{"M", "S"}) && slices.Equal(c2, []string{"M", "S"})
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
