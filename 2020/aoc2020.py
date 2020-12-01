from GenericClass.AdventOfCode import AdventOfCodeYear


class Year2020(AdventOfCodeYear):

    def day1(inputs):
        ls = [int(i) for i in inputs]

        for l in ls:
            for s in ls:
                if l + s == 2020:
                    return s * l

    def day2(inputs):
        return ""
