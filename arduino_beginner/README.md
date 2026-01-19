---
title: 'Arduino Introduction Activity'
author: 'Punit Shah, Karnan Thamilchelvan, Benjamin Zaionz, Avi 
Bhadore, Michelle Chen, Silas Ifeanyi, Michael McPhee, Nancy 
Nelson, Chris Rennick'
---

# Welcome to the Arduino Introduction Activity!

# Microcontrollers

Microcontrollers are small one-chip computers that are at the core of much of today’s 
technology to automate and control tasks. Generally, they have a Central Processing 
Unit (CPU), some memory, and programmable input and output ports. This workshop 
introduces you to the essentials of using an Arduino Uno, a popular microcontroller. 
You’ll learn how to build and control simple digital and analog circuits, send and 
receive data signals between devices, and generate Pulse Width Modulation (PWM) 
signals to control external devices. In the process you’ll use breadboards, meters and 
scopes.

# Required Materials

- 2 Switches (Push Button)
- 2 LEDs
- 1 Breadboard
- 2 Resistors (220 Ω)
- 1 Resistor (10 kΩ)
- 1 Potentiometer
- 1 Oscilloscope
- 1 Multimeter
- 1 Arduino Uno
- Assorted Wires

### Note on computer compatibility
The Arduino IDE does not support Windows operating systems running on a computer with the `ARM64` processor architecture. To check what your processor is on Windows, one way is to type the following into Command Prompt:

``` shell
echo %PROCESSOR_ARCHITECTURE%
```

This should give you one of `AMD64`, `IA64`, or `ARM64` as a reply.
If you get `ARM64`, you will most likely be unable to proceed on your device.
Please either partner up with someone, or request an IdeasClinic laptop from the instructional team.

# Table of Contents

This workshop is broken up into four activities.
Each activity will introduce you to one key concept.
After you complete each activity, you will have the knowhow to create your own Pong game.

1. [Background Information](00_background.md)
2. [Activity 1: Digital Inputs and Outputs](activities/digital_io/tutorial.md)
3. [Activity 2: Analog Inputs and UART](activities/analog_and_uart/tutorial.md)
4. [Activity 3: Pulse Width Modulation](activities/pulse_width_modulation/tutorial.md)

---
Next: [Activity one, digital inputs and outputs](00_digital.md)
