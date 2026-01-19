
# Final thesis
### HARDWARE DESIGN AND VERIFICATION OF AN RV32I RISC-V SOC FOR BIOMEDICAL SIGNAL PROCESSING

*This project designs both the hardware and firmware for a lightweight **RV32I RISC V** SoC for biomedical signal processing. SPIKE is used as the golden model to verify the system. The RISC V GNU toolchain Vivado Questa and Makefile are used to support development and testing.*

---
# Project structure
```text
.
├── Readme.md
├── doc
│   ├── Readme.txt 
│   ├── html
│   │   └── ref.html
│   └── html_ref
│       ├── css
│       └── old
│           └── thesis_task.html
├── fw
│   ├── Makefile
│   ├── Readme.md
│   ├── linker.ld
│   ├── main.cpp
│   ├── max30102_data
│   │   ├── gen_c_header.py
│   │   ├── note
│   │   ├── platformio.ini
│   │   └── src
│   │       └── main.cpp
│   ├── plot_ir_ac.py
│   ├── requirements.txt
│   ├── start.S
│   └── test.cpp
├── hw
│   ├── Makefile (work with Vivado Questa Verilator Spike)
│   ├── license
│   ├── scripts
│   │   ├── gen_dmem_ip.tcl
│   │   └── top_sys_vivado_test.tcl
│   ├── sim
│   │   ├── Makefile
│   │   └── rtl.f
│   ├── src
│   │   ├── if_stage.v
│   │   └── uart_tx.v
│   ├── support
│   │   ├── Makefile (firmware Makefile)
│   │   ├── assembly
│   │   │   ├── arithmetic_instr.S
│   │   │   └── (assembly tests)
│   │   └── linker.ld
│   ├── tb
│   │   ├── testbench.v
│   │   └── (testbench file)
│   ├── testcases
│   │   ├── arithmetic_instr.v
│   │   └── (testcase for simulation)
│   └── xdc
└── pre
    ├── esp32_max_data.rar
    └── (some pre-research)
```
---
# Firmware

An ESP32 is used to collect data from the MAX30102 sensor, and Python converts the raw samples into a static buffer for use in main.cpp. The firmware is cross compiled with the RISC V toolchain using a Makefile. Below are some useful Makefile commands in ./fw/Makefile.

```text
# SPIKE build
spike: $(SPIKE_ELF)
        @echo "============================="
        @echo "(spike) until pc 0 0x80000000       - <_start>: auipc sp,0x10"
        @echo "(spike) pc 0                        - program counter at core 0"
        @echo "(spike) run 1                       - run 1 instruction"
        @echo "(spike) reg 0                       - check register file"
        @echo "(spike) until insn 0 0x00ac2023     - or until pc 0 800004a8 : sw a0,0(s8)"
        @echo "(spike) mem 0 0x80010730            - heartrate data address"
        @echo "(spike) until pc 0 0x800007d0       - or until insn 0 0x00eda023 : sw a4,0(s11)"
        @echo "(spike) mem 0 0x800107e8            - SpO2 data address"
        @echo "============================="
        riscv32-unknown-elf-nm $(SPIKE_ELF) | grep main
        spike --isa=rv32i -d --pc=0x80000000 $(SPIKE_ELF)

# =====================================================
# Help
# =====================================================
help:
        @echo "make all                         - build for wsl"
        @echo "make riscv                       - build for rv32i"
        @echo "./main > log.csv                 - gen log file"
        @echo "python3 -m venv venv             - create Python virtual environment"
        @echo "source venv/bin/activate         - activare virtual environment"
        @echo "pip install -r requirements.txt  - venv requirement"
        @echo "deactivate                       - exit virtual environment"
```
output file in ./fw/build/

```text
dmem.bin  dmem.coe  dmem.hex  imem.bin  imem.coe  imem.hex  main.S  main.bin  main.elf  main.hex  main.map  main.o  main.txt  start.o
```
- .coe file is used for initial dmem IP in vivado
- .mem file is used for initial simulation regs
- .elf file is used for spike simulation
- main.map is firmware structure report

---
# Hardware

The hardware is designed to generate a bitstream for FPGA deployment, so all modules need to be fully synthesizable and use block RAM for on chip memory. Vivado is used for BRAM IP generation, Questa for simulation and testing, and Makefile for design automation.

```text
help:
        @echo "=================================================================================="
        @echo "vivado  -vivado gui"
        @echo "drc     -design rule check"
        @echo "a       -build_run_console | build run"
        @echo "f       -build_run_gui_wave | build run wave"
        @echo "b       -build_run_cov_all_testcase | build_cov run_cov gen_cov"
        @echo "d       -build_run_cov_all_testcase_gui | build_cov run_cov gen_cov view_cov"
        @echo "e       -build_run_cov_all_testcase_html | build_cov run_cov gen_html"
        @echo "g       -fw_spike_build | instructions.mem data.mem registers.mem"
        @echo "h       -gen_IP_cov_html_cov | generate coverage report & html report from IP.ucdb"
        @echo "ca      -clean anything fw_clean | sim_clean_all"
        @echo "cv      -clean make vivado"
        @echo "clean   -clean anything accept '/sim/ucdb' fw_clean | sim_clean"
        @echo "=================================================================================="
```
---
# Status report

| Feature | Status |
|------|------|
| arithmetic instructions | ✅ |
| logical instructions | ✅ |
| branch jump instructions | ✅ |
| memory access instructions | ✅ |
| lui auipc instruction | ✅ |
| system instruction | ❌ |
| forwarding alu result | ✅ |
| forwarding data load | ❌ |
| forwarding PC + 4 | ❌ |

---
<!-- [To the top](#final-thesis) -->

<p align="center">
  <a href="#final-thesis">To the top</a>
</p>

