-- main top module for hdmi pong on the c5g board with adv7513 transmitter
-- key0/key1 = player 1 up/down, key2/key3 = player 2 up/down
-- reset is moved to the cpu_reset_n pushbutton

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hdmi_top is
	port (
		clock_50_b5b: 	in STD_LOGIC;								-- 50 mhz main board clock
		
		cpu_reset_n: 	in STD_LOGIC;								-- pushbutton reset, active-low
		key: 				in STD_LOGIC_VECTOR(3 downto 0);		-- player control pushbuttons, active low
		sw:				in STD_LOGIC_VECTOR(9 downto 0);		-- toggle switches for game-speed control
		
		-- The following signals are directly connected to the ADV7513 transmitter
		hdmi_tx_d: 		out STD_LOGIC_VECTOR(23 downto 0);	-- rgb pixel data
		hdmi_tx_de: 	out STD_LOGIC;								-- data enable
		hdmi_tx_hs: 	out STD_LOGIC;								-- horizontal sync
		hdmi_tx_vs: 	out STD_LOGIC;								-- vertical sync
		hdmi_tx_clk: 	out STD_LOGIC;								-- pixel clock
		
		-- The following signals are used for I2C communication with the ADV7513 transmitter
		i2c_sda: 		inout STD_LOGIC;							-- i2c data
		i2c_scl: 		out STD_LOGIC								-- i2c clock
		
	);
end hdmi_top;

architecture structural of hdmi_top is
	-- 74.25MHz PLL clock component declaration
	component pll_74mhz is
		port (
			refclk   : in  STD_LOGIC; --  refclk.clk
			rst      : in  STD_LOGIC; --  reset.reset
			outclk_0 : out STD_LOGIC; --  outclk0.clk
			locked   : out STD_LOGIC  --  locked.export
		);
	end component;
	
	-- active-high reset signal, to be driven by physical reset button
	signal reset: STD_LOGIC;
	
	-- Phase-Locked Loop (PLL) signals
	signal clk_pixel: STD_LOGIC;
	signal pll_locked: STD_LOGIC;
	
	-- Scan position data
	signal hcount, vcount: UNSIGNED(11 downto 0);
	signal hsync, vsync, de, frame_start: STD_LOGIC;
	signal rgb: STD_LOGIC_VECTOR(23 downto 0);
	
	-- game state
	signal pl_y: INTEGER;
	signal pr_y: INTEGER;
	signal ball_x: INTEGER;
	signal ball_y: INTEGER;
	signal score_l: INTEGER;
	signal score_r: INTEGER;
	signal game_clock: STD_LOGIC;
	
	-- clock divider for debugging
	signal div_ctr: NATURAL := 0;
	
begin
	reset <= not cpu_reset_n;	-- converting reset signal from active-low to active-high
	
	-- 74.25MHZ PLL clock component instantiation
	pll_clock: pll_74mhz
		port map (
			refclk 	=> clock_50_b5b,
			rst 		=> reset,
			outclk_0 => clk_pixel,
			locked 	=> pll_locked
		);
	
	-- intantiating video timing
	video_timing: entity work.video_timing
		port map (
			clk			=> clk_pixel,
			reset			=> not pll_locked,
			hcount		=> hcount,
			vcount		=> vcount,
			hsync			=> hsync,
			vsync			=> vsync,
			de				=> de,
			frame_start => frame_start
		);
	
	
	-- instantiating game logic, responsible for tracking the game state
	game_logic: entity work.game_logic
		port map (
			clk => clk_pixel,
			game_clk => game_clock,
			reset => not pll_locked or reset,
			pl_up => not key(0),
			pl_dn => not key(1),
			pr_up => not key(2),
			pr_dn => not key(3),
			pl_y => pl_y,
			pr_y => pr_y,
			ball_x => ball_x,
			ball_y => ball_y,
			score_l => score_l,
			score_r => score_r
		);
	
	-- instantiating the renderer, responsible for assigning a color to each pixel
	renderer: entity work.renderer
		port map (
			hcount => hcount,
			vcount => vcount,
			de => de,
			rgb => rgb,			
			pl_y => pl_y,
			pr_y => pr_y,
			ball_x => ball_x,
			ball_y => ball_y,
			score_l => to_unsigned(score_l, 4),
			score_r => to_unsigned(score_r, 4)
		);
	
	-- instantiating the i2c configurator to configure our HDMI transmitter for proper video transmission
	i2c_configurator: work.i2c_config
		port map (
			clk => clk_pixel,
			reset => (not pll_locked) or reset,
			scl => i2c_scl,
			sda => i2c_sda
		);
	
	-- wiring HDMI tx to generated video signals
	hdmi_tx_de <= de;
	hdmi_tx_hs <= hsync;
	hdmi_tx_vs <= vsync;
	hdmi_tx_clk <= clk_pixel;
	hdmi_tx_d <= rgb;
	
	-- game clock divider for debug purposes
	game_clock <= frame_start when (div_ctr = 0) else '0';
	process(frame_start) is
	begin
		if rising_edge(frame_start) then
			if div_ctr >= to_integer(unsigned(sw)) then
				div_ctr <= 0;
			else
				div_ctr <= div_ctr + 1;
			end if;
		end if;
	end process;
	
	
end structural;