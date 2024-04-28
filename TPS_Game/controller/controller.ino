
#include "ICM_20948.h"
ICM_20948_I2C myICM;
int sensorPin = A0; 
int buttonPin = 8;

void setup() {
 Serial.begin(115200);
 Wire.begin();
 Wire.setClock(400000);
 myICM.begin(Wire, 1);
 pinMode(buttonPin, INPUT);
}

void loop() {
 // Getting IMU data
 if ( myICM.dataReady() ) {
   myICM.getAGMT();
   float ax = myICM.accX();
   float ay = myICM.accY();
   int force = analogRead(sensorPin);
   int buttonState = digitalRead(buttonPin);

   Serial.print(ax, 1);
   Serial.print(", ");
   Serial.print(ay, 1);
   Serial.print(", ");
   Serial.print(force);
   Serial.print(", ");
   Serial.print(buttonState);
   Serial.println();
 }
 delay(100);
}

