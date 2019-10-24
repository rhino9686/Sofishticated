#include "DFRobot_PH.h"
#include <EEPROM.h>

#define PH_PIN A1
float voltage, phValue, temperature = 25;
DFRobot_PH ph;

void phInit() {
	ph.begin();
}

float getPH() {
	voltage = analogRead(PH_PIN)/1024.0*5000;
	phValue = ph.readPH(voltage, temperature);
	return phValue;
}

void calibratePH() {
	ph.calibration(voltage, temperature);
}