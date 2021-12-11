import itertools
import sys

lowpoints = []

data = sys.stdin.readlines()

grid = [[int(ll) for ll in list(l.strip())] for l in data]

height = len(grid)
width = len(grid[0])
bounds = (height, width)

r = [-1, 0, 1]

nntrans = list(filter(lambda x: x != (0,0), itertools.product(r, r)))

def within_bounds_p(coord, bounds):
    y,x = coord
    height, width = bounds
    return 0 <= x and x < width and 0 <= y and y < height

def vec_add(coord, trans):
    return map(sum, zip(coord, trans))

def neighbors(coord, vecs):
    return [list(vec_add(coord, v)) for v in vecs]

def coords_within_bounds(coords, bounds):
    return [c for c in coords if within_bounds_p(c, bounds)]

for coord in itertools.product(range(height), range(width)):
    ch = grid[coord[0]][coord[1]]
    walk = coords_within_bounds(neighbors(coord, nntrans), bounds)
    walkv = [grid[n[0]][n[1]] for n in walk]
    lowers = [h <= ch for h in walkv]
    if not any(lowers):
        lowpoints += [coord]

basins = []

for lp in lowpoints:
    basin = []
    basins.append(basin)
    stack = []
    stack.append(lp)
    while(stack):
        p = stack.pop()
        if p in basin:
            continue

        basin.append(p)

        ch = grid[p[0]][p[1]]
        new_neighbors = [n for n in neighbors(p, [[0,1],[0,-1],[1,0],[-1,0]]) if n not in basin]
        walk = coords_within_bounds(new_neighbors, bounds)
        walkv = [ {'c': n, 'v': grid[n[0]][n[1]]} for n in walk]
        highers = [c['c'] for c in walkv if (c['v'] > ch and c['v'] != 9)]

        stack.extend(highers)

print(sorted([len(basin) for basin in basins], reverse=True)[0:3])
