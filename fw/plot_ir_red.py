import matplotlib.pyplot as plt

ir_x, ir_y = [], []
red_x, red_y = [], []

with open("ir_red.csv", "r") as f:
    for line in f:
        line = line.strip()
        if not line:
            continue

        sig, idx, val = line.split(",")
        idx = int(idx)
        val = int(val)

        if sig == "IR_RAW":
            ir_x.append(idx)
            ir_y.append(val)
        elif sig == "RED_RAW":
            red_x.append(idx)
            red_y.append(val)

plt.figure()
plt.plot(ir_x, ir_y, label="IR_RAW", linewidth=3)
plt.plot(red_x, red_y, label="RED_RAW", linewidth=3)
plt.xlabel("Sample Index", fontsize=18)
plt.ylabel("ADC Value", fontsize=18)
plt.title("MAX3010x IR & RED Raw Data", fontsize=18)
plt.legend()
plt.grid(True)
plt.show()
