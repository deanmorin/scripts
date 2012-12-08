#!/usr/bin/env python
import string
import sys
numbers = sys.stdin.read()
numbers = string.split(numbers)
sum = 0
for n in numbers:
    sum += int(n)
print sum
