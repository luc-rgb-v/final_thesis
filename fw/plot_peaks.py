import csv
import matplotlib.pyplot as plt

ir_x = []
ir_y = []
peak_idx = []

n_min_height = None
n_min_distance = None

with open("peaks.csv", "r") as f:
    reader = csv.reader(f)
    for row in reader:
        if row[0] == "IR":
            ir_x.append(int(row[1]))
            ir_y.append(int(row[2]))

        elif row[0] == "PEAK":
            peak_idx.append(int(row[1]))

        elif row[0] == "n_min_height":
            n_min_height = int(row[1])

        elif row[0] == "n_min_distance":
            n_min_distance = int(row[1])

# Peak Y values
peak_x = peak_idx
peak_y = [ir_y[i] for i in peak_idx]

plt.figure()

# IR waveform
plt.plot(ir_x, ir_y, linewidth=2.5, label="IR Signal")

# Peak dots
plt.scatter(
    peak_x, peak_y,
    s=80,
    zorder=3,
    color="black",
    label="Detected Peaks"
)

# Minimum height line
# "black", "red", "blue", "green", "orange", "purple"
if n_min_height is not None:
    plt.axhline(
        y=n_min_height,
        linewidth=2,
        linestyle='--',
        color="orange",
        label=f"Min Height = {n_min_height}"
    )

# Proper title with parameters
title = "IR Signal with Peaks\n"
title += f"Min Height = {n_min_height}, Min Distance = {n_min_distance}"
plt.title(title, fontsize=18)

plt.xlabel("Sample Index", fontsize=18)
plt.ylabel("IR Value", fontsize=18)
plt.xticks(fontsize=14)
plt.yticks(fontsize=14)
plt.grid(True)
plt.legend()
plt.show()
