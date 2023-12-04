package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"strconv"
	"strings"
)

type Game struct {
	ID    int
	Cubes []map[string]int
}

func parseGameInfo(filename string) ([]Game, error) {
	content, err := ioutil.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	lines := strings.Split(string(content), "\n")
	games := make([]Game, 0)

	for _, line := range lines {
		if line == "" {
			continue
		}

		parts := strings.Split(line, ": ")
		id, err := strconv.Atoi(strings.TrimPrefix(parts[0], "Game "))
		if err != nil {
			return nil, err
		}

		cubes := make([]map[string]int, 0)
		subsets := strings.Split(parts[1], "; ")
		for _, subset := range subsets {
			cubeCounts := make(map[string]int)
			colorCounts := strings.Split(subset, ", ")
			for _, colorCount := range colorCounts {
				colorParts := strings.Split(colorCount, " ")
				color := colorParts[1]
				count, err := strconv.Atoi(colorParts[0])
				if err != nil {
					return nil, err
				}
				cubeCounts[color] = count
			}
			cubes = append(cubes, cubeCounts)
		}

		game := Game{
			ID:    id,
			Cubes: cubes,
		}
		games = append(games, game)
	}

	return games, nil
}

func isPossibleGame(game Game, redCubes, greenCubes, blueCubes int) bool {
	for _, subset := range game.Cubes {
		redCount, greenCount, blueCount := subset["red"], subset["green"], subset["blue"]
		if redCount > redCubes || greenCount > greenCubes || blueCount > blueCubes {
			return false
		}
	}

	return true
}

func sumPossibleGameIDs(games []Game, redCubes, greenCubes, blueCubes int) int {
	sum := 0
	for _, game := range games {
		if isPossibleGame(game, redCubes, greenCubes, blueCubes) {
			sum += game.ID
		}
	}
	return sum
}

func main() {
	games, err := parseGameInfo("game_info.txt")
	if err != nil {
		log.Fatal(err)
	}

	redCubes := 12
	greenCubes := 13
	blueCubes := 14

	sum := sumPossibleGameIDs(games, redCubes, greenCubes, blueCubes)
	fmt.Println(sum)
}
