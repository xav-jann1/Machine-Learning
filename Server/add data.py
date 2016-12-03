import sys
import csv

numbers = sys.argv[1]

#x = list(csv.reader(numbers))
s=0
for i in numbers:
    if i != ",":
        s+=int(i)

print(s)
sys.stdout.flush()
