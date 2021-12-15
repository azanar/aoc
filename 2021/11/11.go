package main;

import "bufio"
import "fmt"
import "os"
import "strconv"

//import "container/list"

//import "github.com/davecgh/go-spew/spew"
import "github.com/golang-collections/collections/stack"


type Grid map[int]map[int]int

func main() {
	grid := Grid{};

	scanner := bufio.NewScanner(os.Stdin)
	scanner.Split(bufio.ScanRunes)

	row := 0
	col := 0
	passes := 1
	if arg, err := strconv.Atoi(os.Args[1]); err == nil {
		passes = arg
	}

	for scanner.Scan() {
		tok := scanner.Text()
		if(tok == "\n") {
			row += 1
			col = 0
		}
		if val, err := strconv.Atoi(tok); err == nil{
			if grid[row] == nil {
				grid[row] = make(map[int]int, 0)
			}
			grid[row][col] = val
			col += 1
		}
	}

	flashes := 0

	for s := 0; s < passes; s++ {
		res := step(grid)

		grid = res.Grid
		flashes += res.Flashes
		fmt.Println(res.Flashes)
		//spew.Dump(res.Flashes)
	}
}

type Coordinate struct {
	row int
	col int
}

type Result struct {
	Grid
	Flashes int
}

func step(prior Grid) Result {
	st := stack.New()
	blinkedCoords := map[Coordinate]bool{}

	grid := Grid{}

	for row, rowvals := range prior {
		for col, _ := range rowvals {
			if grid[row] == nil {
				grid[row] = make(map[int]int, 0)
			}

			grid[row][col] = prior[row][col]

			if grid[row][col] < 10 {
				grid[row][col] += 1
				if grid[row][col] == 10 {
					coord := Coordinate{row: row, col: col}
					st.Push(coord)
				}
			}
		}
	}

	for st.Len() > 0 {
		cand := st.Pop().(Coordinate)

		if _, candAlreadyBlinked := blinkedCoords[cand]; candAlreadyBlinked == true {
			continue
		}

		blinkedCoords[cand] = true

		coords := filterInvalidCoordinates(adjacents(cand), grid)

		for _, coord := range coords {
			if grid[coord.row][coord.col] < 10 {
				grid[coord.row][coord.col] += 1
				if grid[coord.row][coord.col] == 10 {
					coord := Coordinate{row: coord.row, col: coord.col}
					st.Push(coord)
				}
			}
		}
	}

	for coord, _ := range blinkedCoords {
		grid[coord.row][coord.col] = 0
	}

	return Result{Grid: grid, Flashes: len(blinkedCoords)}
}

func filterInvalidCoordinates(cc []Coordinate, grid Grid) []Coordinate {
	vc := []Coordinate{}

	for _, c := range cc {
		if (c.row >= 0 && c.row < len(grid) && c.col >= 0 && c.col < len(grid[0])) {
			vc = append(vc, c)
		}
	}
	return vc
}

func adjacents(c Coordinate) []Coordinate {
	adjVectors := [...]Coordinate{ Coordinate{row: -1,col: -1}, Coordinate{row: -1,col: 0}, Coordinate{row: -1,col: 1}, Coordinate{row: 0,col: -1}, Coordinate{row: 0, col: 1}, Coordinate{row: 1,col: -1}, Coordinate{row: 1,col: 0}, Coordinate{row: 1,col: 1} }

	coords := []Coordinate{}

	for _, vec := range adjVectors {
		coords = append(coords,Coordinate{row : c.row + vec.row, col: c.col + vec.col})
	}
	return coords
}
