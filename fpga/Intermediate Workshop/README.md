---
title: 'FPGA Intermediate Activity'
author: 'Chris Rennick, Fareed Rasheed, Hailey Doleweerd, Orion Bruckman, Caitlyn Kwan, Nancy Nelson'
---

> [!WARNING]
> This is a complex workshop.
> Please read each page completely from top to bottom before starting the work on that page.

# Welcome to the FPGA Intermediate Workshop!

In this workshop, you will build a functional version of Pong. You will combine several pre-built elements with your own VHDL to display patterns over HDMI, keep track of game objects and state, and render the game. By the end of this workshop, you should be able to: 

- Understand the advantages of licensed IP cores and how to use them in Quartus Prime 
- Learn how to write reusable logic and integrate multiple components together to create a cohesive product 
- Know how and when to use conditional assignments 

# Required Materials 

- FPGA development board
- USB cable for programming
- Monitor
- HDMI cable
- Project files from this repository
- Intel Quartus Prime Lite Edition installed.
  [Click here for instructions on how to install Quartus](../../quartus_setup/README.md)


# Table of Contents

This workshop is broken up into a series of guided steps. 

Each section will introduce you to several key concepts that will help you build your own Pong game.

### Setting up 
1. [Set up your project](set_up/01_project_setup.md)
2. [IP Core - Phase-Locked Loop](set_up/02_phase_locked_loop.md)

### Setting Up Video over HDMI 
3. [Overview: Setting Up Video over HDMI](video_hdmi/03_video_hdmi_overview.md)
4. [Instantiating Components](video_hdmi/04_instatiate_pll.md)
5. [Instantiating Entities](video_hdmi/05_instatiate_local_vhdl.md)
6. [Connecting the FPGA to an HDMI Monitor](video_hdmi/06_display_over_hdmi.md)
7. [Drawing Rectangles on the Screen](video_hdmi/07_draw_rectangles.md)

### Pong Game Play
8. [Overview: Pong Game Play](gameplay/08_gameplay_overview.md)
9. [Drawing Game Objects](gameplay/09_draw_objects.md)
10. [Implement Paddle Movement](gameplay/10_paddle_movement.md)

---
Next: [Set up your project](set_up/01_project_setup.md)
