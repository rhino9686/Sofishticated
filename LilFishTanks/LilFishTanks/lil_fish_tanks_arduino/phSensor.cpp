#include "phSensor.h"

//DFRobot_PH ph;
float neutralVoltage = 404.0;
float acidVoltage = 166.0;


float calcPH()
{
	float voltage = analogRead(PH_PIN);
	float slope = (7.0 - 4.0) / (neutralVoltage - acidVoltage);
	float intercept = 7.0 - (slope * neutralVoltage);
	return (slope * voltage) + intercept;
}