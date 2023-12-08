import re
import math

lines = [x for x in open("input.txt").read().strip().split('\n\n')]

path = list(lines[0])
network = {}

for line in lines[1].split("\n"):
    m = re.match('^([A-Z]{3}) = \(([A-Z]{3}), ([A-Z]{3})\)$', line)
    network[m.group(1)] = [m.group(2), m.group(3)]

pos = 'AAA'
part_1 = 0

i = 0
while pos != 'ZZZ':
    if path[i % len(path)] == 'L':
        pos = network[pos][0]

    else:
        pos = network[pos][1]

    # print(pos)
    i += 1

part_1 = i

print("P1", part_1)
print("=" * 50)

tries = []
for start in network:
    if start.endswith('A'):
        pos = start
        i = 0

        # while pos != 'ZZZ':
        while not pos.endswith('Z'):
            if path[i % len(path)] == 'L':
                pos = network[pos][0]

            else:
                pos = network[pos][1]

            # print(pos)
            i += 1

        tries.append(i)
        print(start, i)

part_2 = 1
for i in tries:
    part_2 = math.lcm(part_2, i)

print("P2", part_2)
