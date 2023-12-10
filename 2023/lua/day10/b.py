from collections import defaultdict
import pyperclip

with open('input.txt',"r") as f:
    dinput = f.read()

grid = dinput.strip().split("\n")

height = len(grid)
width = len(grid[0])
dirs = [
    [0, 1], # R
    [1, 0], # D
    [0, -1], # L
    [-1, 0], # U
]
starting_dir = [0, 1] # manual lol

# 9 is nothing
dirmapping = {
    '|': [9, 1, 9, 3],
    '-': [0, 9, 2, 9],
    'L': [9, 0, 3, 9],
    'J': [3, 2, 9, 9],
    '7': [1, 9, 9, 2],
    'F': [9, 9, 1, 0],
}

animal_x = 0
animal_y = 0
for i in range(height):
    for j in range(width):
        if "S" in grid[i]:
            animal_x = i
            animal_y = grid[i].find("S")

print('Start', animal_x, animal_y)
print('Starting direction', starting_dir)

current_dir = starting_dir[0]
current_x = animal_x + dirs[current_dir][0]
current_y = animal_y + dirs[current_dir][1]
length = 1

wall = [[0] * width for _ in range(height)] # part 2
wall[animal_x][animal_y] = 1 # Part 2

while (current_x, current_y) != (animal_x, animal_y):
    # print('Path', current_x, current_x, current_dir)

    wall[current_x][current_y] = 1 # Part 2

    current_dir = dirmapping[grid[current_x][current_y]][current_dir]
    current_x = current_x + dirs[current_dir][0]
    current_y = current_y + dirs[current_dir][1]

    length += 1


print('Lenght', length)
print('P1', length / 2)

strmap = ''

enclosed = 0
inside = False
for i in range(height):
    strmap = '{}\n{}'.format(strmap, ''.join(map(str, wall[i])))
    for j in range(width):
        if wall[i][j] and grid[i][j] in 'LJ|':
            inside = not inside

        elif inside and not wall[i][j]:
            enclosed += 1

# print(strmap)
print('P2', enclosed)
pyperclip.copy(strmap)
