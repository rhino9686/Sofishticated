#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266mDNS.h>
#include <ArduinoOTA.h>
#include <ESP8266WebServer.h>
#include <ESP8266WiFiMulti.h> 
#include <ESP8266HTTPClient.h>

// Change this depending on what the current IP address is for the server
#define SERVER_ADDR "35.6.173.80"


#ifndef STASSID
#define STASSID "Linksys01101"
#define STAPSK  "huugg"
#endif

struct Tank {
  //We store everything as a integer here, will be the actual value multiplied by 100 to get 2 decimal places
  String temperature;
  String pH;
  String chemReadings;
  int nitrateReading;
};


const char* ssid = "MSetup";
//ssid and password for Access Point
const char* ssid2 = "FishTank";  //Previously MadiWifi, duly noted
const char* password = "password";

bool SETUP_MODE = false; //This will determine if the Wifi module will be hosting it's own access point or not

//Message buffer for HTTP Data
String buffer = "";


//Tank model to store temp values, chemical readings
Tank myTank;


//HTTPClient to send messages to server
HTTPClient http;
//IP Addresses for Access Point Mode
IPAddress ip(192,168,11,4);
IPAddress gateway(192,168,11,1);
IPAddress subnet(255,255,255,0);

ESP8266WebServer server(80);

//const char* www_username = "admin";
//const char* www_password = "esp8266";

// FUNCTION DECLARATIONS

//TODO: Test that this actually works
void getParam(char param) {

  //Send Param request to PCB
   Serial.write(param);
   delay(50);
   if (Serial.available()) {
   delay(100); //allows all serial sent to be received together
   
   while(Serial.available() ) {
     buffer = Serial.readString();
   }

   //sendMessageToServer(param);
  
  }
 }

//Send message to device to request Temperature
void getTemp(){
  getParam('T');

  if(buffer != "") {
      myTank.temperature = buffer;
  }
}

//Send message to device to request pH
void getpH() {
  getParam('P');

    if(buffer != "") {
      myTank.pH = buffer;
  }
}

//Send message to device to request Ammonia
void getAmmonia() {
  getParam('A');
}

//Send message to device to request Nitrate
void getNitrate(){
  getParam('N');
}

//Send message to device to request Nitrate
void getNitrite(){
  getParam('n');
}



//Send message to device to request Nitrate/Nitrite
void getChems(){
  getParam('C');
    if(buffer != "") {
      myTank.chemReadings = buffer;
  }
}



//Send message to server with Temperature data
void sendTemp(){
  buffer = myTank.temperature;
  sendMessageToServer('T');
  
}

//Send message to server with pH data
void sendpH(){
  buffer = myTank.pH;
  sendMessageToServer('P');
}


//Send message to server with Ammonia data
void sendChems(){
  buffer = myTank.chemReadings;
  sendMessageToServer('C');
}

//Send message to server with Nitrate/Nitrite data
void getNitrates();


void resetWifiParams();

// Handles when the server wants to know the Temp and pH vals
void handleParamRequest();

//Handles when the server wants to check Nitrate and Ammonia vals
void handleCheckRequest();




void sendMessageToServer(char param) { //Sends whatever is in buffer to server

 if(WiFi.status()== WL_CONNECTED) {   //Check WiFi connection status
    String ip_address = SERVER_ADDR;

    String url_address =  String("http://" + ip_address + ":5000");

    switch (param) { // Send different HTTP request depending on param character
      
        case 'R': { // Random Number
             http.begin(url_address + "/fromTank/sendRando" );  
             break;  
        }
        case 'P': { // pH value
             http.begin(url_address + "/fromTank/sendpH" );   
             break; 
        }
        case 'T':{ // Temperature Value
             http.begin(url_address + "/fromTank/sendTemp" );   
             break; 
        }
        case 'C':{ // Ammonia Reading
             http.begin(url_address + "/fromTank/sendChems" );
             break;    
        }
        case 'N':{ // Nitrate Reading
             http.begin(url_address + "/fromTank/sendNitrate" );   
             break; 
      
        }  
        case 'n':{ // Nitrite Reading
             http.begin(url_address + "/fromTank/sendNitrite" );   
             break; 
      
        } 
        
        
    }
      
   http.addHeader("Content-Type", "text/plain");  // Set it as plain text, to be parsed by the Flask server
    
   int httpCode = http.POST(buffer);                   //Send the request
   String payload = http.getString();                  //Get the response payload
 
   //Serial.println(httpCode);   //Print HTTP return code
   //Serial.println(payload);    //Print request response payload
 
   http.end();  //Close connection
 
 }else {
 
    Serial.println("Error in WiFi connection");   
 }
}



