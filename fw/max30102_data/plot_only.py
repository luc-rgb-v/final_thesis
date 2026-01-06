import serial
import collections
import matplotlib.pyplot as plt
import time

# ---------------- CONFIG ----------------
PORT = "/dev/ttyUSB0"
#PORT = "COM3"
BAUD = 115200
WINDOW = 500        # samples shown
DRAW_EVERY = 5      # plot decimation
# ----------------------------------------

# Buffers
ir_data  = collections.deque(maxlen=WINDOW)
red_data = collections.deque(maxlen=WINDOW)

# Open serial
ser = serial.Serial(PORT, BAUD, timeout=1)
time.sleep(2)  # allow ESP32 reset

# Matplotlib setup
plt.ion()
fig, ax = plt.subplots()

line_ir,  = ax.plot([], [], label="IR")
line_red, = ax.plot([], [], label="RED")

ax.set_title("MAX30102 Real-Time Data")
ax.set_xlabel("Sample")
ax.set_ylabel("ADC Value")
ax.legend(loc="upper right")
ax.grid(True)

counter = 0

# ---------------- MAIN LOOP ----------------
while True:
    try:
        line = ser.readline().decode(errors="ignore").strip()
        if not line:
            continue

        # Expect: IR,RED
        ir, red = map(int, line.split(","))

        ir_data.append(ir)
        red_data.append(red)

        counter += 1
        if counter % DRAW_EVERY != 0:
            continue

        x = range(len(ir_data))
        line_ir.set_data(x, ir_data)
        line_red.set_data(x, red_data)

        ax.relim()
        ax.autoscale_view()

        plt.pause(0.001)

    except KeyboardInterrupt:
        break

ser.close()
