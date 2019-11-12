#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WiFiMulti.h> 
#include <ESP8266mDNS.h>
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
#include "Tank.cpp"


bool SETUP_MODE = false;

//Message buffer for HTTP Data
char buffer[10];

//Tank model to store temperature values, chemical readings
Tank myTank = { 
                .temperature = 8050,
                .pH = 705, 
                .ammoniaReading = 0,
                .nitrateReading = 0
                };

//HTTPClient to send messages to Server
HTTPClient http;    

// FUNCTION DECLARATIONS

//Send message to device to request Temperature
void getTemp();

//Send message to device to request pH
void getpH();

//Send message to device to request Ammonia
void getAmmonia();

//Send message to device to request Nitrate/Nitrite
void getNitrates();

//Send message to server with Temperature data
void sendTemp();

//Send message to server with pH data
void sendpH();

//Send message to server with Ammonia data
void sendAmmonia();

//Send message to server with Nitrate/Nitrite data
void getNitrates();


void resetWifiParams();



void setup() {
 
  Serial.begin(115200);                         //Serial connection
  WiFi.begin("Linksys01101", "vpgpgwt900");   //WiFi connection
 
  while (WiFi.status() != WL_CONNECTED) {  //Wait for the WiFI connection completion
    delay(500);
  }

  
}
 
void loop() {

  
 
 if(WiFi.status()== WL_CONNECTED) {   //Check WiFi connection status
 
   http.begin("http://192.168.1.162:5000/fromTank/sendRando");      //Specify request destination
   http.addHeader("Content-Type", "text/plain");  //Specify content-type header
   int num  = random(0,10); 
   itoa(num,buffer,10); 
    
   int httpCode = http.POST(buffer);                   //Send the request
   String payload = http.getString();                  //Get the response payload
 
   //Serial.println(httpCode);   //Print HTTP return code
   //Serial.println(payload);    //Print request response payload
 
   http.end();  //Close connection
 
 }else {
 
    Serial.println("Error in WiFi connection");   
 
 }
  delay(3000);  //Send a request every 30 seconds



  
}


void sendMessageToServer(char param) { //Sends whatever is in buffer to server

 if(WiFi.status()== WL_CONNECTED) {   //Check WiFi connection status

    switch (param) { // Send different HTTP request depending on param character
      
        case 'R': { // Random Number
             http.begin("http://192.168.1.162:5000/fromTank/sendRando" );  
             break;  
        }
        case 'P': { // pH value
             http.begin("http://192.168.1.162:5000/fromTank/sendpH" );   
             break; 
        }
        case 'T':{ // Temperature Value
             http.begin("http://192.168.1.162:5000/fromTank/sendTemp" );   
             break; 
        }
        case 'A':{ // Ammonia Reading
             http.begin("http://192.168.1.162:5000/fromTank/sendAmmonia" );
             break;    
        }
        case 'N':{ // Nitrate/Nitrite Reading
             http.begin("http://192.168.1.162:5000/fromTank/sendNitrate" );   
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





void getParam(char param) {
  return;
}
