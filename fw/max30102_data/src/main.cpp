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

  particleSensor.setup(
    0x1F,  // LED power
    4,     // FIFO averaging
    2,     // RED + IR
    100,   // sample rate (Hz)
    411,
    4096
  );

  Serial.println("READY");
}

void loop() {
  // Pull new samples from sensor FIFO
  particleSensor.check();

  // Print all available samples
  while (particleSensor.available()) {
    uint16_t ir  = particleSensor.getFIFOIR();
    uint16_t red = particleSensor.getFIFORed();

    Serial.print(ir);
    Serial.print(",");
    Serial.println(red);

    particleSensor.nextSample();
  }
}
