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
	"strconv"
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

type line struct {
	left  int
	right int
}

func lineReader(f io.Reader) iter.Seq2[line, error] {
	return func(yield func(line, error) bool) {

		r := bufio.NewReader(f)
		for i := 0; ; i++ {
			l, _, err := r.ReadLine()
			if err != nil {
				if errors.Is(err, io.EOF) {
					break
				}
				yield(line{}, err)
				break
			}
			parts := strings.Split(string(l), "   ")
			if len(parts) != 2 {
				if !yield(line{}, fmt.Errorf("invalid input on line %d: %s"+string(l))) {
					break
				}
			}

			left, err := strconv.Atoi(parts[0])
			if err != nil {
				if !yield(line{}, fmt.Errorf("invalid lhs input on line %d: %s"+string(l))) {
					break
				}
			}
			right, err := strconv.Atoi(parts[1])
			if err != nil {
				if !yield(line{}, fmt.Errorf("invalid rhs input on line %d: %s"+string(l))) {
					break
				}
			}

			if !yield(line{left: left, right: right}, err) {
				return
			}
		}

	}
}

func solution1(f io.Reader) error {
	lhs := make([]int, 0)
	rhs := make([]int, 0)

	for l, err := range lineReader(f) {
		if err != nil {
			return err
		}
		lhs = append(lhs, l.left)
		rhs = append(rhs, l.right)
	}

	slices.Sort(lhs)
	slices.Sort(rhs)

	var total int
	for i := 0; i < len(lhs); i++ {
		v := lhs[i] - rhs[i]
		if v < 0 {
			v *= -1
		}
		total += v
	}

	fmt.Println("distance", total)

	return nil
}

func solution2(f io.Reader) error {
	lhs := make([]int, 0)
	counter := make(map[int]int)
	for l, err := range lineReader(f) {
		if err != nil {
			return err
		}
		counter[l.right]++
		lhs = append(lhs, l.left)
	}

	var total int
	for _, l := range lhs {
		total += l * counter[l]
	}

	fmt.Println("similarity", total)

	return nil
}
