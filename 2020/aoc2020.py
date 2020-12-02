from GenericClass.AdventOfCode import AdventOfCodeYear


import re
from itertools import product


class Year2020(AdventOfCodeYear):

    def day1(inputs):
        ls = [int(i) for i in inputs]

        for l in ls:
            for s in ls:
                if l + s == 2020:
                    return s * l

    def day1_2(inputs):
        ls = [int(i) for i in inputs]

        for a, b, c in product(ls, ls, ls):
            if a + b + c == 2020:
                return a * b * c

    def day2(inputs):
        t = 0

        for i in inputs:
            _min, _max, letter, password = re.search('(\d+)-(\d+) (\w): (\w+)', i).groups()

            if int(_min) <= password.count(letter) <= int(_max):
                t += 1

        return t

    def day2_2(inputs):
        t = 0

        for i in inputs:
            p1, p2, letter, password = re.search('(\d+)-(\d+) (\w): (\w+)', i).groups()
            p1, p2 = int(p1), int(p2)

            if p1 - 1 <= len(password) and p2 - 1 <= len(password):

                if (password[p1 - 1] == letter) ^ (password[p2 - 1] == letter):
                    t += 1

        return t
