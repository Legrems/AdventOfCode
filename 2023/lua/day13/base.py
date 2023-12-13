with open("input.txt") as file:
    # lines = [x.strip() for x in file.readlines()]
    data = file.read()

values = [d.split("\n") for d in data.strip().split("\n\n")]

def hlr(thing, p2=False):
    for i, line in enumerate(thing):

        # print(i, line, len(thing))

        if i + 1 == len(thing):
            return 0

        ipairs = []
        for l1, l2 in zip(thing[i::-1], thing[i+1:]):
            # print(l1, l2)

            for c1, c2 in zip(l1, l2):
                # print(c1, c2)
                ipairs.append((c1, c2))

        pcheck = 0
        for c1, c2 in ipairs:
            if c1 == c2:
                pcheck += 1

        if p2:
            if pcheck == len(ipairs) - 1:
                return i + 1

        else:
            if pcheck == len(ipairs):
                return i + 1

    return '???'


def transpose(thing):
    # zip is my new best friend
    return list(zip(*thing))


def calc(values, part):
    ret = 0
    
    for thing in values:
        if part == 1:
            ret += 100 * hlr(thing) + hlr(transpose(thing))

        if part == 2:
            ret += 100 * hlr(thing, True) + hlr(transpose(thing), True)

    return ret


# print(values)
print('P1', calc(values, 1))
print('P2', calc(values, 2))
