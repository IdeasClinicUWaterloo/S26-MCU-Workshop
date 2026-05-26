---
title: 'Arduino Intermediate Activity'
---

# Welcome to the Arduino Intermediate Workshop!

This intermediate workshop builds on prior knowledge of microcontrollers and introduces polling loops, interrupts, and timers.
Microcontrollers are small one-chip computers that are at the core of much of today’s technology to automate and control tasks. Generally, they have a Central Processing Unit (CPU), some memory, and programmable input and output ports.

With polling loops, our code manually checks the status of any input pins at a regular interval, and then we can respond. Interrupts are used for more critical events so that the code can respond more quickly. 

These concepts will be used to create a simple, 2-player version of the game Pong. 

# Required Materials 

- 1x Arduino UNO 
- 1x OLED Display 
- 1x Breadboard 
- 3x Pushbuttons 
- 12x Wires
- 1x USB-C Cable 
- Arduino IDE installed.
  [Click here for instructions on how to install Arduino IDE](../arduino_setup/README.ipynb)

# Table of Contents

This workshop is broken up into four activities.
Each activity will introduce you to one key concept.
After you complete each activity, you will have the knowhow to create your own Pong game.

1. [Building the circuit for Pong](00_overview.ipynb)
2. [Exercise 1: connecting to the screen](exercises/connect_to_screen/tutorial.ipynb)
3. [Exercise 2: button polling](exercises/button_polling/tutorial.ipynb)
4. [Exercise 3: interrupts](exercises/interrupts/tutorial.ipynb)
5. [Exercise 4: time-based functions and how they are implemented under the hood](exercises/time_functions/tutorial.ipynb)
6. [Build your own pong!](implementing_pong/instructions.ipynb)

---
Next: [Building the circuit for Pong](00_overview.ipynb)
