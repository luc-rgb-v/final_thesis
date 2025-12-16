#ifndef ARDUINO_H
#define ARDUINO_H

#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define PROGMEM
#define pgm_read_byte(addr) (*(const unsigned char *)(addr))
#ifndef min
#define min(a,b) ((a) < (b) ? (a) : (b))
#endif

#ifndef max
#define max(a,b) ((a) > (b) ? (a) : (b))
#endif

typedef uint8_t byte;

#endif
