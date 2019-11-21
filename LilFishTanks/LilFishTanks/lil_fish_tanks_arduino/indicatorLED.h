// Pin definitions
#define  R_LED  A1
#define  G_LED  A2
#define  B_LED  A3

typedef struct 
{
	int r, g, b;
} LEDColor;
// colors for LED
LEDColor Red = {255, 0, 0};
LEDColor Green = {0, 255, 0};
LEDColor Blue = {0, 0, 255};
LEDColor Raspberry = {255, 255, 255};
LEDColor Cyan = {0, 255, 255};
LEDColor Magenta = {255, 0, 255};
LEDColor Yellow = {255, 255, 0};
LEDColor White = {255, 255, 255};
LEDColor Off = {0, 0, 0};


void setLED(LEDColor c)
{
	analogWrite(R_LED, c.r);
	analogWrite(G_LED, c.g);
	analogWrite(B_LED, c.b);
}

void setupLED()
{
	pinMode(R_LED, OUTPUT);
	pinMode(G_LED, OUTPUT);
	pinMode(B_LED, OUTPUT);
	setLED(Off);
}