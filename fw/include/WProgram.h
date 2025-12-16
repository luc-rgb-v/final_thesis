#ifndef HEART_RATE_H
#define HEART_RATE_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

bool checkForBeat(int32_t sample);
int16_t averageDCEstimator(int32_t *p, uint16_t x);
int16_t lowPassFIRFilter(int16_t din);
int32_t mul16(int16_t x, int16_t y);

#ifdef __cplusplus
}
#endif

#endif
