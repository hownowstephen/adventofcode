package main

import (
	"bufio"
	"io"
	"os"
	"os/exec"
)

func main() {

	cmd := exec.Command("lci", os.Args[1])

	stdin, err := cmd.StdinPipe()
	if err != nil {
		panic(err)
	}

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Start(); err != nil {
		panic(err)
	}

	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}

	reader := bufio.NewScanner(f)

	for reader.Scan() {
		s := string(reader.Bytes())
		io.WriteString(stdin, s[:1]+"\n")
		io.WriteString(stdin, s[1:]+"\n")
	}

	io.WriteString(stdin, "\n")

	if err := cmd.Wait(); err != nil {
		panic(err)
	}
}
