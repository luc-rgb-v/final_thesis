import csv
import matplotlib.pyplot as plt

k_vals = []
ma4_vals = []

with open("ma4.csv", "r") as f:
    reader = csv.reader(f)
    for row in reader:
        if row[0] == "MA4":
            k  = int(row[1])
            b0 = int(row[2])
            b1 = int(row[3])
            b2 = int(row[4])
            b3 = int(row[5])

            ma4 = (b0 + b1 + b2 + b3) / 4.0

            k_vals.append(k)
            ma4_vals.append(ma4)

# Plot MA4 output
plt.figure()
plt.plot(
    k_vals, ma4_vals,
    linewidth=2.5,
)

plt.xlabel("k (sample index)", fontsize=18)
plt.ylabel("MA4 Output Value", fontsize=18)
plt.title("4-Point Moving Average (MA4)", fontsize=18)

plt.xticks(fontsize=14)
plt.yticks(fontsize=14)
plt.grid(True)

plt.show()
