-- ========================================
-- TOP LEVEL FILE: beginner_top.vhd
-- Integrates Activities 1, 2, and 3
-- For Cyclone V GX Starter Kit
-- ========================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity beginner_top is
    Port (
        -- Switches (10 available, using 8)
        SW : in STD_LOGIC_VECTOR(9 downto 0);
        
        -- LEDs (using LEDR for visibility)
        LEDR : out STD_LOGIC_VECTOR(9 downto 0);
        
        -- Seven-Segment Displays
        HEX0 : out STD_LOGIC_VECTOR(6 downto 0);
        HEX1 : out STD_LOGIC_VECTOR(6 downto 0)
    );
end beginner_top;

architecture Behavioral of beginner_top is
    
    -- Component Declarations
    component activity_1 is
        Port (
            SW : in STD_LOGIC_VECTOR(2 downto 0);
            LED : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;
    
    component activity_2 is
        Port (
            SW : in STD_LOGIC_VECTOR(3 downto 0);
            HEX0 : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
    
    component activity_3 is
        Port (
            SW : in STD_LOGIC_VECTOR(2 downto 0);
            HEX1 : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
    
    -- Internal signals
    signal activity1_leds : STD_LOGIC_VECTOR(1 downto 0);
    
begin
    
    -- Map Activity 1 LEDs to LEDR[1:0]
    LEDR(1 downto 0) <= activity1_leds;
    LEDR(9 downto 2) <= (others => '0');  -- Turn off unused LEDs
    
    -- Activity 1: Full Adder (SW[2:0] -> LEDR[1:0])
    ACT1: activity_1
        port map (
            SW => SW(2 downto 0),
            LED => activity1_leds
        );
    
    -- Activity 2: Switch to Display (SW[7:4] -> HEX0)
    ACT2: activity_2
        port map (
            SW => SW(7 downto 4),
            HEX0 => HEX0
        );
    
    -- Activity 3: Adder with Display (SW[2:0] -> HEX1)
    ACT3: activity_3
        port map (
            SW => SW(2 downto 0),
            HEX1 => HEX1
        );
    
end Behavioral;