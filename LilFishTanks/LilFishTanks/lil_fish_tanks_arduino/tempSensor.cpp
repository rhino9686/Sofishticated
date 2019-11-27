#include "tempSensor.h"

#define TEMP_PIN 6

OneWire ds(TEMP_PIN); // Temp sensor on pin 6

float measureTemp() {
	byte i;
	byte data[12];
	byte addr[8];
	float celsius; //, fahrenheit;
	
	ds.reset_search();
	delay(250);
	ds.search(addr);

	if (OneWire::crc8(addr, 7) != addr[7]) {
		return -1;
	}

	ds.reset();
	ds.select(addr);
	ds.write(0x44, 1);        // start conversion, with parasite power on at the end
	
	delay(1000);     // maybe 750ms is enough, maybe not
	
	ds.reset();
	ds.select(addr);
	ds.write(0xBE);         // Read Scratchpad

	for ( i = 0; i < 9; i++) {           // we need 9 bytes
		data[i] = ds.read();
	}

	// Convert the data to actual temperature
	// because the result is a 16 bit signed integer, it should
	// be stored to an "int16_t" type, which is always 16 bits
	// even when compiled on a 32 bit processor.
	int16_t raw = (data[1] << 8) | data[0];

	byte cfg = (data[4] & 0x60);
	// at lower res, the low bits are undefined, so let's zero them
	if (cfg == 0x00) raw = raw & ~7;  // 9 bit resolution, 93.75 ms
	else if (cfg == 0x20) raw = raw & ~3; // 10 bit res, 187.5 ms
	else if (cfg == 0x40) raw = raw & ~1; // 11 bit res, 375 ms
	
	celsius = (float)raw / 16.0;
	return celsius;
}