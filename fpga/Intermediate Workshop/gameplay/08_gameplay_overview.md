# Overview: Pong Game Play

In this part, we will connect the `game_logic` component to the top-level file, `hdmi_top.vhd`, then write logic to drive the movement of paddles in `game_logic.vhd`.

## Background: Understanding `game_logic.vhd`

For this part, we will be working mostly in the `game_logic` file. It is mostly pre-written for you. The `game_logic` entity has 7 inputs and 6 outputs. Read the comments next to each port to learn more about them. 

The file also contains a process which serves as the main game loop, and updates the game state every frame. Presently, the game loop deals with the motion of the ball, detecting collisions with the walls and paddles, and scoring logic. 

You may notice that many of the output ports have variables within the process that are modified internally before being assigned out (e.g., `ball_x` is assigned to a variable named `bx_n`, which is the one used in the process). In VHDL, an out port cannot have its value read from within the component. To allow us to make decisions based on the present value, and keep the entity declaration clean, we create an internal variable and assign the outport to that. This is a common practice in VHDL. 

---

|Back: [Drawing Rectangles on the Screen](../video_hdmi/07_draw_rectangles.md) | [Top](../README.md) |Next: [Drawing Game Objects](09_draw_objects.md)|
|---|---|---|