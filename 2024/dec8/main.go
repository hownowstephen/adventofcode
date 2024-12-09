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
	f, err := os.Open("sample_input.txt")
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

type point struct {
	x, y int
}

func solution1(f io.Reader) error {
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
				if point, ok := checkPoint(v[j], p, maxX, maxY); ok {
					matrix[point.y][point.x] = "#"
				}
				if point, ok := checkPoint(p, v[j], maxX, maxY); ok {
					matrix[point.y][point.x] = "#"
				}
			}
		}
	}

	var count int
	for _, l := range matrix {
		count += strings.Count(strings.Join(l, ""), "#")
	}

	fmt.Println("total instances", count)
	return nil
}

func checkPoint(p1, p2 point, maxX, maxY int) (point, bool) {
	xPos := p1.x - (p2.x - p1.x)
	if xPos < 0 || xPos > maxX {
		return point{}, false
	}
	yPos := p1.y - (p2.y - p1.y)
	if yPos < 0 || yPos > maxY {
		return point{}, false
	}
	return point{x: xPos, y: yPos}, true
}
