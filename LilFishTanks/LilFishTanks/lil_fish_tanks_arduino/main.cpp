#include <Arduino.h>
#include <Arduino_FreeRTOS.h>
#include <SoftwareSerial.h>
#include <semphr.h>
#include <assert.h>
#include "tempSensor.h"
#include "color_sensor.h"
#include "indicatorLED.h"
#include "phSensor.h"

#define rxPin 2
#define txPin 3
#define relay 4
#define wifiRst 10

void fromWifi();

long phValue = 0;
int tempValue = 0;
int ammoniaValue = 0;
int nitrateValue = 0;
int nitriteValue = 0;
int tempThreshold = 2500;

char colorToRead = 'A';

// task definitions
void TaskColorSensor( void *pvParameters );
void TaskPHandTemperature( void *pvParameters );

SemaphoreHandle_t xSerialSemaphoreColorSensor;

TaskHandle_t xColorSensor;
TaskHandle_t xPHandTemperature;

SoftwareSerial serial(rxPin, txPin);

// the setup function runs once when you press reset or power the board
void setup() {  
	// initialize serial communication at 115200 bits per second:
	serial.begin(115200);
	pinMode(wifiRst, OUTPUT);
	pinMode(relay, OUTPUT);
	digitalWrite(relay, HIGH);
	Serial.begin(115200);
	while (!serial) {
		; // wait for serial port to connect. Needed for native USB, on LEONARDO, MICRO, YUN, and other 32u4 based boards.
	}
  
	// drive Wifi Enable pin High
	digitalWrite(wifiRst, HIGH);
	// load test strip color data and initialize indicator LED
	setupCS();
	setupLED();
 
	// create interrupt to be triggered by Wifi module
	//attachInterrupt(digitalPinToInterrupt(2), fromWifi, RISING);
	
	if (xSerialSemaphoreColorSensor == NULL)
	{
		vSemaphoreCreateBinary(xSerialSemaphoreColorSensor);		
	}


	// Now set up two tasks to run independently.
	xTaskCreate(
	TaskColorSensor
	,  (const portCHAR *)"ColorSensor"
	,  128
	,  NULL
	,  2
	,  &xColorSensor ); 

	xTaskCreate(
	TaskPHandTemperature
	,  (const portCHAR *) "PHandTemperature"
	,  128
	,  NULL
	,  2
	,  &xPHandTemperature );

	// Now the task scheduler, which takes over control of scheduling individual tasks, is automatically started.
	vTaskStartScheduler();
}

void loop()
{
  // Empty. Things are done in Tasks.
}

/*--------------------------------------------------*/
/*---------------------- Tasks ---------------------*/
/*--------------------------------------------------*/

// get Ammonia, Nitrite, and Nitrate reading from color sensor
void TaskColorSensor(void *pvParameters)
{
	(void) pvParameters;
  
	TickType_t xLastWakeTime = xTaskGetTickCount();
	for (;;) // A Task shall never return or exit.
	{
		if ( xSemaphoreTake( xSerialSemaphoreColorSensor, ( TickType_t ) 100 ) == pdTRUE )
		{
			setLED(White);
			switch (colorToRead)
			{
				case 'A':
				{
					while (findTestStrip(AMMONIA));
					setLED(Red);
					delay(1000); // allow user to see LED and stop moving test strip
					
					ammoniaValue = ScanColor(AMMONIA) * 100;
					break;
				}
				case 'N':
				{
					while (findTestStrip(NITRITE));
					setLED(Blue);
					delay(1000);  // allow user to see LED and stop moving test strip
					
					nitriteValue = ScanColor(NITRITE) * 100;
					break;
				}
				case 'n':
				{
					while (findTestStrip(NITRATE));
					setLED(Green);
					delay(1000); // allow user to see LED and stop moving test strip

					nitrateValue = ScanColor(NITRATE) * 100;
					
					setLED(Off);
					break;
				}
			}
			setLED(Off);	  
			xSemaphoreGive( xSerialSemaphoreColorSensor );
		}
		vTaskDelay(1); // 1 tick delay between reads for stability*/
	}
}


// get pH and temp reading from sensors
void TaskPHandTemperature(void *pvParameters)
{
  (void) pvParameters;
  
	TickType_t xLastWakeTime = xTaskGetTickCount();
	for (;;) // A Task shall never return or exit.
	{
		// Gets pH value
		phValue = calcPH() * 100;
		// Gets temperature value in Celsius
		tempValue = measureTemp() * 100;

		// RELAY LOGIC (switching on 0.5 C above and below temperature threshold)
		if (tempValue < (tempThreshold - 50)) {
			digitalWrite(relay, HIGH);
		}
		else if (tempValue > (tempThreshold + 50)) {
			digitalWrite(relay, LOW);
		}
    // check pH and temp every 5 min
    vTaskDelayUntil( &xLastWakeTime, 5000 / portTICK_PERIOD_MS );
  }
}


void fromWifi()
{
	int i = 0;
	char action = '\0';
	// check for data from Wifi
	if (serial.available())
	{
		delay(100); // allows all serial sent to be received together
		while (serial.available())
		{
			action = serial.read();
		}
	}

	switch(action)
	{
	case 'A':
	{
		colorToRead = 'A';
		xSemaphoreGiveFromISR(xSerialSemaphoreColorSensor, pdFALSE);
		serial.write("ammonia:");
		serial.write(ammoniaValue);
		break;
	}
	case 'N':
	{
		colorToRead = 'N';
		xSemaphoreGiveFromISR(xSerialSemaphoreColorSensor, pdFALSE);
		serial.write("nitrate:");
		serial.write(nitrateValue);
		break;
	}
	case 'n':
	{
		colorToRead = 'n';
		xSemaphoreGiveFromISR(xSerialSemaphoreColorSensor, pdFALSE);
		serial.write("nitrite:");
		serial.write(nitriteValue);
		break;
	}
	case 'p':
	{
		serial.write("ph:");
		serial.write(phValue);
		break;
	}
	case 'T':
	{
		serial.write("temp:");
		serial.write(tempValue);
		break;
	}
	default:
		break;
	}
}
