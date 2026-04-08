# Activity 2: Seven Segment Priority Display

## Part 2: Seven-Segment Displays

![Seven Segment Display](../assets/seven_segment.png)

To drive the seven-segment display, a seven-digit binary number, formatted as "abcdef", is assigned to the display, using the following syntax.

```vhdl
HEX0 <= "gfedcba";
```

This code corresponds to the seven-segment display closest to the right side of the board. The display is active low, so to turn a segment on, it should be assigned a 0. So, to display the digit 7 we need to set segments 'a', 'b', and 'c' to low. To display this number on the rightmost display the instruction would be,

```vhdl
HEX0 <= "1111000";
```

**NOTE regarding the use of quotation marks. For vectors, e.g., std_logic_vector, double quotation marks (") should be used, such as for driving the seven-segment display. For individual logic states, e.g., std_logic, single quotation marks (') are used.

## Process

A process is a section of the code that will run whenever it is triggered. This trigger could be whenever a button is triggered, a switch is turned, or the value of an internal signal is changed. Variables to be used within processes are declared outside of the core code of the process.

![Process Example](../assets/process_example.png)

## If Else Statement

An if statement is used to make decisions based on certain conditions, just like it is done in regular programming languages. It allows you to select between different actions or signal assignments depending on whether a condition is true or false.

![If Else Example](../assets/if_else_example.png)

## Example Code

This is a simple script that checks the value of two switches, and if they are high, displays a 1 on the seven-segment display. Otherwise, the display shows 0. You can use this as a reference for the following activity to understand the syntax.

```vhdl
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY SegExample IS
    PORT (
        SW   : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) -- 7-seg display (active-low)
    );
END SegExample;

ARCHITECTURE Behavioral OF SegExample IS

--SIGNAL declarations (not used in this example)


BEGIN

    --PROCESS declaration
    PROCESS (SW) --the process will run anytime there is a change to the SW vector
    BEGIN
        IF (SW(0) = '1') AND (SW(1) = '1') THEN
            HEX0 <= "1111001"; -- Display "1"
        ELSE
            HEX0 <= "1000000"; -- Display "0"
        END IF;
    END PROCESS;
    --PROCESS end

END Behavioral;
```

## Activity Instructions

The goal of this activity is to drive the seven-segment display using on-board switches. Each switch being flipped should correspond to a number being displayed on the board, e.g. when SW3 is flipped; a 3 is displayed on the seven-segment display.

To write the architecture of this VHDL code, start by declaring a signal to store the binary number corresponding to the active switches. Then, create a process that monitors the state of all input switches. 

Use a series of if statements to determine which switch is turned on, giving priority to the one with the lowest index. When a switch is found to be active, assign its index value (in binary) to the signal you created. If no switches are on, assign a default value to indicate "no input."

Finally, ensure the output is assigned to the 7-segment display port HEX0, so the number appears on the screen.

#### **NOTE While you will be writing code to test from sw(3) downto sw(0), the top level file is going to shift these to sw(7) downto sw(4) when you're testing it on the physical board.

---

|Back: [Activity 1](activity_1.md) | [Top](../README.md) |Next: [Activity 3](activity_3.md)|
|---|---|---|