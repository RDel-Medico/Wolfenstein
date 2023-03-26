# Wolfenstein (3D Game engine)

Basic 3D game engine based on the game Wolfenstein I made a video to present the project and to present how to install it go check this out if you want! https://www.youtube.com/watch?v=75ZgIOZ5zE4

## Description

Here is my attempt of recreating the game engine used by the 90s game Wolfenstein.
That is to say a 3D projection of a 2D grid map.
Only movement has been implemented (no enemies, weapons, etc.)

## Getting Started

### Dependencies

* In order to run the program you will need Open JDK 17 (https://adoptium.net/)

### Installing

Once you have Open JDK 17 you can install the .zip file and extract it.
You can also use this website to install only 1 directory of this repository : https://download-directory.github.io/
Then you can choose according to your OS and in capacity of your pc the version you want:

* For Linux :
Choose one of the two file that begin with linux (./Wolfenstein-main/linux-XXX)
* For Windows :
Choose one of the two file that begin with windows (./Wolfenstein-main/windows-XXX)
---
* For low capacity computer :
Choose the file that begin with your OS and end with LQ (./Wolfenstein-main/XXX-amd64_LQ)
* For high capacity computer :
Choose the file that begin with your OS and end with HQ (./Wolfenstein-main/XXX-amd64_HQ)

### Executing program

* To run the program on Linux :
In a terminal go under the version you choosed to run and execute the main (under ./Wolfenstein-main/windows-amd64_[HQ/LQ] execute ./main)
---
* To run the program on Windows :
Go under the version you choosed to run and execute the main.exe (./Wolfenstein-main/windows-amd64_[HQ/LQ]/main.exe)

### Help

* The generation of the map is totally random (maybe i will implement a proper maze generator in a later update), so it's common to be in weird situation when you appear such as being in a 1 by 1 room, don't hesitate to go in the 2D representation (the key to do that is shown on screen).
And/or reload the map (the key is also shown on screen).

## Authors

Created by Rémi Del Medico
