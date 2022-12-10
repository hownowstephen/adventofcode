package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type dir struct {
	parent   *dir
	children map[string]*dir
	size     int
}

func newDir(parent *dir) *dir {
	return &dir{
		parent:   parent,
		children: make(map[string]*dir),
	}
}

func (d *dir) root() *dir {
	if d.parent == nil {
		return d
	}
	return d.parent.root()
}

func (d *dir) incrSz(amt int) {
	d.size += amt
	if d.parent == nil {
		return
	}
	d.parent.incrSz(amt)
}

func (d *dir) sizes() []int {
	var sz []int
	for _, child := range d.children {
		sz = append(sz, child.sizes()...)
	}
	return append(sz, d.size)
}

func main() {

	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	s := bufio.NewScanner(f)

	s.Split(bufio.ScanLines)

	var cwd = newDir(nil)
	var root = cwd
	for s.Scan() {
		t := s.Text()

		if t[0] == '$' {
			if strings.HasPrefix(t, "$ cd") {
				if t[5:] == ".." {
					cwd = cwd.parent
					continue
				} else if t[5:] == "/" {
					cwd = cwd.root()
					continue
				}

				dir, ok := cwd.children[t[5:]]
				if !ok {
					panic(fmt.Sprintf("couldnt find dir %s", t[5:]))
				}

				cwd = dir
			}
			continue
		}

		if strings.HasPrefix(t, "dir ") {
			cwd.children[t[4:]] = newDir(cwd)
			continue
		}

		sz, err := strconv.Atoi(strings.SplitN(t, " ", 2)[0])
		if err != nil {
			panic(err)
		}

		cwd.incrSz(sz)
	}

	var sum int
	for _, sz := range root.sizes() {
		if sz < 100000 {
			sum += sz
		}
	}
	fmt.Println(sum)

}