void setup() {
  Serial.begin(115200);

  //Set up initial Tank Parameters
  myTank.temperature = "";
  myTank.pH = "";

  
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid);
  if (WiFi.waitForConnectResult() != WL_CONNECTED) {
    Serial.println("WiFi Connect Failed! Rebooting...");
    delay(1000);
    ESP.restart();
  }
  ArduinoOTA.begin();
  
    //Handler for http requests for requests
    server.on("/requestVals", handleParamRequest);
    server.on("/promptAmmonia", handleAmmonPrompt);
    server.on("/requestChems", handleChemRequest);
    server.on("/promptNitrate", handleNitratePrompt);
    server.on("/promptNitrite", handleNitritePrompt);
    server.on("/sendAvg", getAvgTemp);
  
  server.begin();



  //WiFi.softAPConfig(ip, gateway, subnet);
  //WiFi.softAP(ssid2);

  Serial.print("Local: ");
  Serial.print(WiFi.localIP());
  
  /**Serial.print("Open http://");
  Serial.print(WiFi.localIP());
  Serial.println("/ in your browser to see it working");


  Serial.print(" Setting softAP config ");
  Serial.println(WiFi.softAPConfig(ip, gateway, subnet) ? "Ready" : "Failed!");
  Serial.print(" Setting softAP   " );
  Serial.println(WiFi.softAP(ssid, password) ? "Ready" : "Failed!");

  Serial.print("Soft AP IP Addr is  "); **/
 // Serial.println(WiFi.softAPIP());
}



///
//These are event handlers we attach to different server routes.
///

void handleParamRequest() {

  server.send(200, "text/plain", "fetching Temp and pH vals");

  getTemp();
  sendTemp();

  getpH();
  sendpH();
 buffer = "";
}

void handleCheckRequest() {

  server.send(200, "text/plain", "checking chemical levels");
}

void handleAmmonPrompt() {

  getAmmonia();

  server.send(200, "text/plain", "checking Ammonia color test");
}

void handleChemRequest() {

  getChems();
  sendChems();

  server.send(200, "text/plain", "returning Chemical vals");
}

void handleNitratePrompt() {
  getNitrate();

  server.send(200, "text/plain", "checking Nitrate color test");
}


void handleNitrateRequest() {

  server.send(200, "text/plain", "checking Nitrate color test");
}

void handleNitritePrompt() {
  getNitrite();
  
  server.send(200, "text/plain", "checking Nitrite color test");
}


void handleNitriteRequest() {

  server.send(200, "text/plain", "checking Nitrite color test");
}

void getAvgTemp() {

     if (server.hasArg("plain")== false){ //Check if body received
          server.send(200, "text/plain", "Body not received");
          return;

    }
  String message = server.arg("plain");

  String avgTempInt = message.substring(11, 15);
  String g = "S" + avgTempInt;
  //Serial.print(g);

  for( int i = 0; i < g.length(); i++) {
    Serial.write(g[i]);
    delay(20);
  }

  server.send(200, "text/plain", "got avg temp!");
}



//// SETUP MODE ///////////////////////////////////////////////////////////
void switchToSetupMode() {
  SETUP_MODE = true;

  WiFi.mode(WIFI_AP_STA);
  
  Serial.println(WiFi.softAPConfig(ip, gateway, subnet) ? "Ready" : "Failed!");
  Serial.print(" Setting softAP " );
  Serial.println(WiFi.softAP(ssid, password) ? "Ready" : "Failed!");

  
  return;
}

void switchToOperationalMode() {
  WiFi.softAPdisconnect(true);
  WiFi.mode(WIFI_STA);

  return;
}

////////////////////////////////////////////////////////////////////////////


void loop() {

  server.handleClient();

  delay(3000);  //
  
}
