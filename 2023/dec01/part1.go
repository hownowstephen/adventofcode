package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"
	"strconv"
)

func main() {
	// Define command-line flag for file input
	filePath := flag.String("file", "", "path to the input file")
	flag.Parse()

	// Open the input file
	file, err := os.Open(*filePath)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	// Read the file line by line
	scanner := bufio.NewScanner(file)
	var numbers []int
	for scanner.Scan() {
		line := scanner.Text()
		// Find the first and last numeric value in the line
		first, last := findFirstAndLastNumericValue(line)
		// Concatenate the first and last values
		concatenated := fmt.Sprintf("%d%d", first, last)
		// Convert the concatenated string to an integer
		num, err := strconv.Atoi(concatenated)
		if err != nil {
			log.Fatal(err)
		}
		// Append the number to the list
		numbers = append(numbers, num)
	}

	// Print the sum of the list of integers
	sum := 0
	for _, num := range numbers {
		sum += num
	}
	fmt.Println("Sum:", sum)
}

// Function to find the first and last numeric value in a string
func findFirstAndLastNumericValue(s string) (int, int) {
	first := -1
	last := -1
	for _, char := range s {
		if char >= '0' && char <= '9' {
			if first == -1 {
				first = int(char - '0')
			}
			last = int(char - '0')
		}
	}
	return first, last
}
