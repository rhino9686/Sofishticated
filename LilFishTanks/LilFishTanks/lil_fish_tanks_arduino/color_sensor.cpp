#include "color_sensor.h"


Color Ammonia[MAX_AMMONIA_COLORS];
Color Nitrite[MAX_NITRITE_NITRATE_COLORS];
Color Nitrate[MAX_NITRITE_NITRATE_COLORS];

Color EmptyTestBox {0, {35, 36, 70}};
Color WhiteTestStrip {0, {60, 63, 107}};

colorData rgb;
Color c;

uint8_t greenScanned;
uint8_t redScanned;
uint8_t blueScanned;

ReadType typeToRead;

MD_TCS230  CS(S2, S3, OE);

// add possible color strip values to specific arrays
void setupCS()
{
	CS.begin();
	
	int index = 0;
	Color c;
	c.ppm = 0.0;
	c.p = {64, 62, 90};
	Ammonia[index] = c;

	c.ppm = 0.0;
	c.p = {74, 77, 120};
	Nitrite[index] = c;

	c.ppm = 0.0;
	c.p = {71, 74, 123};
	Nitrate[index] = c;

	++index;

	c.ppm = 0.5;
	c.p = {61, 62, 91};
	Ammonia[index] = c;

	c.ppm = 0.15;
	c.p = {71, 74, 123};
	Nitrite[index] = c;

	c.ppm = 0.5;
	c.p = {60, 60, 101};
	Nitrate[index] = c;

	++index;

	c.ppm = 1.0;
	c.p = {50, 63, 90};
	Ammonia[index] = c;

	c.ppm = 0.3;
	c.p = {64, 67, 114};
	Nitrite[index] = c;

	c.ppm = 2.0;
	c.p = {68, 65, 114};
	Nitrate[index] = c;

	++index;

	c.ppm = 3.0;
	c.p = {52, 60, 90};
	Ammonia[index] = c;

	c.ppm = 1.0;
	c.p = {52, 52, 94};
	Nitrite[index] = c;

	c.ppm = 5.0;
	c.p = {58, 53, 96};
	Nitrate[index] = c;

	++index;

	c.ppm = 6.0;
	c.p = {48, 54, 86};
	Ammonia[index] = c;

	c.ppm = 1.5;
	c.p = {49, 48, 88};
	Nitrite[index] = c;

	c.ppm = 10.0;
	c.p = {49, 48, 88};
	Nitrate[index] = c;

	++index;

	c.ppm = 3.0;
	c.p = {54, 46, 88};
	Nitrite[index] = c;

	c.ppm = 20.0;
	c.p = {50, 44, 86};
	Nitrate[index] = c;

	++index;

	c.ppm = 10.0;
	c.p = {52, 42, 82};
	Nitrite[index] = c;

	c.ppm = 50.0;
	c.p = {47, 43, 82};
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
			// find matching ammonia value
			for(int i = 0; i < MAX_AMMONIA_COLORS; ++i)
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
			// find matching nitrite value
			for(int i = 0; i < MAX_NITRITE_NITRATE_COLORS; ++i)
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
			// find matching nitrate value
			for(int i = 0; i < MAX_NITRITE_NITRATE_COLORS; ++i)
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

long ScanColor(ReadType r)
{
	typeToRead = r;
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
	return FindMatch();
}

bool findTestStrip(ReadType r)
{
	typeToRead = r;
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
	c = WhiteTestStrip;
	foundEmptyBox =  foundEmptyBox || SameColor();
	return foundEmptyBox && (FindMatch() == -1);
}