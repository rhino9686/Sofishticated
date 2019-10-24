﻿/*Begining of Auto generated code by Atmel studio */
#include <Arduino.h>
/*End of auto generated code by Atmel studio */

#include <Arduino_FreeRTOS.h>
#include <semphr.h>
#include <assert.h>
#include "tempSensor.h"
#include "color_sensor.h"
#include "indicatorLED.h"
#include "phSensor.h"
//Beginning of Auto generated function prototypes by Atmel Studio
void fromWifi();
//End of Auto generated function prototypes by Atmel Studio



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
  
  // initialize Wifi module
  Serial.write("AT");
  //String okay = Serial.read(); // unsure how to read from Wifi module
  //assert(okay == "OK"); // module is on
  Serial.write("AT+CWMODE=1"); // client mode

  // load test strip color data and initialize indicator LED
  addColors();
  setupLED();
  
  // initialize pH sensor
  phInit();
  
  digitalWrite(0, LOW);

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

  xTaskCreate(
    TaskNitriteNitrateRead
    ,  (const portCHAR *) "Nitrite/Nitrate"
    ,  128  // Stack size
    ,  NULL
    ,  2  // Priority
    ,  &xNitriteNitrate );

  xTaskCreate(
    TaskPHRead
    ,  (const portCHAR *) "pH"
    ,  128  // Stack size
    ,  NULL
    ,  2  // Priority
    ,  &xPH );

  xTaskCreate(
    TaskTemperatureRead
    ,  (const portCHAR *) "Temperature"
    ,  128  // Stack size
    ,  NULL
    ,  2  // Priority
    ,  &xTemperature );
	
  vTaskSuspend(xAmmonia);
  vTaskSuspend(xNitriteNitrate);

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
    if ( xSemaphoreTake( xSerialSemaphoreColorSensor, ( TickType_t ) 1 ) == pdTRUE )
    {
	  digitalWrite(9, HIGH);
	  setLED(Blue);
	  while (findTestStrip());
	  setLED(Green);
	  delay(250); // let user see LED and stop moving before measuring
	  
      typeToRead = AMMONIA;
      long value = ScanColor();
	  // TODO: transmit value to Wifi module
	  Serial.write("AT+CTIPSEND"); // indicate we are about to send ammonia
	  Serial.write("ammonia");
	  Serial.write("AT+CTIPSEND"); // send ammonia
	  Serial.write(value);
	  
	  setLED(Off);	
	  digitalWrite(9, LOW);		  
      xSemaphoreGive( xSerialSemaphoreColorSensor );
      // suspend until triggered by next interrupt from Wifi module
      vTaskSuspend(NULL);
    }

    vTaskDelay(1); // 1 tick delay between reads for stability
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
      while (!findTestStrip());
      setLED(Green);
	  delay(250); // allow user to see LED and stop moving test strip
      typeToRead = NITRATE;
	  //vTaskDelay(4000); // wait 1 min for the test strip to develop
      long value = ScanColor();
	  // TODO: transmit to Wifi module
	  Serial.write("AT+CTIPSEND"); // indicate we are about to send nitrate
	  Serial.write("nitrate");
	  Serial.write("AT+CTIPSEND"); // send nitrate
	  Serial.write(value);
	  
	  setLED(Off);
	  
	  while (!findTestStrip())
	  {
		  // transmit error to Wifi module
	  }
	  setLED(Blue);
	  typeToRead = NITRITE;
	  //vTaskDelay(4000); // wait 1 min for the test strip to develop
	  value = ScanColor();
	  // TODO: transmit to Wifi module
	  Serial.write("AT+CTIPSEND"); // indicate we are about to send nitrite
	  Serial.write("nitrite");
	  Serial.write("AT+CTIPSEND"); // send nitrite
	  Serial.write(value);
	  
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
    setLED(Red);
	digitalWrite(9, HIGH);
	// Gets pH value
	delay(500);
	long phValue = getPH();
	
	//TODO: Transmit ph to Wifi
	Serial.write("AT+CTIPSEND"); // indicate we are about to send pH
	Serial.write("pH");
	Serial.write("AT+CTIPSEND"); // send pH
	Serial.write(phValue);
	
    setLED(Off);
	digitalWrite(9, LOW);
    // check pH every 15 min
    vTaskDelayUntil( &xLastWakeTime, 4000 / portTICK_PERIOD_MS );
  }
}

// get Temperature reading from sensor
void TaskTemperatureRead(void *pvParameters)
{
  (void) pvParameters;
  
  TickType_t xLastWakeTime = xTaskGetTickCount();
  for (;;) // A Task shall never return or exit.
  {
	setLED(Blue);
    // Gets temperature value in Celsius
	long temp = measureTemp();
	
	// TODO: transmit to Wifi
	Serial.write("AT+CTIPSEND"); // indicate that we are about to send temp
	Serial.write("temp");
	Serial.write("AT+CTIPSEND"); // send temp
	Serial.write(temp);
	
	setLED(Off);
    // check temperature every 2 min
    vTaskDelayUntil( &xLastWakeTime, 7500 / portTICK_PERIOD_MS );
  }
}

void fromWifi()
{
  //TODO: get this indicator from Wifi module
  char action = 'a';

  switch(action)
  {
    case 'a':
      vTaskResume(xAmmonia);
      break;
    case 'n':
      vTaskResume(xNitriteNitrate);
      break;
  }
}
