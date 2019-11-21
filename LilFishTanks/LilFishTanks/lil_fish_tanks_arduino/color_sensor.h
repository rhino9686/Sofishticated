// TCS230 sensor and colour calibration
//
// Input and output using the Serial console.
//
#include <MD_TCS230.h>   // color sensor library
#include <FreqCount.h>   // used by above library

// Pin definitions
#define  S2  12
#define  S3  13
#define  OE   8               // LOW = ENABLED
#define MAX_AMMONIA_COLORS 5
#define MAX_NITRITE_NITRATE_COLORS 7
#define TOLERANCE 5              // How far out the red,green or blue can be to match

typedef struct
{
	int R, G, B;
}Pixel;

typedef struct
{
	double ppm;
	Pixel p;
}Color;

enum ReadType {
	AMMONIA,
	NITRATE,
	NITRITE,
	FIND_TEST_STRIP
};

ReadType typeToRead;

Color Ammonia[MAX_AMMONIA_COLORS];
Color Nitrite[MAX_NITRITE_NITRATE_COLORS];
Color Nitrate[MAX_NITRITE_NITRATE_COLORS];

Color EmptyTestBox {0, {0, 0, 7}};
Color WhiteTestStrip {0, {20, 23, 48}};

colorData rgb;
Color c;

uint8_t greenScanned;
uint8_t redScanned;
uint8_t blueScanned;

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
	c.p = {255, 95, 95};
	Nitrite[index] = c;

	c.ppm = 0.0;
	c.p = {255, 95, 95};
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


bool SameColor()
{
	Serial.print("c: ");
	Serial.print(c.p.R);
	Serial.print(" ");
	Serial.print(c.p.G);
	Serial.print(" ");
	Serial.print(c.p.B);
	Serial.print("read_in: ");
	Serial.print(redScanned);
	Serial.print(" ");
	Serial.print(greenScanned);
	Serial.print(" ");
	Serial.print(blueScanned);
	// check if RGB values are within range specified by tolerance
	if (redScanned < (c.p.R - TOLERANCE) || redScanned > (c.p.R + TOLERANCE))
		return false;
	if (greenScanned < (c.p.G - TOLERANCE) || greenScanned > (c.p.G + TOLERANCE))
		return false;
	if (blueScanned < (c.p.B - TOLERANCE) || blueScanned > (c.p.B + TOLERANCE))
		return false;
	
	Serial.print(F("\nFound Matching Color"));
	return true;
}

double FindMatch()
{
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

long ScanColor()
{
	CS.read();
	while(CS.available() == 0);  // wait for read to complete
	CS.getRGB(&rgb);
	greenScanned = rgb.value[TCS230_RGB_G];
	redScanned = rgb.value[TCS230_RGB_R];
	blueScanned = rgb.value[TCS230_RGB_B];
	// look for match
	Serial.println("RGB");
	Serial.println(redScanned);
	Serial.println(greenScanned);
	Serial.println(blueScanned);
	//return FindMatch();
}

bool findTestStrip()
{
	// Scan for color
	CS.read();
	while (CS.available() == 0);
	CS.getRGB(&rgb);
	greenScanned = rgb.value[TCS230_RGB_G];
	redScanned = rgb.value[TCS230_RGB_R];
	blueScanned = rgb.value[TCS230_RGB_B];
	// look for match against black
	c = EmptyTestBox;
	bool foundEmptyBox = SameColor();
	Serial.print(" foundEmptyBox ");
	Serial.println(foundEmptyBox);
	Serial.print("\n");
	c = WhiteTestStrip;
	foundEmptyBox =  foundEmptyBox || SameColor();
	Serial.print(" foundEmptyBoxOrTestStrip ");
	Serial.println(foundEmptyBox);
	Serial.print("\n");
	return foundEmptyBox && (FindMatch() == -1);
}