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



// task definitions
void TaskAmmoniaRead( void *pvParameters );
void TaskNitriteNitrateRead( void *pvParameters );
void TaskPHRead( void *pvParameters );
void TaskTemperatureRead( void *pvParameters );

SemaphoreHandle_t xSerialSemaphoreColorSensor;
SemaphoreHandle_t xSerialSemaphoreWifi;

TaskHandle_t xAmmonia;
TaskHandle_t xNitriteNitrate;
TaskHandle_t xPH;
TaskHandle_t xTemperature;



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
	TaskAmmoniaRead
	,  (const portCHAR *)"Ammonia"
	,  128
	,  NULL
	,  2
	,  &xAmmonia );

	/*xTaskCreate(
	TaskNitriteNitrateRead
	,  (const portCHAR *) "Nitrite/Nitrate"
	,  128
	,  NULL
	,  2
	,  &xNitriteNitrate );*/

	xTaskCreate(
	TaskPHRead
	,  (const portCHAR *) "pH"
	,  128
	,  NULL
	,  2
	,  &xPH );

	xTaskCreate(
	TaskTemperatureRead
	,  (const portCHAR *) "Temperature"
	,  128
	,  NULL
	,  2
	,  &xTemperature );
	
	//vTaskSuspend(xAmmonia);
	//vTaskSuspend(xNitriteNitrate);
	
	delay(1000);
	setLED(Off);
	//calibratePH(25);
	Serial.print("Inside setup");

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

// get Ammonia reading from color sensor
void TaskAmmoniaRead(void *pvParameters)
{
	(void) pvParameters;
  
	TickType_t xLastWakeTime = xTaskGetTickCount();
	pinMode(LED_BUILTIN, OUTPUT);
	for (;;) // A Task shall never return or exit.
	{
		//if ( xSemaphoreTake( xSerialSemaphoreColorSensor, ( TickType_t ) 1 ) == pdTRUE )
		//{
			setLED(White);
			while (findTestStrip());
			//setLED(Green);
			delay(250); // let user see LED and stop moving before measuring
	  
			typeToRead = AMMONIA;
			ammoniaValue = ScanColor() * 100;
	  
			setLED(Off);	  
			xSemaphoreGive( xSerialSemaphoreColorSensor );
			// suspend until triggered by next interrupt from Wifi module
			vTaskSuspend(NULL);
		//}
		vTaskDelayUntil( &xLastWakeTime, 1000 / portTICK_PERIOD_MS );
		//vTaskDelay(1); // 1 tick delay between reads for stability
	}
}

// get Nitrite reading from color sensor
void TaskNitriteNitrateRead(void *pvParameters)
{
	(void) pvParameters;
  
	TickType_t xLastWakeTime = xTaskGetTickCount();
	pinMode(LED_BUILTIN, OUTPUT);
	for (;;) // A Task shall never return or exit.
	{
		if ( xSemaphoreTake( xSerialSemaphoreColorSensor, ( TickType_t ) 1 ) == pdTRUE )
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
			
			setLED(Off);
			xSemaphoreGive( xSerialSemaphoreColorSensor );
			//suspend until triggered by next interrupt from Wifi module
			vTaskSuspend(NULL);
			}
		vTaskDelay(1); // 1 tick delay between reads for stability
	}
}

// get pH reading from sensor
void TaskPHRead(void *pvParameters)
{
  (void) pvParameters;
  
  TickType_t xLastWakeTime = xTaskGetTickCount();
  for (;;) // A Task shall never return or exit.
  {
	// Gets pH value
	//delay(500);
	setLED(Green);
	Serial.write("Inside PH\n");
	//long temp = measureTemp();
	phValue = getPH(tempValue) * 100;
	Serial.write("\npH Value:");
	//Serial.write(phValue);
	Serial.print(phValue);
	delay(100);
	setLED(Off);
    // check pH every 15 min
    vTaskDelayUntil( &xLastWakeTime, 500 / portTICK_PERIOD_MS );
  }
}

// get Temperature reading from sensor
void TaskTemperatureRead(void *pvParameters)
{
	(void) pvParameters;
  
	TickType_t xLastWakeTime = xTaskGetTickCount();
	for (;;) // A Task shall never return or exit.
	{
		setLED(Red);
		// Gets temperature value in Celsius
		tempValue = measureTemp() * 100;
		Serial.write("Temp value:\n");
		Serial.print(tempValue);
		
		delay(100);
		setLED(Off);
		// check temperature every 2 min (CURRENTLY 2 SEC)
		vTaskDelayUntil( &xLastWakeTime, 2000 / portTICK_PERIOD_MS );
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
		vTaskResume(xAmmonia);
		break;
	}
	case 'n':
	{
		vTaskResume(xNitriteNitrate);
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
