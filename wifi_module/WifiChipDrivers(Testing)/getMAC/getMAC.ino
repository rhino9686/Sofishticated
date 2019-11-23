#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WiFiMulti.h> 
#include <ESP8266HTTPClient.h>

void setup() {
  // put your setup code here, to run once:
   Serial.begin(115200);
   delay(500);
 
   Serial.println();
   Serial.print("MAC: ");
   Serial.println(WiFi.macAddress());
}

void loop() {
  // put your main code here, to run repeatedly:
   Serial.print("MAC: ");
   Serial.println(WiFi.macAddress());
   delay(500);
}
