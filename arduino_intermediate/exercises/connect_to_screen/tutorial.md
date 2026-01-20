# Connecting to Display Tutorial


## I2C Comminication
I2C is an important protocol for serial communication between devices. It is often used to connect peripherals like sensors or displays to a central controller system. In this case, I2C communication will be used to connect the Arduino microcontroller to the OLED display. I2C uses two wires to enable this synchronous transmission of data, the first being SCL which is the Serial Clock which keeps the two systems synchronized, and SDA which is Serial Data and is used for the serial transmission of data. The Arduino UNO has 2 dedicated I2C pins labelled SCL and SDA that can be used.  

Here’s the code to display the player paddles, scores, and ball for the Pong game. Copy and paste this into your project, then compile and upload the program. Sections in orange should already be included in the skeleton project. 

You’ll need to install some libraries to interface with the screen. In the Arduino Library manager, search Adafruit GFX and Adafruit SSD1306. Make sure to also install all dependencies.  

You’ll know you’re successful when you see the scores, paddles, and a ball on the screen. 


This code can be pasted into a new sketch. Once you understand the process of writing to the screen, you can add this code to the corresponding sections of the skeleton to add display functionality. 


### Includes
````cpp
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
````


### Definitions 
````cpp
// Screen Variables
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// Score tracking
int scoreP1 = 0;
int scoreP2 = 0;

const int PADDLE_WIDTH = 2;
const int PADDLE_HEIGHT = 12;

// Position tracking for player 1 paddle
int P1_X =0;
int P1_Y = 32;
// Position tracking for player 2 paddle
int P2_X = 128-PADDLE_WIDTH;
int P2_Y = 32;
// Position tracking for ball
int ballX = 64;
int ballY = 32;
````

### Setup Code
````cpp
display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
display.clearDisplay();
display.setTextSize(1);
display.setTextColor(SSD1306_WHITE);
````

### Loop Code
````cpp 
// Display must first be cleared 
display.clearDisplay();

// Sets up text for the player scores
display.setTextSize(1);
display.setCursor(40, 0);
display.print("P1:");
display.print(scoreP1);
display.print("  P2:");
display.print(scoreP2);
display.setCursor(40,10);

// Set up paddles
display.fillRect(P1_X, P1_Y, PADDLE_WIDTH, PADDLE_HEIGHT, SSD1306_WHITE);
display.fillRect(P2_X, P2_Y, PADDLE_WIDTH, PADDLE_HEIGHT, SSD1306_WHITE);
// Set up ball
display.fillRect(ballX, ballY, 2, 2, SSD1306_WHITE);

display.display();
// Displays everything
delay(15);
````

## Challenge 
Add the code necessary to display a game time in the format: “MM:SS” where MM are the number of minutes and SS are the number of seconds. For now, just display “00:00”. We will set up a timer to include the game time later in the workshop. 

## Troubleshooting

If your screen starts to show a bunch of random pixels, please add the following line to the very top of your `setup()` function: 

````cpp
Wire.setWireTimeout(10000);
````

---

|Back: [Building the circuit for Pong](../../00_overview.md) | [Top](../../README.md) |Next: [Exercise 2: button polling](../button_polling/tutorial.md)|
|---|---|---|

