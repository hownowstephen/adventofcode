package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
)

func main() {
	filePath := flag.String("file", "", "Path to the input file")
	flag.Parse()

	if *filePath == "" {
		log.Fatal("Please provide a file path")
	}

	file, err := os.Open(*filePath)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	sum := 0

	for scanner.Scan() {
		line := scanner.Text()
		first, last, concatenated := findFirstAndLastNumericValues(line)
		concatenatedInt, err := strconv.Atoi(concatenated)
		if err != nil {
			log.Fatal(err)
		}
		sum += concatenatedInt
		fmt.Printf("%s -> first:%s last:%s concat:%s\n", line, first, last, concatenated)
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	fmt.Println("Sum:", sum)
}

func findFirstAndLastNumericValues(line string) (string, string, string) {
	re := regexp.MustCompile(`(one|two|three|four|five|six|seven|eight|nine|\d)`)
	matches := re.FindAllString(line, -1)

	if len(matches) == 0 {
		return "", "", ""
	}

	first := convertToInt(matches[0])
	var last string
	if len(matches) > 1 {
		last = convertToInt(matches[len(matches)-1])
	}

	return first, last, concatenate(first, last)
}

func concatenate(first, last string) string {

	return first + last
}

func convertToInt(s string) string {
	mapping := map[string]string{
		"one":   "1",
		"two":   "2",
		"three": "3",
		"four":  "4",
		"five":  "5",
		"six":   "6",
		"seven": "7",
		"eight": "8",
		"nine":  "9",
	}

	if val, ok := mapping[s]; ok {
		return val
	}

	return s
}
