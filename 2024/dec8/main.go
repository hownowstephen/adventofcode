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

type point struct {
	x, y int
}

func solution2(f io.Reader) error {
	matrix := make([][]string, 0)
	for l, err := range lineReader(f) {
		if err != nil {
			return err
		}
		matrix = append(matrix, l)
	}

	var points = make(map[string][]point)

	var maxX, maxY = len(matrix[0]) - 1, len(matrix) - 1

	for i := 0; i < len(matrix); i++ {
		for j := 0; j < len(matrix[i]); j++ {
			if matrix[i][j] == "." {
				continue
			}
			points[matrix[i][j]] = append(points[matrix[i][j]], point{x: j, y: i})
		}
	}

	for _, v := range points {
		for i, p := range v {
			for j := i + 1; j < len(v); j++ {
				for point := range checkPoint(v[j], p, maxX, maxY) {
					matrix[point.y][point.x] = "#"
				}
				for point := range checkPoint(p, v[j], maxX, maxY) {
					matrix[point.y][point.x] = "#"
				}
			}
			matrix[p.y][p.x] = "#"
		}
	}

	var count int
	for _, l := range matrix {
		fmt.Println(l)
		count += strings.Count(strings.Join(l, ""), "#")
	}

	fmt.Println("total instances", count)
	return nil
}

func checkPoint(p1, p2 point, maxX, maxY int) iter.Seq[point] {
	return func(yield func(point) bool) {
		for i := 1; i < max(maxX, maxY); i++ {
			xPos := p1.x - i*(p2.x-p1.x)
			if xPos < 0 || xPos > maxX {
				break
			}
			yPos := p1.y - i*(p2.y-p1.y)
			if yPos < 0 || yPos > maxY {
				break
			}
			yield(point{x: xPos, y: yPos})
		}
	}
}
