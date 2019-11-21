#ifndef phSensor_h
#define phSensor_h

#include "DFRobot_PH.h"
#include <EEPROM.h>

#define PH_PIN A0


void phInit();

float getPH(long temperaturePH);

void calibratePH(long temperaturePH);

#endif