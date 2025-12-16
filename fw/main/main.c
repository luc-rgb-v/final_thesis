// main.c — simple RV32I program
// Loads 2 values, adds them, stores result to DMEM

#define DMEM_ADDR 0x00001000   // choose an address inside your data memory

volatile unsigned int *dmem = (unsigned int *)DMEM_ADDR;

int main() {
    unsigned int a = 5;         // compiler places in x-register
    unsigned int b = 7;         // compiler places in x-register

    unsigned int c = a + b;     // will compile into "add" RV32I instruction

    dmem[0] = c;                // store result into memory (SW)

    while (1) {
        // keep CPU alive (optional)
    }

    return 0;
}

