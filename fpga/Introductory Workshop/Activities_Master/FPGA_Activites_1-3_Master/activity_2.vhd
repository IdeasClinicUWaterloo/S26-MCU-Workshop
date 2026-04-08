-- ========================================
-- ACTIVITY 2: activity_2.vhd
-- Switch to Seven-Segment Display
-- ========================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity activity_2 is
    Port (
        SW : in STD_LOGIC_VECTOR(3 downto 0);    -- SW[3:0] (or SW[7:4] from main)
        HEX0 : out STD_LOGIC_VECTOR(6 downto 0)
    );
end activity_2;

architecture Behavioral of activity_2 is
    
    signal SEG : STD_LOGIC_VECTOR(6 downto 0);
    
begin
    
    -- Determine which switch is active (priority encoder)
    process(SW)
    begin
        if SW(0) = '1' then
            SEG <= "1111001";  -- or 4 if using SW[7:4]
        elsif SW(1) = '1' then
            SEG <= "0100100";  -- or 5 if using SW[7:4]
        elsif SW(2) = '1' then
            SEG <= "0110000";  -- or 6 if using SW[7:4]
        elsif SW(3) = '1' then
            SEG <= "0011001";  -- or 7 if using SW[7:4]
        else
            SEG <= "1000000";  -- Default: show 0 when no switch is active
        end if;
    end process;
    
    -- Convert digit to 7-segment display
    HEX0 <= SEG;
    
end Behavioral;