-- ========================================
-- ACTIVITY 4: activity_4.vhd
-- Binary to Decimal Conversion
-- 10-bit signed binary input -> Decimal display
-- ========================================
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY activity_4 IS
    PORT (
        SW   : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);    -- 10 switches (SW9=sign, SW8:0=magnitude)
        HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);    -- Ones place
        HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);    -- Tens place
        HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);    -- Hundreds place
        HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)     -- Sign display
    );
END activity_4;

ARCHITECTURE Behavioral OF activity_4 IS
    
    -- Function: Convert digit (0-9) to 7-segment display
    FUNCTION digit_to_7seg(digit : INTEGER) RETURN STD_LOGIC_VECTOR IS
        VARIABLE SEG : STD_LOGIC_VECTOR(6 DOWNTO 0);
    BEGIN
        CASE digit IS
            WHEN 0 => SEG := "1000000"; -- 0
            WHEN 1 => SEG := "1111001"; -- 1
            WHEN 2 => SEG := "0100100"; -- 2
            WHEN 3 => SEG := "0110000"; -- 3
            WHEN 4 => SEG := "0011001"; -- 4
            WHEN 5 => SEG := "0010010"; -- 5
            WHEN 6 => SEG := "0000010"; -- 6
            WHEN 7 => SEG := "1111000"; -- 7
            WHEN 8 => SEG := "0000000"; -- 8
            WHEN 9 => SEG := "0010000"; -- 9
            WHEN OTHERS => SEG := "1111111"; -- Blank
        END CASE;
        RETURN SEG;
    END FUNCTION;
    
    -- Function: Convert sign bit to 7-segment display
    FUNCTION sign_to_7seg(sign : STD_LOGIC) RETURN STD_LOGIC_VECTOR IS
        VARIABLE SEG : STD_LOGIC_VECTOR(6 DOWNTO 0);
    BEGIN
        IF sign = '1' THEN
            SEG := "0111111"; -- Negative sign (-)
        ELSE
            SEG := "1111111"; -- Blank (positive)
        END IF;
        RETURN SEG;
    END FUNCTION;
    
BEGIN
    
    -- Main process to handle input conversion
    PROCESS (SW)
        VARIABLE temp_signed : INTEGER RANGE -512 TO 511;
        VARIABLE temp_abs : INTEGER RANGE 0 TO 512;
        VARIABLE temp : INTEGER RANGE 0 TO 512;
        VARIABLE hundreds_var : INTEGER RANGE 0 TO 9;
        VARIABLE tens_var : INTEGER RANGE 0 TO 9;
        VARIABLE ones_var : INTEGER RANGE 0 TO 9;
        VARIABLE sign_var : STD_LOGIC;
    BEGIN
        -- Convert input (signed 9-bit number with SW(9) as sign indicator)
        IF SW(9) = '1' THEN
            temp_signed := TO_INTEGER(UNSIGNED(SW(8 DOWNTO 0))) - 512;
        ELSE
            temp_signed := TO_INTEGER(UNSIGNED(SW(8 DOWNTO 0)));
        END IF;
        
        -- Get the absolute value and sign
        IF temp_signed < 0 THEN
            temp_abs := -temp_signed;
            sign_var := '1';
        ELSE
            temp_abs := temp_signed;
            sign_var := '0';
        END IF;
        
        -- Break into decimal digits
        temp := temp_abs;
        hundreds_var := temp / 100;
        temp := temp MOD 100;
        tens_var := temp / 10;
        ones_var := temp MOD 10;
        
        -- Assign to outputs directly
        HEX3 <= sign_to_7seg(sign_var);
        HEX2 <= digit_to_7seg(hundreds_var);
        HEX1 <= digit_to_7seg(tens_var);
        HEX0 <= digit_to_7seg(ones_var);
        
    END PROCESS;
    
END Behavioral;