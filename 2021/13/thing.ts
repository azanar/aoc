const fs = require('fs')

const dot_re = /(\d+),(\d+)/
const fold_re = /fold along ([xy])=(\d+)/

type Dot = {
  x: number,
  y: number
}

type Axis = "x" | "y"

type Fold = {
  axis: Axis,
  rank: number
}

type Context =
  { dots: Dot[], folds: Fold[] }


function parse(data: string) {
  let parsed: Context = {
    dots: [],
    folds: []
  }
  for (const line of data.split("\n")) {
    let groups = line.match(dot_re)
    if (groups !== null) {
      parsed.dots.push({ x: Number.parseInt(groups[1]), y: Number.parseInt(groups[2]) })
    }

    groups = line.match(fold_re)
    if (groups !== null) {
      if (groups[1] === "x" || groups[1] === "y") {
        parsed.folds.push({ axis: groups[1], rank: Number.parseInt(groups[2]) })
      }
    }
  }
  return parsed;
}

function pivot(grid: Dot[]): Map<number, Set<number>> {
  let pivoted: Map<number, Set<number>> = new Map()

  for (const dot of grid) {
    if (!pivoted.has(dot.x)) {
      pivoted.set(dot.x, new Set());
    }
    let s = pivoted.get(dot.x)
    if (s === undefined) {
      console.error("ugh")
    } else {
      s.add(dot.y)
    }
  }
  return pivoted
}

function dedup(grid: Dot[]) {
  let pivoted: Map<number, Set<number>> = pivot(grid)

  let unpivoted: Dot[] = []

  for (const [x, ys] of pivoted) {
    for (const yy of ys) {
      let dot: Dot = { x: x, y: yy }
      unpivoted.push(dot)
    }
  }
  return unpivoted

}

function dofold(grid: Dot[], fold: Fold): Dot[] {
  let folded: Dot[] = []

  for (const dot of grid) {
    let pivot: Axis;
    switch (fold.axis) {
      case 'x': pivot = 'x'; break
      case 'y': pivot = 'y'; break
      default:
        console.error(`unknown axis ${fold.axis}`)
        throw `unknown axis ${fold.axis}`
    }
    if (dot[pivot] < fold.rank) {
      folded.push(dot)
    } else {
      const folddot = Object.assign({}, dot)
      const delta = (dot[pivot] - fold.rank)
      const distance = delta * 2
      folddot[pivot] -= distance
      if (folddot[pivot] < 0) {
        throw `coordinate can not be negative ${dot[pivot]} ${fold.rank} ${distance}`
      }
      folded.push(folddot)
    }
  }
  return folded;
}

function display(grid: Dot[]) {
  let bounds = null

  for (const dot of grid) {
    if (bounds === null) {
      bounds = {
        x: { min: dot.x, max: dot.x },
        y: { min: dot.y, max: dot.y }
      }
    } else {
      if (dot.x < bounds.x.min)
        bounds.x.min = dot.x
      if (dot.x > bounds.x.max)
        bounds.x.max = dot.x
      if (dot.y < bounds.y.min)
        bounds.y.min = dot.y
      if (dot.y > bounds.y.max)
        bounds.y.max = dot.y

    }
  }

  console.log(grid)
  console.log(bounds)
  if (bounds === null) {
    throw "wtf"
  }

  let pivoted: Map<number, Set<number>> = pivot(grid)

  for (const y of Array.from({ length: bounds.y.max + 1 }, (x, i) => i)) {

    for (const x of Array.from({ length: bounds.x.max + 1 }, (x, i) => i)) {
      if (pivoted.get(x)?.has(y)) {
        process.stdout.write("#")
      } else {
        process.stdout.write(".")
      }
    }
    process.stdout.write("\n")

  }
}

function run(parsed: Context) {

  let dots: Dot[] = parsed.dots
  for (const fold of parsed.folds) {
    const folded = dofold(dots, fold)
    dots = dedup(folded)
  }
  display(dots)
}
fs.readFile('input.txt', 'utf8', (err: any, data: string) => {
  if (err) {
    console.error(err)
    return
  }

  let parsed = parse(data)
  let result = run(parsed)
})
