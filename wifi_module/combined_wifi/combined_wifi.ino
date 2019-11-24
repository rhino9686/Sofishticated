#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266mDNS.h>
#include <ArduinoOTA.h>
#include <ESP8266WebServer.h>
#include <ESP8266WiFiMulti.h> 
#include <ESP8266HTTPClient.h>

// Change this depending on what the current IP address is for the server
#define SERVER_ADDR "35.6.191.190"


#ifndef STASSID
#define STASSID "Linksys01101"
#define STAPSK  "huugg"
#endif

struct Tank {
  //We store everything as a integer here, will be the actual value multiplied by 100 to get 2 decimal places
  int temperature;
  int pH;
  int ammoniaReading;
  int nitrateReading;
};


const char* ssid = "MSetup";
//ssid and password for Access Point
const char* ssid2 = "FishTank";  //Previously MadiWifi, duly noted
const char* password = "password";

bool SETUP_MODE = false; //This will determine if the Wifi module will be hosting it's own access point or not

//Message buffer for HTTP Data
char buffer[10];



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

//TODO: LEARN HOW TO GET PARAMS FROM PCB DEVICE
void getParam(char param) {
  return;
}


//Send message to device to request Temperature
void getTemp(){
  getParam('T');
}

//Send message to device to request pH
void getpH() {
  getParam('P');
}

//Send message to device to request Ammonia
void getAmmonia() {
  getParam('A');
}

//Send message to device to request Nitrate/Nitrite
void getNitrates(){
  getParam('N');
}

//Send message to server with Temperature data
void sendTemp(){
  int num = myTank.temperature;
  itoa(num,buffer,10); 
  sendMessageToServer('T');
  
}

//Send message to server with pH data
void sendpH(){
  int num = myTank.pH;
  itoa(num,buffer,10); 
  sendMessageToServer('P');
}

//Send message to server with Ammonia data
void sendAmmonia();

//Send message to server with Nitrate/Nitrite data
void getNitrates();


void resetWifiParams();

// Handles when the server wants to know the Temp and pH vals
void handleParamRequest();

//Handles when the server wants to check Nitrate and Ammonia vals
void handleCheckRequest();

void setup() {
  Serial.begin(115200);

  //Set up initial Tank Parameters
  myTank.temperature = 500;
  myTank.pH = 400;

  
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

void handleParamRequest() {

  //Check PCB for Temp
  getTemp();
  //Check PCB for pH
  getpH();
  Serial.println("In handler");
  server.send(200, "text/plain", "fetching Temp and pH vals");

  sendTemp();
  
}

void handleCheckRequest() {
  server.send(200, "text/plain", "checking chemical levels");
}


void loop() {
  server.handleClient();

  if(WiFi.status()== WL_CONNECTED) {   //Check WiFi connection status
 
   http.begin("http://35.6.191.190:5000/fromTank/sendRando");      //Specify request destination
   http.addHeader("Content-Type", "text/plain");  //Specify content-type header
   int num  = random(0,10); 
   itoa(num,buffer,10); 

    
   int httpCode = http.POST(buffer);                   //Send the request
   String payload = http.getString();                  //Get the response payload
 
   Serial.println(httpCode);   //Print HTTP return code
   //Serial.println(payload);    //Print request response payload
 
   http.end();  //Close connection
 
 }else {
 
    Serial.println("Error in WiFi connection");   
 
 }
  delay(3000);  //Send a request every 30 seconds

  
}


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
        case 'A':{ // Ammonia Reading
             http.begin(url_address + "/fromTank/sendAmmonia" );
             break;    
        }
        case 'N':{ // Nitrate/Nitrite Reading
             http.begin(url_address + "/fromTank/sendNitrate" );   
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