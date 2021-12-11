import math
import sys

data = sys.stdin.readlines()

pairs = {
        '(': ')',
        '[': ']',
        '{': '}',
        '<': '>'
        }

scores = {
        ')': 1,
        ']': 2,
        '}': 3,
        '>': 4
        }

def process_line(l):
    stack = []
    for c in l:
        if c in pairs.keys():
            stack.append(c)
        else:
            expected = pairs[stack.pop()]
            if c != expected:
                print("Expected {} but saw {}".format(expected, c))
                return 0
    score = 0
    for c in reversed(stack):
        score = (score * 5) + scores[pairs[c]]
    return score

scores = sorted([p for p in [process_line(l.strip()) for l in data] if p > 0])
print(scores)
print(scores[math.floor(len(scores) / 2)])
