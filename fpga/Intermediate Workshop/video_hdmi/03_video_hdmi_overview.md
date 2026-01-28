# Overview: Setting Up Video over HDMI

Before we can build the game logic for Pong, we first need to configure the system to display graphics over HDMI. This section provides an overview of how we will use pre-built VHDL components to show video over HDMI.

## What is Logic Reuse in VHDL?

A digital system is often made up of several smaller subsystems. This allows you to design large systems using simpler and pre-designed components as building blocks. 

In VHDL, components (entity/architecture pairs) may be reused in different portions of your logic. These components may be instantiated, which creates a copy of them in the logic gates of your FPGA. These copies may have their inputs and outputs connected to other signals in your program. This allows designers to reuse components within and across designs, organize their logic hierarchically, and create vastly more complicated designs via abstraction. 

## How This Applies to This Project

In the provided skeleton for this project, several subsystems are already implemented for you, including modules for:
- Video timing
- I2C communication
- Pixel rendering

These subsystems are all connected together by a top-level file: `hdmi_top.vhd`, which acts as a wrapper for all these modules. A wrapper calls all of our separate modules and connects them together in one place.  

Although these modules are pre-written, feel free to refer to the [appendices](../appendices/) for a deeper understanding of how the code works.

---
The first step in building the Pong game is to set up HDMI output. To do this, we have to instatiate all of our pre-built modules in the top-level file: `hdmi_top.vhd`. We will instatiate our PLL IP core: `pll_74mhz` as a component. Then we will instatiate the local pre-written modules: `video_timing`, `i2c_config`, and `renderer` as entities.

---
|Back: [IP Core - Phase-Locked Loop](../set_up/02_phase_locked_loop.md) | [Top](../README.md) |Next: [Instantiating Components](04_instatiate_pll.md)|
|---|---|---|