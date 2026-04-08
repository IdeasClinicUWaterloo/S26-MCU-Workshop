-- ========================================
-- ACTIVITY 1: activity_1.vhd
-- Full Adder - outputs to LEDs
-- ========================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity activity_1 is
    Port (
        SW : in STD_LOGIC_VECTOR(2 downto 0);   -- SW0=A, SW1=B, SW2=Cin
        LED : out STD_LOGIC_VECTOR(1 downto 0)  -- LED0=Sum, LED1=Cout
    );
end activity_1;

architecture Behavioral of activity_1 is
begin
    -- Sum = A XOR B XOR Cin
    LED(0) <= SW(0) XOR SW(1) XOR SW(2);
    
    -- Carry Out = (A AND B) OR (A AND Cin) OR (B AND Cin)
    LED(1) <= (SW(0) AND SW(1)) OR (SW(0) AND SW(2)) OR (SW(1) AND SW(2));
end Behavioral;