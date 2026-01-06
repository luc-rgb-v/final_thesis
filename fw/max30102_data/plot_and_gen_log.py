import serial
import collections
import matplotlib.pyplot as plt
import time

# ---------------- CONFIG ----------------
PORT = "/dev/ttyUSB0"
#PORT = "COM3"
BAUD = 115200
WINDOW = 500
DRAW_EVERY = 5
LOG_FILE = "data_log.csv"
# ----------------------------------------

# Buffers
ir_data  = collections.deque(maxlen=WINDOW)
red_data = collections.deque(maxlen=WINDOW)

# Open serial
ser = serial.Serial(PORT, BAUD, timeout=1)
time.sleep(2)  # ESP32 reset

# Open log file
log = open(LOG_FILE, "w")
log.write("timestamp_ms,IR,RED\n")

# Matplotlib setup
plt.ion()
fig, ax = plt.subplots()

line_ir,  = ax.plot([], [], label="IR")
line_red, = ax.plot([], [], label="RED")

ax.set_title("MAX30102 Real-Time Data")
ax.set_xlabel("Sample")
ax.set_ylabel("ADC Value")
ax.legend()
ax.grid(True)

counter = 0
start_time = time.time()

# ---------------- MAIN LOOP ----------------
while True:
    try:
        line = ser.readline().decode(errors="ignore").strip()
        if not line:
            continue

        # Expect: IR,RED
        ir, red = map(int, line.split(","))

        # Timestamp in ms
        ts = int((time.time() - start_time) * 1000)

        # Save to file
        log.write(f"{ts},{ir},{red}\n")

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

# ---------------- CLEANUP ----------------
log.close()
ser.close()
