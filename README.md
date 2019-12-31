## Sofishticated: 
### A smarter fish tank for your finned friend

![close_up](https://user-images.githubusercontent.com/41589697/71604908-26a69800-2b33-11ea-80fa-e5c2636d1bf4.jpeg)


This was our final project for EECS 473, Advanced Embedded Systems at the University of Michigan.


The Sofishticated smart tank module is made a monitoring system that can connect to a fish tank and measure live data about its temperature and pH, while also controlling a water heater to keep it at optimal levels. The data is then streamed to an iPhone app, which lets a user see it and store fish profiles. 

![far_away](https://user-images.githubusercontent.com/41589697/71604920-3d4cef00-2b33-11ea-815b-50a8049a89a6.jpeg)


## Overview:



## Technology:
The main component of the device is the enclosed Printed Circuit Board system, which runs a port of FreeRTOS for Arduino. The RTOS ran drivers for the pH sensor and Temperature sensor written in C and C++.

![pcb](https://user-images.githubusercontent.com/41589697/71606034-b7817180-2b3b-11ea-8abe-e3f3c50c45d5.jpeg)

The PCB was connected to an ESP8266, which transmits the collected data over Wi-fi to a Flask Server, which relayed it to an iPhone App.


## Installation:
Be advised that this software was designed for a custom PCB designed and constructed from scratch, but can be adapted to any Arduino or Atmel system with a bit of hacking.

## The sauce
All the C/C++ code that we run on the board is in LilFishTanks/LilFishTanks/lil_fish_tanks_arduino/.

All the Phone App code is in FishTank_app/FishTank/FishTank/.

## Authors
#### (left to right)

* **David Waier** 

* **Madeline Devore** 

* **Celine Schlueter**

* **Robert Cecil** 

* **Ray Puyat** 

![cuties](https://user-images.githubusercontent.com/41589697/71604888-f3640900-2b32-11ea-96e6-fc64cbe460e1.jpeg)


## License
[MIT](https://choosealicense.com/licenses/mit/)