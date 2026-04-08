-- ========================================
-- ACTIVITY 3: activity_3.vhd
-- Full Adder with Seven-Segment Display
-- ========================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity activity_3 is
   Port (
       SW : in STD_LOGIC_VECTOR(2 downto 0);    -- SW0=A, SW1=B, SW2=Cin
       HEX1 : out STD_LOGIC_VECTOR(6 downto 0)
   );
end activity_3;

architecture Behavioral of activity_3 is
    
   signal SUM : STD_LOGIC_VECTOR(1 downto 0);
	
    -- Function: Convert digit (0-3) to 7-segment display
	function to_seven_segment(bit_vec : STD_LOGIC_VECTOR(1 downto 0)) return STD_LOGIC_VECTOR is 
	variable SEG : STD_LOGIC_VECTOR(6 downto 0); 
		begin
   
		case bit_vec is
         when "00" => SEG := "1000000"; 		-- 0
			when "01" => SEG := "1111001"; 		-- 1
         when "10" => SEG := "0100100"; 		-- 2
         when "11" => SEG := "0110000"; 		-- 3
			when others => SEG := "1111111"; -- Blank
      end case;
      return SEG;
		  
   end function;
    
begin
    
   -- Full Adder Logic
   SUM(0) <= SW(0) XOR SW(1) XOR SW(2);
   SUM(1) <= (SW(0) AND SW(1)) OR (SW(0) AND SW(2)) OR (SW(1) AND SW(2));
    
    -- Convert result to 7-segment display
    process(SUM)
    begin
        HEX1 <= to_seven_segment(SUM);
    end process;
    
end Behavioral;