-- bit-bashed i2c state machine to configure on-board HDMI transmitter
-- transmits an array of 3-byte i2c transmissions in order to power on and confgure the ADV7513s
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2c_config is 
	port (
		clk:		in STD_LOGIC;		-- 74.25 mhz pixel clock
		reset: 	in STD_LOGIC;		-- active-high reset
		scl:		out STD_LOGIC;		-- i2c clock line (push-pull, but board has pull-ups)
		sda:		inout STD_LOGIC	-- i2c data line (open-drain style)
	);
end i2c_config;

architecture procedural of i2c_config is
	constant CLK_HZ: UNSIGNED := to_unsigned(74_250_000, 32); 	-- clock speed coming in
	constant I2C_HZ: UNSIGNED := to_unsigned(100_000, 32);		-- target i2c speed

	-- division constant for clock divider to generate i2c clock
	-- scl toggles every DIV ticks, so full period = 2*DIV ticks
	constant DIV: UNSIGNED := (CLK_HZ/(I2C_HZ*2));
	
	-- adv7513's i2c write address: 7-bit 0x39 => 8-bit 0x72 for write
	constant I2C_ADDR_WR: STD_LOGIC_VECTOR(7 downto 0) := x"72";
	
	-- init table; data to send to hdmi transmitter on startup
	constant REG_CT: NATURAL := 3;
	type REG_ARR is array (REG_CT-1 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
	signal reg_addr: REG_ARR := (
		x"41", x"15", x"AF"
	);
	signal reg_data: REG_ARR := (
		x"10", x"10", x"06"
	);
	
	signal div_cnt: UNSIGNED(15 downto 0);
	signal tick: STD_LOGIC; -- goes high for 1 main clk cycle every half i2c cycle
	
	-- i2c state machine
	type I2C_STATE is (
		ST_IDLE,
		ST_START1,
		ST_START2,
		ST_LOAD_BYTE,
		ST_BIT_LOW,
		ST_BIT_HIGH,
		ST_BIT_DONE,
		ST_ACK_LOW,
		ST_ACK_HIGH,
		ST_ACK_DONE,
		ST_STOP1,
		ST_STOP2,
		ST_NEXT_PAIR,
		ST_DONE
	);
	
	signal state: I2C_STATE;								-- current state machine state
	signal tx_byte: STD_LOGIC_VECTOR(7 downto 0);	-- current byte being shifted out
	signal bit_cnt: UNSIGNED(3 downto 0);				-- counts from 7 down to 0 to keep track of current bit
	signal byte_idx: UNSIGNED(1 downto 0);				-- which byte in the write (0=addr, 1=reg, 2=data)
	signal pair_idx: UNSIGNED(7 downto 0);				-- which reg/data pair we're at in init table
	
	begin
		
		
		-- clock divider process
		process(clk) is
		begin
			if rising_edge(clk) then
				
				if reset = '1' then
					-- reset i2c clock when reset pressed
					div_cnt <= x"0000";
					tick <= '0';
				else
					
					if div_cnt = DIV-1 then
						-- if divider counter reached limit, reset it and emit pulse
						div_cnt <= x"0000";
						tick <= '1';
					else
						-- otherwise, increment counter and clear pulse
						div_cnt <= div_cnt + 1;
						tick <= '0';
					end if;
					
				end if;
			end if;
		end process;
		
		-- main state machine
		process(clk)
		begin
			if rising_edge(clk) then
			
				if reset = '1' then
					-- reset state machine when reset is pressed
					state 	<= ST_IDLE;
					scl 		<= '1';
					sda 		<= 'Z';
					bit_cnt 	<= x"7";
					byte_idx <= "00";
					pair_idx <= x"00";
					tx_byte	<= x"00";
					
				elsif tick = '1' then
					-- if clock divider gives pulse, perform state machine cycle to update i2c state machine
					case state is
						
						-- i2c idle state, default line state between packets
						when ST_IDLE =>
							scl <= '1';
							sda <= 'Z';
							bit_cnt <= x"7";	-- reset bit count in prep for next byte
							byte_idx <= "00";	-- reset byte idx in prep for next packet
							state <= ST_START1;
						
						-- first half of i2c start-of-transmission signal
						when ST_START1 =>
							sda <= '0';
							state <= ST_START2;
						
						-- second half of i2c start-of-transmission signal
						when ST_START2 =>
							scl <= '0';
							state <= ST_LOAD_BYTE;
						
						-- select the next byte to transmit
						when ST_LOAD_BYTE =>
							case byte_idx is
								when "00" =>
									tx_byte <= std_logic_vector(I2C_ADDR_WR);
								when "01" =>
								tx_byte <= reg_addr(to_integer(pair_idx));
								when others =>
									tx_byte <= reg_data(to_integer(pair_idx));
							end case;
							state <= ST_BIT_LOW;
					
						-- scl low, controller writes next data bit
						when ST_BIT_LOW =>
							if tx_byte(to_integer(bit_cnt)) = '0' then
								sda <= '0';
							else
								sda <= 'Z';
							end if;
							state <= ST_BIT_HIGH;
						
						-- scl high, controller maintains written bit
						when ST_BIT_HIGH =>
							scl <= '1';
							state <= ST_BIT_DONE;
							
						-- bit written to bus, selecting next bit to write or moving to ack phase if byte complete
						when ST_BIT_DONE =>
							scl <= '0';
							if (bit_cnt /= x"0") then
								bit_cnt <= bit_cnt - 1;
								state <= ST_BIT_LOW;
							else
								sda <= 'Z';
								state <= ST_ACK_LOW;
							end if;
							
						-- first acknowledgement phase, we assume an ack occurs here for simplicity
						when ST_ACK_LOW =>
							scl <= '1';
							state <= ST_ACK_HIGH;
							
						-- second acknowledgement phase, we assume an ack occurs here for simplicity
						when ST_ACK_HIGH =>
							state <= ST_ACK_DONE;
						
						-- ackowledgement phase done, moving to next byte if we need to, otherwise finishing packet
						when ST_ACK_DONE =>
							scl <= '0';
							if byte_idx /= 2 then
								byte_idx <= byte_idx + 1;
								bit_cnt <= x"7";
								state <= ST_LOAD_BYTE;
							else
								state <= ST_STOP1;
							end if;
							
						-- first half of end-of-transmission signal
						when ST_STOP1 =>
							sda <= '0';
							scl <= '1';
							state <= ST_STOP2;
						
						-- second half of end-of-transmission signal
						when ST_STOP2 =>
							sda <= 'Z';
							state <= ST_NEXT_PAIR;
							
						-- moving to the next i2c command to transmit, if present, otherwise moving to done config state
						when ST_NEXT_PAIR =>
							if pair_idx < REG_CT-1 then
								pair_idx <= pair_idx + 1;
								bit_cnt <= x"7";
								byte_idx <= "00";
								state <= ST_START1;
							else
								state <= ST_DONE;
							end if;
							
						-- configuration complete, keep lines in proper idle state
						when ST_DONE =>
							scl <= '1';
							sda <= 'Z';
							
					end case;
					
				end if;
			end if;
		end process;
	
	
end procedural;
