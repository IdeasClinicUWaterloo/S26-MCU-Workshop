library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SwitchDisplay is
    Port (
        SW   : in  STD_LOGIC_VECTOR(9 downto 0); -- 10 switches
        HEX0 : out STD_LOGIC_VECTOR(6 downto 0)  -- 7-segment display (active-low)
    );
end SwitchDisplay;

architecture Behavioral of SwitchDisplay is

    signal number : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- Priority encoder: choose the lowest switch index that is ON
    process(SW)
    begin
        if    SW(0) = '1' then number <= "0000"; -- 0
        elsif SW(1) = '1' then number <= "0001"; -- 1
        elsif SW(2) = '1' then number <= "0010"; -- 2
        elsif SW(3) = '1' then number <= "0011"; -- 3
        elsif SW(4) = '1' then number <= "0100"; -- 4
        elsif SW(5) = '1' then number <= "0101"; -- 5
        elsif SW(6) = '1' then number <= "0110"; -- 6
        elsif SW(7) = '1' then number <= "0111"; -- 7
        elsif SW(8) = '1' then number <= "1000"; -- 8
        elsif SW(9) = '1' then number <= "1001"; -- 9
        else number <= "1111"; -- Nothing ON → blank or error
        end if;
    end process;

    -- 7-segment decoder (common cathode: 0 = ON, 1 = OFF)
    process(number)
    begin
        case number is
            when "0000" => HEX0 <= "1000000"; -- 0
            when "0001" => HEX0 <= "1111001"; -- 1
            when "0010" => HEX0 <= "0100100"; -- 2
            when "0011" => HEX0 <= "0110000"; -- 3
            when "0100" => HEX0 <= "0011001"; -- 4
            when "0101" => HEX0 <= "0010010"; -- 5
            when "0110" => HEX0 <= "0000010"; -- 6
            when "0111" => HEX0 <= "1111000"; -- 7
            when "1000" => HEX0 <= "0000000"; -- 8
            when "1001" => HEX0 <= "0010000"; -- 9
            when others => HEX0 <= "1111111"; -- blank
        end case;
    end process;

end Behavioral;
