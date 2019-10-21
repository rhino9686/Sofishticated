/*Begining of Auto generated code by Atmel studio */
#include <Arduino.h>
/*End of auto generated code by Atmel studio */

#include <Arduino_FreeRTOS.h>
#include <semphr.h>
#include "color_sensor.h"
#include "indicatorLED.h"
//Beginning of Auto generated function prototypes by Atmel Studio
void fromWifi();
//End of Auto generated function prototypes by Atmel Studio



// task definitions
void TaskAmmoniaRead( void *pvParameters );
void TaskNitriteRead( void *pvParameters );
void TaskNitrateRead( void *pvParameters );
void TaskPHRead( void *pvParameters );
void TaskTemperatureRead( void *pvParameters );

SemaphoreHandle_t xSerialSemaphoreColorSensor;
SemaphoreHandle_t xSerialSemaphoreWifi;

TaskHandle_t xAmmonia;
TaskHandle_t xNitrite;
TaskHandle_t xNitrate;
TaskHandle_t xPH;
TaskHandle_t xTemperature;

// the setup function runs once when you press reset or power the board
void setup() {
  
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB, on LEONARDO, MICRO, YUN, and other 32u4 based boards.
  }

  // load test strip color data and initialize indicator LED
  addColors();
  setupLED();

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
    TaskNitriteRead
    ,  (const portCHAR *) "Nitrite"
    ,  128  // Stack size
    ,  NULL
    ,  2  // Priority
    ,  &xNitrite );

  xTaskCreate(
    TaskNitrateRead
    ,  (const portCHAR *) "Nitrate"
    ,  128  // Stack size
    ,  NULL
    ,  2  // Priority
    ,  &xNitrate );

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

  // Now the task scheduler, which takes over control of scheduling individual tasks, is automatically started.
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
      setLED(Red);
      typeToRead = AMMONIA;
	  vTaskDelay(700); // wait 10 sec for the test strip to develop
      double value = ScanColor();
	  // TODO: transmit value to Wifi module
			  
      xSemaphoreGive( xSerialSemaphoreColorSensor );
      //suspend until triggered by next interrupt from Wifi module
      vTaskSuspend(NULL);
    }

    vTaskDelay(1); // 1 tick delay between reads for stability
  }
}

// get Nitrite reading from color sensor
void TaskNitriteRead(void *pvParameters)
{
  (void) pvParameters;
  
  TickType_t xLastWakeTime = xTaskGetTickCount();
  pinMode(LED_BUILTIN, OUTPUT);
  for (;;) // A Task shall never return or exit.
  {
    if ( xSemaphoreTake( xSerialSemaphoreColorSensor, ( TickType_t ) 1 ) == pdTRUE )
    {
      setLED(Green);
      typeToRead = NITRITE;
	  vTaskDelay(4000); // wait 1 min for the test strip to develop
      double value = ScanColor();
	  // TODO: transmit to Wifi module
      xSemaphoreGive( xSerialSemaphoreColorSensor );
      //suspend until triggered by next interrupt from Wifi module
      vTaskSuspend(NULL);
    }

    vTaskDelay(1); // 1 tick delay between reads for stability
  }
}

// get Nitrate reading from color sensor
void TaskNitrateRead(void *pvParameters)
{
  (void) pvParameters;
  
  TickType_t xLastWakeTime = xTaskGetTickCount();
  pinMode(LED_BUILTIN, OUTPUT);
  for (;;) // A Task shall never return or exit.
  {
    if ( xSemaphoreTake( xSerialSemaphoreColorSensor, ( TickType_t ) 1 ) == pdTRUE )
    {
      setLED(Blue);
      typeToRead = NITRATE;
	  vTaskDelay(4000); // wait 1 min for the test strip to develop
      double value = ScanColor();
	  // TODO: transmit to Wifi module
	  
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
    // TODO: get pH value, transmit to Wifi
    digitalWrite(LED_BUILTIN, LOW);
    // check pH every 15 min
    vTaskDelayUntil( &xLastWakeTime, 900000 / portTICK_PERIOD_MS );
  }
}

// get Temperature reading from sensor
void TaskTemperatureRead(void *pvParameters)
{
  (void) pvParameters;
  
  TickType_t xLastWakeTime = xTaskGetTickCount();
  for (;;) // A Task shall never return or exit.
  {
    // TODO: get temperature value, transmit to Wifi
    digitalWrite(LED_BUILTIN, LOW);
    // check temperature every 15 min
    vTaskDelayUntil( &xLastWakeTime, 900000 / portTICK_PERIOD_MS );
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
    case 'i':
      vTaskResume(xNitrite);
      break;
    case 'n':
      vTaskResume(xNitrate);
      break;
  }
}
