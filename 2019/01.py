from GenericClass.AdventOfCode import InputGetter

ns = InputGetter(day=1).get()

fuel = lambda x: int(x / 3) - 2 + (fuel(int(x / 3) - 2) if fuel(int(x / 3) - 2) > 0 else 0) if x / 3 > 0 else 0
print(sum(map(fuel, [int(i) for i in filter(lambda x: x != '', ns)])))