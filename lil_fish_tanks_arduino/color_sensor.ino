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

typedef struct
{
  uint8_t R, G, B;  
}Pixel;

typedef struct
{
  double ppm;
  Pixel p;
}Color;

Color Ammonia[MAX_AMMONIA_COLORS];
Color Nitrite[MAX_NITRITE_NITRATE_COLORS];
Color Nitrate[MAX_NITRITE_NITRATE_COLORS];  


colorData rgb;
Color c;

MD_TCS230  CS(S2, S3, OE);


// add possible color strip values to specific arrays
void addColors()
{
  int index = 0;
  Color c;
  c.ppm = 0.0;
  c.p = {0, 0, 0};
  Ammonia[index] = c;

  c.ppm = 0.0;
  c.p = {0, 0, 0};
  Nitrite[index] = c;

  c.ppm = 0.0;
  c.p = {0, 0, 0};
  Nitrate[index] = c;

  ++index;

  c.ppm = 0.25;
  c.p = {0, 0, 0};
  Ammonia[index] = c;

  c.ppm = 0.15;
  c.p = {0, 0, 0};
  Nitrite[index] = c;

  c.ppm = 0.5;
  c.p = {0, 0, 0};
  Nitrate[index] = c;

  ++index;

  c.ppm = 0.5;
  c.p = {0, 0, 0};
  Ammonia[index] = c;

  c.ppm = 0.3;
  c.p = {0, 0, 0};
  Nitrite[index] = c;

  c.ppm = 2.0;
  c.p = {0, 0, 0};
  Nitrate[index] = c;

  ++index;

  c.ppm = 3.0;
  c.p = {0, 0, 0};
  Ammonia[index] = c;

  c.ppm = 1.0;
  c.p = {0, 0, 0};
  Nitrite[index] = c;

  c.ppm = 5.0;
  c.p = {0, 0, 0};
  Nitrate[index] = c;

  ++index;

  c.ppm = 6.0;
  c.p = {0, 0, 0};
  Ammonia[index] = c;

  c.ppm = 1.5;
  c.p = {0, 0, 0};
  Nitrite[index] = c;

  c.ppm = 10.0;
  c.p = {0, 0, 0};
  Nitrate[index] = c;

  ++index;

  c.ppm = 3.0;
  c.p = {0, 0, 0};
  Nitrite[index] = c;

  c.ppm = 20.0;
  c.p = {0, 0, 0};
  Nitrate[index] = c;

  ++index;

  c.ppm = 10.0;
  c.p = {0, 0, 0};
  Nitrite[index] = c;

  c.ppm = 50.0;
  c.p = {0, 0, 0};
  Nitrate[index] = c;
}

double ScanColor()
{
  // Scan for color 
  CS.read();
  while(CS.available()==0);  // wait for read to complete
  CS.getRGB(&rgb); 
  // look for match
  return FindMatch();  
}

double FindMatch()
{
  // Look through colours looking for a match
  switch(typeToRead)
  {
    case AMMONIA:
    {
      // start at highest ammonia level - false positive better than false negative
      for(int i = MAX_AMMONIA_COLORS - 1; i >= 0; --i)
      {
        c = Ammonia[i];
        if(SameColor())
          return Ammonia[i].ppm;
      }
      return -1;
      break;
    }
    case NITRITE:
    {
      // start at highest nitrite level - false positive better than false negative
      for(int i = MAX_NITRITE_NITRATE_COLORS - 1; i >= 0; --i)
      {
        c = Nitrite[i];
        if(SameColor())
          return Nitrite[i].ppm;
      }
      return -1;
      break;
    }
    case NITRATE:
    {
      // start at highest nitrate level - false positive better than false negative
      for(int i = MAX_NITRITE_NITRATE_COLORS - 1; i >= 0; --i)
      {
        c = Nitrate[i];
        if(SameColor())
          return Nitrate[i].ppm;
      }
      return -1;
      break;
    }   
  }
}

bool SameColor()
{
  // values of stored color being compared against
  uint8_t redExpected = rgb.value[TCS230_RGB_R];
  uint8_t greenExpected = rgb.value[TCS230_RGB_R];
  uint8_t blueExpected = rgb.value[TCS230_RGB_R];

  // check if RGB values are within range specified by tolerance
  if (c.p.R < (redExpected - TOLERANCE) or c.p.R > (redExpected + TOLERANCE))
    return false;
  if (c.p.G < (greenExpected - TOLERANCE) or c.p.G > (greenExpected + TOLERANCE))
    return false;
  if (c.p.B < (blueExpected - TOLERANCE) or c.p.B > (blueExpected + TOLERANCE))
    return false;
  Serial.print(F("\nFound Matching Color"));
  return true;
}
