library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity numeric_display is
	port (
		num: 					in UNSIGNED(3 downto 0);	-- number to display
		pos_x, pos_y: 		in INTEGER;						-- top-left corner of text display
		hcount, vcount: 	in UNSIGNED(11 downto 0); 	-- current position
		lit: 					out STD_LOGIC					-- whether the current pixel should be lit by the displayed number
	);
end numeric_display;

architecture behavioural of numeric_display is
	type CHAR_BITMAP is array(0 to 11) of STD_LOGIC_VECTOR(0 to 7); -- 8x12 character bitmap type
	
	constant char_0: CHAR_BITMAP := (
		"00000000",
		"01111100",
		"11000110",
		"11001110",
		"11011110",
		"11110110",
		"11100110",
		"11000110",
		"11000110",
		"01111100",
		"00000000",
		"00000000"
	);
	
	constant char_1: CHAR_BITMAP := (
		"00000000",
		"00011000",
		"01111000",
		"00011000",
		"00011000",
		"00011000",
		"00011000",
		"00011000",
		"00011000",
		"01111110",
		"00000000",
		"00000000"
	);
	
	constant char_2: CHAR_BITMAP := (
		"00000000",
		"01111100",
		"11000110",
		"11000110",
		"00001100",
		"00011000",
		"00110000",
		"01100000",
		"11000110",
		"11111110",
		"00000000",
		"00000000"
	);
	
	constant char_3: CHAR_BITMAP := (
		"00000000",
		"01111100",
		"11000110",
		"00000110",
		"00000110",
		"00111100",
		"00000110",
		"00000110",
		"11000110",
		"01111100",
		"00000000",
		"00000000"
	);
	
	constant char_4: CHAR_BITMAP := (
		"00000000",
		"00001100",
		"00011100",
		"00111100",
		"01101100",
		"11001100",
		"11111110",
		"00001100",
		"00001100",
		"00001100",
		"00000000",
		"00000000"
	);
	
	constant char_5: CHAR_BITMAP := (
		"00000000",
		"11111110",
		"11000000",
		"11000000",
		"11000000",
		"11111100",
		"00000110",
		"00000110",
		"11000110",
		"01111100",
		"00000000",
		"00000000"
	);
	
	constant char_6: CHAR_BITMAP := (
		"00000000",
		"01111100",
		"11000110",
		"11000000",
		"11000000",
		"11111100",
		"11000110",
		"11000110",
		"11000110",
		"01111100",
		"00000000",
		"00000000"
	);
	
	constant char_7: CHAR_BITMAP := (
		"00000000",
		"11111110",
		"11000110",
		"00001100",
		"00011000",
		"00110000",
		"00110000",
		"00110000",
		"00110000",
		"00110000",
		"00000000",
		"00000000"
	);
	
	constant char_8: CHAR_BITMAP := (
		"00000000",
		"01111100",
		"11000110",
		"11000110",
		"11000110",
		"01111100",
		"11000110",
		"11000110",
		"11000110",
		"01111100",
		"00000000",
		"00000000"
	);
	
	constant char_9: CHAR_BITMAP := (
		"00000000",
		"01111100",
		"11000110",
		"11000110",
		"11000110",
		"01111110",
		"00000110",
		"00000110",
		"11000110",
		"01111100",
		"00000000",
		"00000000"
	);
	
	constant char_a: CHAR_BITMAP := (
		"00000000",
		"00111000",
		"01101100",
		"11000110",
		"11000110",
		"11000110",
		"11111110",
		"11000110",
		"11000110",
		"11000110",
		"00000000",
		"00000000"
	);
	
	constant char_b: CHAR_BITMAP := (
		"00000000",
		"11111100",
		"01100110",
		"01100110",
		"01100110",
		"01111100",
		"01100110",
		"01100110",
		"01100110",
		"11111100",
		"00000000",
		"00000000"
	);
	
	constant char_c: CHAR_BITMAP := (
		"00000000",
		"00111100",
		"01100110",
		"11000000",
		"11000000",
		"11000000",
		"11000000",
		"11000000",
		"01100110",
		"00111100",
		"00000000",
		"00000000"
	);
	
	constant char_d: CHAR_BITMAP := (
		"00000000",
		"11111000",
		"01101100",
		"01100110",
		"01100110",
		"01100110",
		"01100110",
		"01100110",
		"01101100",
		"11111000",
		"00000000",
		"00000000"
	);
	
	constant char_e: CHAR_BITMAP := (
		"00000000",
		"11111110",
		"01100110",
		"01100000",
		"01100000",
		"01111100",
		"01100000",
		"01100000",
		"01100110",
		"11111110",
		"00000000",
		"00000000"
	);
	
	constant char_f: CHAR_BITMAP := (
		"00000000",
		"11111110",
		"01100110",
		"01100000",
		"01100000",
		"01111100",
		"01100000",
		"01100000",
		"01100000",
		"11110000",
		"00000000",
		"00000000"
	);
	
	signal hcount_int: INTEGER;
	signal vcount_int: INTEGER;
	
begin
	-- converting signals to proper type
	hcount_int <= to_integer(hcount);
	vcount_int <= to_integer(vcount);

	-- lighting pixel if we're inside bounding box, and the pixel is active in the respective bitmap position
	lit <= '0' when (hcount < pos_x) or (hcount >= pos_x+8) or (vcount < pos_y) or (vcount >= pos_y+12) else
		char_0(vcount_int - pos_y)(hcount_int - pos_x) when num = "0000" else
		char_1(vcount_int - pos_y)(hcount_int - pos_x) when num = "0001" else
		char_2(vcount_int - pos_y)(hcount_int - pos_x) when num = "0010" else
		char_3(vcount_int - pos_y)(hcount_int - pos_x) when num = "0011" else
		char_4(vcount_int - pos_y)(hcount_int - pos_x) when num = "0100" else
		char_5(vcount_int - pos_y)(hcount_int - pos_x) when num = "0101" else
		char_6(vcount_int - pos_y)(hcount_int - pos_x) when num = "0110" else
		char_7(vcount_int - pos_y)(hcount_int - pos_x) when num = "0111" else
		char_8(vcount_int - pos_y)(hcount_int - pos_x) when num = "1000" else
		char_9(vcount_int - pos_y)(hcount_int - pos_x) when num = "1001" else
		char_a(vcount_int - pos_y)(hcount_int - pos_x) when num = "1010" else
		char_b(vcount_int - pos_y)(hcount_int - pos_x) when num = "1011" else
		char_c(vcount_int - pos_y)(hcount_int - pos_x) when num = "1100" else
		char_d(vcount_int - pos_y)(hcount_int - pos_x) when num = "1101" else
		char_e(vcount_int - pos_y)(hcount_int - pos_x) when num = "1110" else
		char_f(vcount_int - pos_y)(hcount_int - pos_x) when num = "1111" else
		'0';
	
end behavioural;