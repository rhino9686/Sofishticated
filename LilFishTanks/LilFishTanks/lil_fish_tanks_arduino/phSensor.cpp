#include "phSensor.h"

DFRobot_PH ph;

void phInit() {
	ph.begin();
}

float getPH(long temperaturePH) {
	float voltage = analogRead(PH_PIN)/1024.0*5000;
	float phValue = ph.readPH(voltage, temperaturePH);
	return phValue;
}

void calibratePH(long temperaturePH) {
	float voltage = analogRead(PH_PIN)/1024.0*5000;
	ph.calibration(voltage, temperaturePH);
}