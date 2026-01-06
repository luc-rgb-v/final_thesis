import sys
INPUT_FILE = sys.argv[1] if len(sys.argv) > 1 else "max30102_16bitdata_log.csv"
OUTPUT_FILE = "100_sample_of_ir_and_red.h"

# -------- Timestamp range (ms) --------
START_MS = 8943   #  15334   | None = from beginning
END_MS   = 12903   #  19196  | None = until end
#START_MS = 1310   #  1310   | None = from beginning
#END_MS   = 5269   #  5269  | None = until end
# -------------------------------------

an_x = []
an_y = []

with open(INPUT_FILE, "r") as f:
    next(f)  # skip header

    for line in f:
        line = line.strip()
        if not line:
            continue

        ts, ir, red = line.split(",")
        ts = int(ts)

        # Range filtering
        if START_MS is not None and ts < START_MS:
            continue
        if END_MS is not None and ts > END_MS:
            continue

        an_x.append(int(ir))
        an_y.append(int(red))

count = len(an_x)

with open(OUTPUT_FILE, "w") as f:
    f.write("#ifndef MAX30102_DATA_H\n")
    f.write("#define MAX30102_DATA_H\n\n")

    if START_MS is None and END_MS is None:
        f.write("// Data range: full log\n")
    else:
        f.write(f"// Data range: {START_MS} ms to {END_MS} ms\n")

    f.write(f"#define SAMPLE_COUNT {count}\n\n")

    f.write("static uint16_t pun_ir_buffer[SAMPLE_COUNT] = {\n")
    for i, v in enumerate(an_x):
        f.write(f"  {v},")
        if (i + 1) % 8 == 0:
            f.write("\n")
    f.write("\n};\n\n")

    f.write("static uint16_t pun_red_buffer[SAMPLE_COUNT] = {\n")
    for i, v in enumerate(an_y):
        f.write(f"  {v},")
        if (i + 1) % 8 == 0:
            f.write("\n")
    f.write("\n};\n\n")

    f.write("#endif\n")

print(f"Generated {OUTPUT_FILE} with {count} samples")
