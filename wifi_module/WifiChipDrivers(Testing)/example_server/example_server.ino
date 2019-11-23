#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <ArduinoOTA.h>
#include <ESP8266WebServer.h>

#ifndef STASSID
#define STASSID "Linksys01101"
#define STAPSK  "vpgpgwt9000"
#endif

const char* ssid = "MSetup";

ESP8266WebServer server(80);

//const char* www_username = "admin";
//const char* www_password = "esp8266";

// Handles when the server wants to know the Temp and pH vals
void handleParamRequest();

//Handles when the server wants to check Nitrate and Ammonia vals
void handleCheckRequest();

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid);
  if (WiFi.waitForConnectResult() != WL_CONNECTED) {
    Serial.println("WiFi Connect Failed! Rebooting...");
    delay(1000);
    ESP.restart();
  }
  ArduinoOTA.begin();
  
    //Handler for http requests for requests
    server.on("/requestVals", handleRequest);
  
  server.begin();

  Serial.print("Open http://");
  Serial.print(WiFi.localIP());
  Serial.println("/ in your browser to see it working");
}

void handleParamRequest() {
  server.send(200, "text/plain", "fetching Temp and pH vals");
}

void handleCheckRequest() {
  server.send(200, "text/plain", "checking chemical levels");
}


void loop() {
  server.handleClient();
}
