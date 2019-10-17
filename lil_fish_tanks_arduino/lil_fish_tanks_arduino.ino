#include <Arduino_FreeRTOS.h>
#include <semphr.h>

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

enum ReadType {
  AMMONIA,
  NITRATE,
  NITRITE
};

ReadType typeToRead;

double ScanColor();

// the setup function runs once when you press reset or power the board
void setup() {
  
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB, on LEONARDO, MICRO, YUN, and other 32u4 based boards.
  }

  // load test strip color data
  addColors();

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
      // TODO: set indicator LED, analyze color value, transmit to Wifi
      typeToRead = AMMONIA;
      double value = ScanColor();
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
      // TODO: set indicator LED, analyze color value, transmit to Wifi
      typeToRead = NITRITE;
      double value = ScanColor();
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
      // TODO: set indicator LED, analyze color value, transmit to Wifi
      typeToRead = NITRATE;
      double value = ScanColor();
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

// get Temperatuer reading from sensor
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
