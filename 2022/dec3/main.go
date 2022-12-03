package main

import (
	"bufio"
	"fmt"
	"os"

	"github.com/customerio/bitmaps/fixed"
)

func main() {

	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	s := bufio.NewScanner(f)

	s.Split(bufio.ScanLines)

	var b = [2]*fixed.Bitmap{
		fixed.NewBitmap(122 - 65),
		fixed.NewBitmap(122 - 65),
	}

	var total uint32
	for s.Scan() {
		line := s.Text()
		for i := range line {
			b[i/(len(line)/2)].AddInt(int(line[i]) - 65)
		}

		b[0].And(b[1])

		// 65 = A = 27
		// 66 = B = 28

		for _, v := range b[0].ToArray() {
			if v > 32 {
				total += v - 31
			} else {
				total += v + 27
			}
		}

		b[0].Clear()
		b[1].Clear()
	}

	fmt.Println(total)

}
