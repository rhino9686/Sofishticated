/*Begining of Auto generated code by Atmel studio */
#include <Arduino.h>
/*End of auto generated code by Atmel studio */

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
int tempThreshold = 25;

char colorToRead = 'a';
bool alreadyStarted = false;
int count = 0;

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
	Serial.begin(115200);
	while (!serial) {
		; // wait for serial port to connect. Needed for native USB, on LEONARDO, MICRO, YUN, and other 32u4 based boards.
	}
  
	// initialize Wifi module (Maybe?)
	// drive Wifi Enable pin High
	digitalWrite(wifiRst, HIGH);
	// load test strip color data and initialize indicator LED
	CS.begin();
	addColors();
	setupLED();
	//Serial.println("Starting setup");
	
	setLED(Blue);
  
	// initialize pH sensor
	//phInit();
 
	// TODO: Not sure how Wifi module indicates that it is getting data - replace that with the interrupt from pin2 
	attachInterrupt(digitalPinToInterrupt(2), fromWifi, RISING);
	
	if (xSerialSemaphoreColorSensor == NULL)
	{
		//xSerialSemaphoreColorSensor = xSemaphoreCreateBinary();
		vSemaphoreCreateBinary(xSerialSemaphoreColorSensor);
		/*if (xSerialSemaphoreColorSensor != NULL )
		{
			xSemaphoreGive(xSerialSemaphoreColorSensor);	
		} */
		
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
	
	
	delay(1000);
	setLED(Off);
	//Serial.print("Inside setup");

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
		//Serial.println("Inside dead task");
		//vTaskDelayUntil( &xLastWakeTime, 500 / portTICK_PERIOD_MS );
		if ( xSemaphoreTake( xSerialSemaphoreColorSensor, ( TickType_t ) 100 ) == pdTRUE )
		{
			setLED(White);
			//Serial.println("checking color");
			if (colorToRead == 'a')
			{
				
				
				//while (findTestStrip());
				//setLED(Green);
				delay(1000); // let user see LED and stop moving before measuring
				
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
				//setLED(Blue);
				delay(250);
				
				nitriteValue = ScanColor() * 100;
			}
			setLED(Off);	  
			//xSemaphoreGive( xSerialSemaphoreColorSensor );
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
	//delay(500);
	setLED(Green);
	//Serial.print("p\n");
	phValue = calcPH() * 100;
	//Serial.print("\npH Value:");
	//Serial.print(phValue);
	delay(250);
	setLED(Off);
	
	setLED(Red);
	// Gets temperature value in Celsius
	tempValue = measureTemp() * 100;
	//Serial.print("t\n");
	//Serial.print(tempValue);

	// RELAY LOGIC (switching on 0.5 above and below temperature threshold)
	if (tempValue < (tempThreshold + 0.5)) {
		digitalWrite(relay, HIGH);
	} else if (tempValue > (tempThreshold + 0.5)) {
		digitalWrite(relay, LOW);
	}
	                             
	delay(100);
	setLED(Off);
    // check pH and temp every 15 min
    vTaskDelayUntil( &xLastWakeTime, 10000 / portTICK_PERIOD_MS );
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
	if (alreadyStarted){
		action = 'a';
		//Serial.println("already started");
		++count;
		//Serial.println(count);
		if (count == 10)
		{
			count = 0;
			action = 'p';
		}
	}

	switch(action)
	{
	case 'p':
	{
		//Serial.println("inside case color");
		colorToRead = 'a';
		alreadyStarted = true;
		//static BaseType_t xHigherPriorityTaskWoken;
		//xHigherPriorityTaskWoken = pdFALSE;

		xSemaphoreGiveFromISR(xSerialSemaphoreColorSensor, pdFALSE);

		/*setLED(White);
		Serial.println("checking color");
		//if (colorToRead == 'a')
		//{
			
			
			//while (findTestStrip());
			//setLED(Green);
			delay(500); // let user see LED and stop moving before measuring
			
			//typeToRead = AMMONIA;
			//ammoniaValue = ScanColor() * 100;
		//}
		setLED(Off);*/
		break;
	}
	case 'n':
	{
		colorToRead = 'n';
		vTaskResume(xColorSensor);
		break;
	}
	case 'a':
	{
		serial.println("inside case print");
		setLED(Blue);
		serial.write("ph:");
		serial.write(phValue);
		serial.write("temp:");
		serial.write(tempValue);
		serial.write("ammonia:");
		serial.write(ammoniaValue);
		serial.write("nitrite:");
		serial.write(nitriteValue);
		serial.write("nitrate:");
		serial.write(nitrateValue);
		delay(200);
		setLED(Off);
		break;
	}
	default:
		break;
	}
}
