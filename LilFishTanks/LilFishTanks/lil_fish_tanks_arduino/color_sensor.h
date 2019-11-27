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

// add possible color strip values to specific arrays
void setupCS();

// check if scanned color matches a specific stored color
bool SameColor();

// go through all stored colors of a certain chemical to find a match
double FindMatch();

// get current color value from sensor
long ScanColor(ReadType r);

// check if we are seeing a valid test strip, not just an empty box
bool findTestStrip(ReadType r);