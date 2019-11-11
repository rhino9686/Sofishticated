//This is the Device's Code for the device to communicate with the ESP8266



//Tank Invariant
struct TankData {
  int Temp; //temperature, if real temp is 70.3, then temp here will be 7030
  int pH;   //pH of tank, if real pH is 8.5, then pH here will be 850
};

TankData myTank; // Our Tank

char str[4];

void setup() {
  // set the baud rate at 
    Serial.begin(115200);

    myTank.Temp = 7030;
    myTank.pH = 850;

  // clear str
  clearBuffer();

}

void loop() {
  
  int i=0;

  if (Serial.available()) {
    delay(100); //allows all serial sent to be received together
    while(Serial.available() && i<4) {
      str[i++] = Serial.read();
    }
    str[i++]='\0';
  }
  
  if (i> 4) {

    if (str[2] == "T") { //Wi-Fi module wants Temperature
      SerialWriteInt(myTank.Temp + random(0, 24));
    }

    else if (str[2] == "P") { //Wi-Fi module wants pH value
      SerialWriteInt(myTank.pH + random(0, 10) );
    }
 
  }
}


void SerialWriteInt(int &largenum) {
  
  byte buf[4];
  buf[0] = largenum & 255;
  buf[1] = (largenum >> 8)  & 255;
  buf[2] = (largenum >> 16) & 255;
  buf[3] = (largenum >> 24) & 255;
  Serial.write(buf, sizeof(buf));

}

void clearBuffer(){
  // clears the serial message buffer
  str[0] = '0';
  str[1] = '0';
  str[2] = '0';
  str[3] = '0';
}
