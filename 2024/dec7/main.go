package main

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"iter"
	"log"
	"os"
	"strconv"
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

type line struct {
	result int
	params []int
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
			parts := strings.Split(string(l), ":")
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

			params := make([]int, 0)
			for _, p := range strings.Split(strings.TrimSpace(parts[1]), " ") {
				v, err := strconv.Atoi(p)
				if err != nil {
					if !yield(line{}, fmt.Errorf("invalid rhs input on line %d: %s"+string(l))) {
						break
					}
				}
				params = append(params, v)
			}

			if !yield(line{result: left, params: params}, err) {
				return
			}
		}

	}
}

func solution1(f io.Reader) error {
	var total int
	for l, err := range lineReader(f) {
		if err != nil {
			return err
		}

		if isValid(l) {
			fmt.Println("valid", l)
			total += l.result
		}
	}

	fmt.Println("total calibration result", total)

	return nil
}

func isValid(l line) bool {
	for value := range try(l.params[0], l.params[1:]) {
		if value == l.result {
			return true
		}
	}
	return false
}

func try(v int, nums []int) iter.Seq[int] {
	return func(yield func(int) bool) {
		if len(nums) == 0 {
			yield(v)
			return
		}
		for res := range try(v*nums[0], nums[1:]) {
			if !yield(res) {
				return
			}
		}
		for res := range try(v+nums[0], nums[1:]) {
			if !yield(res) {
				return
			}
		}

		// solution 2
		for res := range try(strcat(v, nums[0]), nums[1:]) {
			if !yield(res) {
				return
			}
		}
	}
}

func strcat(v, n int) int {
	c, _ := strconv.Atoi(strconv.Itoa(v) + strconv.Itoa(n))
	return c
}

func sum(nums []int) int {
	fmt.Println("SUM", nums)
	var total int
	for _, v := range nums {
		total += v
	}
	return total
}

func product(nums []int) int {
	fmt.Println("PRODUCT", nums)
	total := 1
	for _, v := range nums {
		total *= v
	}
	return total
}
