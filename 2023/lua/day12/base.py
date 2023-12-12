from functools import cache
import tqdm

with open("input.txt") as file:
    lines = [x.strip() for x in file.readlines()]


# grid = []
# for i, line in enumerate(lines):
#     grid.append([])
#     for j, char in enumerate(line):
#         grid[i].append(char)


@cache
def parse(linput, restant, nrunning=None):
    if not linput:
        if nrunning:
            if len(restant) == 1 and nrunning == restant[0]:
                return 1
        else:
            if not restant:
                return 1

        return 0

    swapcount = linput.count('?') + linput.count('#')

    if nrunning:
        if swapcount + nrunning < sum(restant):
            return 0

        if not restant:
            return 0

    else:
        if swapcount < sum(restant):
            return 0

    if nrunning:
        # print('subparse with c', linput, restant, nrunning)
        return subparse_with_count(linput, restant, nrunning)

    # print('subparse', linput, restant)
    return subparse(linput, restant)


@cache
def subparse_with_count(linput, restant, cc):
    count = 0

    if linput[0] == '.' and cc != restant[0]:
        return 0

    if linput[0] == '.':
        count += parse(linput[1:], restant[1:])

    if linput[0] == '?' and cc == restant[0]:
        count += parse(linput[1:], restant[1:])

    if linput[0] in '#?':
        count += parse(linput[1:], restant, cc + 1)

    # print('sc', linput, restant, cc)

    return count


@cache
def subparse(linput, restant):
    count = 0

    if linput[0] in '?#':
        count += parse(linput[1:], restant, 1)

    if linput[0] in '?.':
        count += parse(linput[1:], restant)

    # print('s', linput, restant, ':', count)

    return count


def calc(values, part):
    ret = 0

    # for line in lines:
    #     # print(line.count('?'))
    #     # smax = max(smax, line.count('?'))
    #
    #     c = len(bin(2 ** line.count('?'))[2:])
    #     for i in range(2 ** (line.count('?'))):
    #         newline = line.split(" ")[0]
    #
    #         b = '{{:0>{}}}'.format(c + 2)
    #         b = b.format(bin(i)[2:])
    #
    #         print(b, len(b), newline, len(newline))
    #
    #         k = 0
    #         for idx, j in enumerate(newline):
    #             if j == '?':
    #                 k += 1
    #             else:
    #                 continue
    #
    #             print(idx, j, k, b[k])
    #             # newline[idx] = '.' if b[idx] == '1' else '#'
    #             newline = newline[:k] + '.' if b[k] == '1' else '#' + newline[k+1:]
    #
    #         print(line, newline)
    #         continue

    for idx, line in tqdm.tqdm(enumerate(lines)):
        springs, groups = line.split(" ")
        groups = list(map(int, groups.split(",")))

        if part == 1:
            # wtf putin de bordel de merde (qui a la ref?)
            ret += parse(springs, tuple(groups)) # list not hashable

        if part == 2:
            newline = '?'.join([springs] * 5)

            # print(idx, springs, groups)
            # print('\t=>', newline)
            ret += parse(newline, tuple(groups * 5))

    return ret

print('P1', calc(lines, 1))
print('P2', calc(lines, 2))
