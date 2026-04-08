library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BinaryConverter is
    port (
        SW   : in std_logic_vector(9 downto 0);
        HEX0 : out std_logic_vector(6 downto 0);
        HEX1 : out std_logic_vector(6 downto 0);
        HEX2 : out std_logic_vector(6 downto 0);
        HEX3 : out std_logic_vector(6 downto 0)
    );
end BinaryConverter;

architecture rtl of BinaryConverter is

    signal signed_val : integer;
    signal abs_val    : integer;
    signal sign_bit   : std_logic;
    signal hundreds   : integer;
    signal tens       : integer;
    signal ones       : integer;

    function to_seg(d: integer) return std_logic_vector is
        variable seg : std_logic_vector(6 downto 0);
    begin
        case d is
            when 0 => seg := "1000000";
            when 1 => seg := "1111001";
            when 2 => seg := "0100100";
            when 3 => seg := "0110000";
            when 4 => seg := "0011001";
            when 5 => seg := "0010010";
            when 6 => seg := "0000010";
            when 7 => seg := "1111000";
            when 8 => seg := "0000000";
            when 9 => seg := "0010000";
            when others => seg := "1111111";
        end case;
        return seg;
    end;

    function to_seg_sign(s: std_logic) return std_logic_vector is
    begin
        if s = '1' then
            return "0111111";  -- minus sign
        else
            return "1111111";  -- blank
        end if;
    end;

begin

    process(SW)
        variable temp_signed : integer;
        variable temp_abs    : integer;
        variable temp        : integer;
    begin
        -- Convert input (signed 9-bit number with SW(9) as sign indicator)
        if SW(9) = '1' then
            temp_signed := to_integer(unsigned(SW(8 downto 0))) - 512;
        else
            temp_signed := to_integer(unsigned(SW(8 downto 0)));
        end if;
        signed_val <= temp_signed;

        -- Get absolute value and sign
        if temp_signed < 0 then
            temp_abs := -temp_signed;
            sign_bit <= '1';
        else
            temp_abs := temp_signed;
            sign_bit <= '0';
        end if;
        abs_val <= temp_abs;

        -- Break into decimal digits
        temp := temp_abs;
        hundreds <= temp / 100;
        temp := temp mod 100;
        tens <= temp / 10;
        ones <= temp mod 10;

        -- Assign to 7-segment outputs
        HEX0 <= to_seg(ones);
        HEX1 <= to_seg(tens);
        HEX2 <= to_seg(hundreds);
        HEX3 <= to_seg_sign(sign_bit);
    end process;

end rtl;


