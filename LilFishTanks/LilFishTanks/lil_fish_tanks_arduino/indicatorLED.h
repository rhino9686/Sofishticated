// Pin definitions
#define  R_LED  2
#define  G_LED  3
#define  B_LED   4

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
LEDColor Black = {0, 0, 0};


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
	setLED(Black);
}