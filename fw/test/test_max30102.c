#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include "spo2_algorithm.h"
#include "heartRate.h"
#include "max30102_data.h"

uint32_t ir_buf[BUFFER_SIZE];
uint32_t red_buf[BUFFER_SIZE];

int main(void)
{
    int32_t spo2, hr_dummy;
    int8_t spo2_valid, hr_valid_dummy;

    /* =========================
     * Heart Rate (continuous)
     * ========================= */
    printf("=== Beat-to-beat Heart Rate ===\n");

    int lastBeat = -1;
    float hr_sum = 0.0f;
    int hr_count = 0;

    for (int i = 0; i < SAMPLE_COUNT; i++) {
        if (checkForBeat(ir_data[i])) {
            if (lastBeat >= 0) {
                int delta = i - lastBeat;
                float bpm = 60.0f * FreqS / delta;

                /* Reject unrealistic values */
                if (bpm >= 40.0f && bpm <= 200.0f) {
                    printf("Sample %4d : HR = %6.1f bpm\n", i, bpm);
                    hr_sum += bpm;
                    hr_count++;
                }
            }
            lastBeat = i;
        }
    }

    float hr_avg = (hr_count > 0) ? (hr_sum / hr_count) : 0.0f;

    printf("--------------------------------\n");
    printf("Average HR : %.1f bpm (%d beats)\n\n", hr_avg, hr_count);

    /* =========================
     * SpO₂ (windowed)
     * ========================= */
    printf("=== SpO2 per Window ===\n");
    printf("WindowStart | SpO2 (%%) | Valid\n");
    printf("-------------------------------\n");

    for (int start = 0;
         start + BUFFER_SIZE <= SAMPLE_COUNT;
         start += BUFFER_SIZE)
    {
        memcpy(ir_buf,  &ir_data[start],
               BUFFER_SIZE * sizeof(uint32_t));
        memcpy(red_buf, &red_data[start],
               BUFFER_SIZE * sizeof(uint32_t));

        maxim_heart_rate_and_oxygen_saturation(
            ir_buf,
            BUFFER_SIZE,
            red_buf,
            &spo2,
            &spo2_valid,
            &hr_dummy,
            &hr_valid_dummy
        );

        printf("%10d | %8d | %5d\n",
               start, spo2, spo2_valid);
    }

    return 0;
}
