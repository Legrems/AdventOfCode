with open("input.txt") as file:
    lines = [x.strip() for x in file.readlines()]


grid = []
for i, line in enumerate(lines):
    grid.append([])
    for j, char in enumerate(line):
        grid[i].append(char)


def calc(values, part):
    ret = 0
    return ret


print('P1', calc(lines, 1))
print('P2', calc(lines, 2))
