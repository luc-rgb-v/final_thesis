#include <Arduino.h>
#include <Wire.h>
#include "MAX30105.h"
#include "heartRate.h"

MAX30105 particleSensor;
void setup() {
  Serial.begin(115200);
  delay(2000);

  Wire.begin(21, 22);

  if (!particleSensor.begin(Wire, I2C_SPEED_FAST)) {
    Serial.println("MAX30102 not found");
    while (1);
  }

  // Explicit configuration (important)
  particleSensor.setup(
    0x1F,  // LED brightness
    4,     // sample average
    2,     // LED mode: RED + IR
    400,   // sample rate (Hz) ADC rate = 400 => FIFO output rate = 400 / 4 = 100 samples/sec
    411,   // pulse width
    4096   // ADC range
  );

  Serial.println("READY");
}

void loop() {
  static uint32_t t0 = millis();
  static uint32_t samples = 0;

  // Pull data from hardware FIFO into library buffer
  particleSensor.check();

  // Drain ALL available samples
  while (particleSensor.available()) {
    // (Optional) read values
    // uint32_t ir  = particleSensor.getFIFOIR();
    // uint32_t red = particleSensor.getFIFORed();

    particleSensor.nextSample();
    samples++;
  }

  // Report once per second
  if (millis() - t0 >= 1000) {
    Serial.print("Samples/sec = ");
    Serial.println(samples);
    samples = 0;
    t0 += 1000;
  }
}
