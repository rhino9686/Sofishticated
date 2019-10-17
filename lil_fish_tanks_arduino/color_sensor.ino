// TCS230 sensor and colour calibration
// 
// Input and output using the Serial console.
//
#include <MD_TCS230.h>   // colour sensor library
#include <FreqCount.h>   // used by above library
#include <EEPROM.h>      // Ensure data is still valid after power offs

// Pin definitions
#define  S2_OUT  12
#define  S3_OUT  13
#define  OE_OUT   8               // LOW = ENABLED wh
#define MAX_COLOURS 10            // Max colours allowed to store, 10 takes up 140 bytes
#define TOLERANCE 35              // How far out the red,green or blue can be to match

typedef struct
{
  String Name;             // Name for Colour, plus 1 extra for terminator '0'
  uint8_t Red,Green,Blue;  // The colour values
}SingleColour;

SingleColour Colours[MAX_COLOURS];        // Our array of colours to match against       
uint8_t NumColours;                     // Current Number of colours   

MD_TCS230  CS(S2_OUT, S3_OUT, OE_OUT);

void setup() 
{
  Serial.begin(115200);
  CS.begin();
  // Check if we have some calibration data

  /*sensorData sd;
  sd.value[0] = 0;
  sd.value[1] = 0;
  sd.value[1] = 0;
  CS.setDarkCal(&sd); 
  sd.value[0] = 255;
  sd.value[1] = 255;
  sd.value[1] = 255;
  CS.setWhiteCal(&sd);  */
  int index = 0;
  SingleColour sc;
  sc.Name = "Ammonia0.0";
  sc.Red = 255; sc.Green = 99; sc.Blue = 100;
  Colours[index++] = sc;
  ++NumColours;

  sc.Name = "Ammonia0.25";
  sc.Red = 180; sc.Green = 35; sc.Blue = 65;
  Colours[index++] = sc;
  ++NumColours;
  
}

void loop() 
{
  static char Choice;            

  Choice=MainMenu();
  switch(Choice)
  {
    case '1': 
      ScanColour();
      break;
  }
}

char MainMenu()
{  
  char Choice;
  Serial.print(F("\nCalibration Menu (Choose option and press RETURN)\n"));
  Serial.print(F("1 Scan Colour\n"));
  return getChar();
}

void ScanColour()
{
  // Scan and find a colour on the sensor
  colorData  rgb;  
  CS.read();
  while(CS.available()==0);  // wait for read to complete
  CS.getRGB(&rgb);  
  int8_t ColIdx=MatchColour(&rgb);  
  Serial.print(F("\nScanning for RGB["));
  Serial.print(rgb.value[TCS230_RGB_R]);
  Serial.print(F(","));
  Serial.print(rgb.value[TCS230_RGB_G]);
  Serial.print(F(","));
  Serial.print(rgb.value[TCS230_RGB_B]);
  Serial.print(F("]\n"));
  if(ColIdx==-1)
    Serial.println("\nNo match found");
  else
  {
    Serial.print("\nThat colour is ");
    Serial.print(Colours[ColIdx].Name);
    Serial.print(" [");
    Serial.print(Colours[ColIdx].Red);
    Serial.print(F(","));
    Serial.print(Colours[ColIdx].Green);
    Serial.print(F(","));
    Serial.print(Colours[ColIdx].Blue);
    Serial.println("]");
  }
}

int8_t MatchColour(colorData *rgb)
{
  // Look through colours looking for a match
  uint8_t Idx=0;
  bool Found=false;
  while((Idx<NumColours)&(Found==false))
  {
    if((CheckColour(rgb->value[TCS230_RGB_R],Colours[Idx].Red)) &(CheckColour(rgb->value[TCS230_RGB_G],Colours[Idx].Green))&(CheckColour(rgb->value[TCS230_RGB_B],Colours[Idx].Blue)))
          Found=true;
    Idx++;
  }
  if(Found) return Idx-1; else return -1;
}

bool CheckColour(uint8_t ScanCol, uint8_t StoredCol)
{
  // returns true if matched on this single colour else false
  int16_t StoreColLow,StoreColHigh;
  StoreColLow=StoredCol-TOLERANCE;
  StoreColHigh=StoredCol+TOLERANCE;
  if(StoreColLow<0) StoreColLow=0;
  if(StoreColHigh>255) StoreColHigh=255;
  return ((ScanCol>=StoreColLow)&(ScanCol<=StoreColHigh));

}

char getChar()
// Wait for user to return a char over serial connection, returns uppercase version of any alpha char
{
  while (Serial.available() == 0)
    ;
  return(toupper(Serial.read()));
}
