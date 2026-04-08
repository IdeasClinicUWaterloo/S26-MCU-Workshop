library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is
    Port (
        SW    : in  std_logic_vector (9 downto 0);
        LEDR  : out std_logic_vector (9 downto 0);
        HEX0  : out std_logic_vector (6 downto 0)  -- 7-segment display
    );
end FullAdder;

architecture Behavioral of FullAdder is
    signal Sum  : std_logic;
    signal Cout : std_logic;
begin

    -- Full Adder Logic
    Sum  <= SW(0) XOR SW(1) XOR SW(2);
    Cout <= (SW(0) AND SW(1)) OR (SW(1) AND SW(2)) OR (SW(0) AND SW(2));



    -- Use logic instead of concatenation
    process(Sum, Cout)
    begin
        if Cout = '0' and Sum = '0' then
            HEX0 <= "1000000"; -- 0
        elsif Cout = '0' and Sum = '1' then
            HEX0 <= "1111001"; -- 1
        elsif Cout = '1' and Sum = '0' then
            HEX0 <= "0100100"; -- 2
        elsif Cout = '1' and Sum = '1' then
            HEX0 <= "0110000"; -- 3
        else
            HEX0 <= "1111111"; -- blank/off (should not occur)
        end if;
    end process;

end Behavioral;
