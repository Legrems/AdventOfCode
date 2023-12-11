lines = []
with open("input.txt") as file:
    lines = [x.strip() for x in file.readlines()]


def calc(values, part):
    grid = []
    for i, line in enumerate(values):
        grid.append([])
        for j, char in enumerate(line):
            grid[i].append(char)

    empty_col = []
    empty_row = []

    for i, x in enumerate(grid):
        if '#' not in x:
            empty_row.append(i)

    for i, _ in enumerate(grid):
        empty = True
        for j, _ in enumerate(grid[0]):
            if grid[j][i] == '#':
                empty = False

        if empty:
            empty_col.append(i)

    # print('emptyr', empty_row)
    # print('emptyc', empty_col)

    stars = []
    for i, _ in enumerate(grid):
        for j, val in enumerate(grid[i]):
            if val == '#':
                stars.append((j, i))
    # print(stars)

    ret = 0

    for i in range(len(stars)):
        for j in range(i + 1, len(stars)):

            starx, stary = stars[i]
            star2x, star2y = stars[j]

            # order so we have only one dir
            starx, star2x = min(starx, star2x), max(starx, star2x)
            stary, star2y = min(stary, star2y), max(stary, star2y)
            
            # print('---')
            # print(starx, stary)
            # print(star2x, star2y)

            # for edge
            count = -1

            for x in range(starx, star2x + 1):
                if x in empty_col:
                    if part == 1:
                        count += 1

                    else:
                        count += 999999

                count += 1

            # for edge
            count -= 1

            for y in range(stary, star2y + 1):
                if y in empty_row:
                    if part == 1:
                        count += 1

                    else:
                        count += 999999

                count += 1

            ret += count

    return ret

print('P1', calc(lines, 1))
print('P2', calc(lines, 2))
