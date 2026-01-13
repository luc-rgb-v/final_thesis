volatile int A = 5;
volatile int B = 7;
volatile int C;

int main() {
    C = A + B;   // Expect 12

    // Prevent optimization
    volatile int result = C;

    return 0;
}
