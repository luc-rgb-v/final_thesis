import csv
import matplotlib.pyplot as plt

x = []
y = []

# Read CSV file
with open("ir_ac.csv", "r") as f:
    reader = csv.reader(f)
    for row in reader:
        if row[0] == "IR_AC":
            x.append(int(row[1]))   # index
            y.append(int(row[2]))   # value

# Plot
plt.figure()
#plt.plot(x, y)
plt.plot(
    x, y,
    linewidth=2.5
    #marker='o',
    #markersize=3,
    #markeredgewidth=1.5
)
#plt.plot(x, y, marker='o')
plt.xlabel("Sample Index", fontsize=18)
plt.ylabel("IR_AC Value", fontsize=18)
plt.title("IR_AC Signal", fontsize=18)

plt.xticks(fontsize=14)
plt.yticks(fontsize=14)

plt.grid(True)
plt.show()
