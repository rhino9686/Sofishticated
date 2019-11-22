#include "phSensor.h"

DFRobot_PH ph;
float neutralVoltage = 397.0;
float acidVoltage = 324.0;

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

float calcPH()
{
	float voltage = analogRead(PH_PIN);
	float slope = (7.0 - 4.0)/(neutralVoltage - acidVoltage);
	float intercept = 7.0-(slope * neutralVoltage);
	Serial.write("Neutral Voltage:");
	Serial.print(neutralVoltage);
	Serial.write("\nAcid Voltage:");
	Serial.print(acidVoltage);
	Serial.write("\nVoltage Measured:");
	Serial.print(voltage);
	return (slope * voltage) + intercept;
}