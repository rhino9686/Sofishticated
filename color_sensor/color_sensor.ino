// TCS230 sensor and colour calibration
// 
// Input and output using the Serial console.
//
#include <MD_TCS230.h>   // colour sensor library
#include <FreqCount.h>   // used by above library

// Pin definitions
#define  S2  12
#define  S3  13
#define  OE   8               // LOW = ENABLED wh
#define MAX_AMMONIA_COLORS 5
#define MAX_NITRITE_NITRATE_COLORS 7
#define TOLERANCE 35              // How far out the red,green or blue can be to match

enum ReadType {
  AMMONIA,
  NITRATE,
  NITRITE
};

typedef struct
{
  uint8_t R, G, B;  
}Pixel;

typedef struct
{
  String Name;
  Pixel p;
}Color;

Color Ammonia[MAX_AMMONIA_COLORS];
Color Nitrite[MAX_NITRITE_NITRATE_COLORS];
Color Nitrate[MAX_NITRITE_NITRATE_COLORS];  

MD_TCS230  CS(S2, S3, OE);

void setup() 
{
  Serial.begin(115200);
  CS.begin();  
  addColors();
}

void loop() 
{
  static char Choice;            

  Choice=MainMenu();
  switch(Choice)
  {
    case '1': 
      //ScanColor();
      break;
  }
}

// add possible color strip values to specific arrays
void addColors()
{
  int index = 0;
  Color c;
  c.Name = "0.0";
  c.p = {0, 0, 0};
  Ammonia[index] = c;

  c.Name = "0.0";
  c.p = {0, 0, 0};
  Nitrite[index] = c;

  c.Name = "0.0";
  c.p = {0, 0, 0};
  Nitrate[index] = c;

  ++index;

  c.Name = "0.25";
  c.p = {0, 0, 0};
  Ammonia[index] = c;

  c.Name = "0.15";
  c.p = {0, 0, 0};
  Nitrite[index] = c;

  c.Name = "0.5";
  c.p = {0, 0, 0};
  Nitrate[index] = c;

  ++index;

  c.Name = "0.5";
  c.p = {0, 0, 0};
  Ammonia[index] = c;

  c.Name = "0.3";
  c.p = {0, 0, 0};
  Nitrite[index] = c;

  c.Name = "2.0";
  c.p = {0, 0, 0};
  Nitrate[index] = c;

  ++index;

  c.Name = "3.0";
  c.p = {0, 0, 0};
  Ammonia[index] = c;

  c.Name = "1.0";
  c.p = {0, 0, 0};
  Nitrite[index] = c;

  c.Name = "5.0";
  c.p = {0, 0, 0};
  Nitrate[index] = c;

  ++index;

  c.Name = "6.0";
  c.p = {0, 0, 0};
  Ammonia[index] = c;

  c.Name = "1.5";
  c.p = {0, 0, 0};
  Nitrite[index] = c;

  c.Name = "10.0";
  c.p = {0, 0, 0};
  Nitrate[index] = c;

  ++index;

  c.Name = "3.0";
  c.p = {0, 0, 0};
  Nitrite[index] = c;

  c.Name = "20.0";
  c.p = {0, 0, 0};
  Nitrate[index] = c;

  ++index;

  c.Name = "10.0";
  c.p = {0, 0, 0};
  Nitrite[index] = c;

  c.Name = "50.0";
  c.p = {0, 0, 0};
  Nitrate[index] = c;
  
}

char MainMenu()
{  
  char Choice;
  Serial.print(F("\nCalibration Menu (Choose option and press RETURN)\n"));
  Serial.print(F("1 Scan Colour\n"));
  return getChar();
}

void ScanColor(ReadType type)
{
  // Scan for color
  colorData  rgb;  
  CS.read();
  while(CS.available()==0);  // wait for read to complete
  CS.getRGB(&rgb);  
  // look for match
  double testStripValue = FindMatch(&rgb, type);  

}

double FindMatch(colorData *rgb, ReadType type)
{
  // Look through colours looking for a match
  switch(type)
  {
    case AMMONIA:
    {
      for(int i = MAX_AMMONIA_COLORS - 1; i >= 0; --i)
      {
        if(SameColor(rgb, Ammonia[i]))
          return Ammonia[i].Name.toDouble();
      }
      break;
    }
    case NITRITE:
    {

      break;
    }
    case NITRATE:
    {

      break;
    }   
  }


  
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

bool SameColor(colorData *rgb, ReadType type)
{
  bool same = true;
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
