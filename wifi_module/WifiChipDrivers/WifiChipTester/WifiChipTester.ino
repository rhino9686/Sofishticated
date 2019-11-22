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
char str[10];

//HTTPClient to send messages to Server
HTTPClient http;    


void resetWifiParams();

void setup() {
 
  Serial.begin(115200);                         //Serial connection
  WiFi.begin("MSetup");   //WiFi connection
 
  while (WiFi.status() != WL_CONNECTED) {  //Wait for the WiFI connection completion
    delay(500);
  }

  
}
 
void loop() {

  
 if(WiFi.status()== WL_CONNECTED) {   //Check WiFi connection status

  //Send Param request to PCB
   Serial.write("p");

    if (Serial.available()) {
    delay(100); //allows all serial sent to be received together
    while(Serial.available() ) {
      str = Serial.readString();
    }
  }


   http.begin("http://35.6.158.8:5000/fromTank/sendRando");      //Specify request destination
   http.addHeader("Content-Type", "text/plain");  //Specify content-type header

    
   int httpCode = http.POST(str);                   //Send the request
   String payload = http.getString();                 //Get the response payload
 
 
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
