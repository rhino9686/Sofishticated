/*Begining of Auto generated code by Atmel studio */
#include <Arduino.h>
/*End of auto generated code by Atmel studio */

#include <Arduino_FreeRTOS.h>
#include <semphr.h>
#include <assert.h>
#include "tempSensor.h"
#include "color_sensor.h"
#include "indicatorLED.h"
#include "phSensor.h"

void fromWifi();

int phValue = 0;
int tempValue = 0;
int ammoniaValue = 0;
int nitrateValue = 0;
int nitriteValue = 0;

char colorToRead = 'a';



// task definitions
void TaskColorSensor( void *pvParameters );
void TaskPHandTemperature( void *pvParameters );

SemaphoreHandle_t xSerialSemaphoreColorSensor;
SemaphoreHandle_t xSerialSemaphoreWifi;

TaskHandle_t xColorSensor;
TaskHandle_t xPHandTemperature;


// the setup function runs once when you press reset or power the board
void setup() {  
	// initialize serial communication at 115200 bits per second:
	Serial.begin(115200);
  
	while (!Serial) {
		; // wait for serial port to connect. Needed for native USB, on LEONARDO, MICRO, YUN, and other 32u4 based boards.
	}
  
	// initialize Wifi module (Maybe?)

	// load test strip color data and initialize indicator LED
	CS.begin();
	addColors();
	setupLED();
	Serial.print("Starting setup");
	
	setLED(Green);
  
	// initialize pH sensor
	phInit();

	// TODO: Not sure how Wifi module indicates that it is getting data - replace that with the interrupt from pin2 
	attachInterrupt(digitalPinToInterrupt(2), fromWifi, RISING);

	// Now set up two tasks to run independently.
	xTaskCreate(
	TaskColorSensor
	,  (const portCHAR *)"ColorSensor"
	,  128
	,  NULL
	,  1
	,  &xColorSensor );

	xTaskCreate(
	TaskPHandTemperature
	,  (const portCHAR *) "PHandTemperature"
	,  128
	,  NULL
	,  2
	,  &xPHandTemperature );
	
	//vTaskSuspend(xColorSensor);
	
	delay(1000);
	setLED(Off);
	//calibratePH(25);
	Serial.print("Inside setup");

	// Now the task scheduler, which takes over control of scheduling individual tasks, is automatically started.
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
		//if ( xSemaphoreTake( xSerialSemaphoreColorSensor, ( TickType_t ) 1 ) == pdTRUE )
		//{
			if (colorToRead == 'a')
			{
				Serial.println("c");
				setLED(White);
				//while (findTestStrip());
				//setLED(Green);
				delay(250); // let user see LED and stop moving before measuring
				
				typeToRead = AMMONIA;
				ammoniaValue = ScanColor() * 100;
			}
			else
			{
				setLED(Red);
				typeToRead = NITRATE;
				while (findTestStrip());
				setLED(Green);
				delay(250); // allow user to see LED and stop moving test strip

				nitrateValue = ScanColor() * 100;
				
				setLED(Off);
				
				typeToRead = NITRITE;
				while (findTestStrip());
				setLED(Blue);
				delay(250);
				
				nitriteValue = ScanColor() * 100;
			}
			setLED(Off);	  
			//xSemaphoreGive( xSerialSemaphoreColorSensor );
			// suspend until triggered by next interrupt from Wifi module
			//vTaskSuspend(NULL);
		//}
		vTaskDelayUntil( &xLastWakeTime, 1000 / portTICK_PERIOD_MS );
		//vTaskDelay(1); // 1 tick delay between reads for stability
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
	//delay(500);
	setLED(Green);
	Serial.write("p\n");
	//long temp = measureTemp();
	phValue = getPH(tempValue) * 100;
	//Serial.write(phValue);
	Serial.print(phValue);
	delay(100);
	setLED(Off);
	
	setLED(Red);
	// Gets temperature value in Celsius
	tempValue = measureTemp() * 100;
	Serial.write("t\n");
	Serial.print(tempValue);
	
	delay(100);
	setLED(Off);
    // check pH and temp every 15 min
    vTaskDelayUntil( &xLastWakeTime, 5000 / portTICK_PERIOD_MS );
  }
}


void fromWifi()
{
	int i = 0;
	char action = '\0';
	// check for data from Wifi
	if (Serial.available())
	{
		delay(100); // allows all serial sent to be received together
		while (Serial.available())
		{
			action = Serial.read();
		}
	}

	switch(action)
	{
	case 'a':
	{
		colorToRead = 'a';
		vTaskResume(xColorSensor);
		break;
	}
	case 'n':
	{
		colorToRead = 'n';
		vTaskResume(xColorSensor);
		break;
	}
	case 'p':
	{
		Serial.write("ph:");
		Serial.write(phValue);
		Serial.write("temp:");
		Serial.write(tempValue);
		Serial.write("ammonia:");
		Serial.write(ammoniaValue);
		Serial.write("nitrite:");
		Serial.write(nitriteValue);
		Serial.write("nitrate:");
		Serial.write(nitrateValue);
	}
	default:
		break;
	}
}
