#include <Wire.h>
#include "MAX30105.h"
#include "spo2_algorithm.h"

MAX30105 particleSensor;

#define MAX_BRIGHTNESS 255
#define BUFFER_SIZE 100 // Adjust buffer size based on your needs

// Raw sensor data buffers
uint32_t irBuffer[BUFFER_SIZE];  // IR LED sensor data
uint32_t redBuffer[BUFFER_SIZE]; // Red LED sensor data

int32_t bufferLength;           // Data length
int32_t spo2;                   // SPO2 value
int8_t validSPO2;               // Indicator to show if the SPO2 calculation is valid
int32_t heartRate;              // Heart rate value
int8_t validHeartRate;          // Indicator to show if the heart rate calculation is valid

byte pulseLED = 11;  // Must be on PWM pin
byte readLED = 13;   // Blinks with each data read

#define SMOOTHING_FACTOR 10  // Adjust this based on the data smoothing needs

uint32_t smoothedRed = 0;
uint32_t smoothedIR = 0;
uint32_t redSum = 0;
uint32_t irSum = 0;

void setup() {
  Serial.begin(115200); // Initialize serial communication at 115200 bits per second:
  delay(2000);

  Serial.println("Booting...");
  
  // Initialize I2C communication
  Wire.begin(21, 22);
  Serial.println("I2C started.");

  bool ok = particleSensor.begin(Wire, I2C_SPEED_FAST);
  Serial.print("Sensor begin() => ");
  Serial.println(ok ? "SUCCESS" : "FAIL");

  if (!ok) {
    Serial.println("MAX30102 NOT FOUND! Check wiring.");
    while (1) delay(1000);
  }

  // Set up sensor settings
  Serial.println("Setting up sensor...");
  byte ledBrightness = 60;  // Options: 0=Off to 255=50mA
  byte sampleAverage = 4;   // Options: 1, 2, 4, 8, 16, 32
  byte ledMode = 2;         // Options: 1 = Red only, 2 = Red + IR, 3 = Red + IR + Green
  byte sampleRate = 100;    // Options: 50, 100, 200, 400, 800, 1000, 1600, 3200
  int pulseWidth = 411;     // Options: 69, 118, 215, 411
  int adcRange = 4096;      // Options: 2048, 4096, 8192, 16384

  particleSensor.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange);
  Serial.println("READY!");
}

void loop() {
    bufferLength = BUFFER_SIZE;  // Buffer length for 100 samples

    // Read the first 100 samples
    for (byte i = 0; i < bufferLength; i++) {
        while (!particleSensor.available()) {
            particleSensor.check(); // Check the sensor for new data
        }

        uint32_t rawRed = particleSensor.getRed();
        uint32_t rawIR = particleSensor.getIR();

        // Apply smoothing filter
        redSum += rawRed;
        irSum += rawIR;

        if (i >= SMOOTHING_FACTOR) {
            redSum -= redBuffer[i - SMOOTHING_FACTOR];
            irSum -= irBuffer[i - SMOOTHING_FACTOR];
        }

        redBuffer[i] = redSum / SMOOTHING_FACTOR;
        irBuffer[i] = irSum / SMOOTHING_FACTOR;

        // Debug output of smoothed sensor data
        Serial.print("Smoothed Red: ");
        Serial.print(redBuffer[i]);
        Serial.print(" | Smoothed IR: ");
        Serial.println(irBuffer[i]);
    }

    // Calculate heart rate and SpO2 after the first 100 samples
    maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &spo2, &validSPO2, &heartRate, &validHeartRate);

    // Display the calculated heart rate and SpO2 values
    if (validHeartRate) {
        Serial.print("Heart Rate: ");
        Serial.print(heartRate);
        Serial.print(" (Valid: 1) | ");
    } else {
        Serial.print("Heart Rate: Invalid (Valid: 0) | ");
    }

    if (validSPO2) {
        Serial.print("SpO2: ");
        Serial.print(spo2);
        Serial.print(" (Valid: 1) | ");
    } else {
        Serial.print("SpO2: Invalid (Valid: 0) | ");
    }
    Serial.println();

    // Continuously take samples every 1 second
    delay(1000);
}