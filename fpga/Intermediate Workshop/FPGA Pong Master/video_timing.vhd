-- generates timing signals for a 1280x720 @ 60hz video output
-- also gives you a one-tick 'frame_start' pulse at the top-left pixel

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity video_timing is
	port (
		clk: 				in  STD_LOGIC;								-- pixel clock (74.25 mhz for 720p)
		reset: 			in  STD_LOGIC;								-- resets counters back to zero
		hcount: 			out UNSIGNED(11 downto 0);				-- current horizontal pixel position
		vcount: 			out UNSIGNED(11 downto 0);				-- current vertical line position
		hsync: 			out STD_LOGIC;								-- horizontal sync signal
		vsync: 			out STD_LOGIC;								-- vertical sync signal
		de: 				out STD_LOGIC;								-- data enable (high when inside visible area)
		frame_start: 	out STD_LOGIC								-- 1 clock cycle at start of frame
	);
end video_timing;

architecture procedural of video_timing is
	-- HDMI output parameters
	constant H_ACTIVE	: NATURAL := 1280; 	-- visible horizontal pixels
	constant H_FP		: NATURAL := 110;		-- front porch: idle pixels after active area, before sync pulse
	constant H_SYNC	: NATURAL := 40;		-- horizontal sync pulse width
	constant H_BP		: NATURAL := 220;		-- back porch: idle pixels after sync, before visible area starts
	constant H_TOTAL	: NATURAL := H_ACTIVE + H_FP + H_SYNC + H_BP;-- total pixels per line = active + porches + sync

	-- same idea but vertical (in lines instead of pixels)
	constant V_ACTIVE	: NATURAL := 720;
	constant V_FP		: NATURAL := 5;
	constant V_SYNC	: NATURAL := 5;
	constant V_BP     : NATURAL := 20;
	constant V_TOTAL 	: NATURAL := V_ACTIVE + V_FP + V_SYNC + V_BP;
	
	begin
	
	-- this process generates the scanline position signals
	process(clk) is
		-- internal buffer signals for hcount and vcount since we can't read back "out" mode values
		variable hcount_buf: unsigned(11 downto 0) := x"000";
		variable vcount_buf: unsigned(11 downto 0) := x"000";
	
		variable frame_start_active: STD_LOGIC;
	begin		
		-- only run our process on the rising edge of our hdmi clock
		if (rising_edge(clk)) then
			-- default no frame start, we will check later if it should be active
			frame_start_active := '0';
			
			-- if reset, restart process at top-left of screen
			if reset = '1' then
				hcount_buf := x"000";
				vcount_buf := x"000";
			else				
				-- check if we've reached the end of the line
				if hcount_buf = H_TOTAL - 1 then
					-- if we have reached the end of the line, wrap to the start of the next row
					hcount_buf := x"000"; 
					
					-- check if we've reached the end of the frame
					if vcount_buf = V_TOTAL - 1 then
						-- if we have reached the end of the frame, wrap aroun to the start of the next frame
						vcount_buf := x"000";
						frame_start_active := '1';
					else
						-- if we haven't reached the end of the frame, increment to the next row
						vcount_buf := vcount_buf + 1;
					end if;
				else
					-- if w haven't reached the end of the line, increment forward along it
					hcount_buf := hcount_buf + 1;
				end if;
				
			end if;
		
			-- hsync is high during horizontal sync range
			if (hcount_buf >= H_ACTIVE + H_FP) and
				(hcount_buf <  H_ACTIVE + H_FP + H_SYNC) then
				hsync <= '1';
			else
				hsync <= '0';
			end if;
						
			-- vsync is high uring vertical sync range
			if (vcount_buf >= V_ACTIVE + V_FP) and
				(vcount_buf <  V_ACTIVE + V_FP + V_SYNC) then
				vsync <= '1';
			else
				vsync <= '0';
			end if;
						
			-- data enabled only when scan position is in active display area
			if (hcount_buf < H_ACTIVE) and
				(vcount_buf < V_ACTIVE) then
				de <= '1';
			else
				de <= '0';
			end if;
			
			frame_start <= frame_start_active;
			hcount <= hcount_buf;
			vcount <= vcount_buf;
		
		end if; -- end of sequential section
	end process;
end procedural;