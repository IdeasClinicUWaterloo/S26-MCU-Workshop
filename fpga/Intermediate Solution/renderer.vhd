-- draws the pong paddles, ball, border, and the scores using a tiny 8x12 font

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity renderer is
	generic (
		H_ACTIVE: NATURAL := 1280;	-- active horizontal area, cols of pixels
		V_ACTIVE: NATURAL := 720	-- active vertical area, rows of pixels
	);
	port (
		hcount:	in UNSIGNED(11 downto 0);	-- current horizontal position on the screen
		vcount:	in UNSIGNED(11 downto 0);	-- current vertical position on the screen
		de: 		in STD_LOGIC;					-- whether we're in the visible area of the screen
		pl_y: 	in INTEGER;						-- the left player's current y pos
		pr_y: 	in INTEGER;						-- the right player's current y pos
		ball_x: 	in INTEGER;						-- the ball's current x position
		ball_y: 	in INTEGER;						-- the ball's current y position
		score_l: in UNSIGNED(3 downto 0);	-- the left player's score
		score_r: in UNSIGNED(3 downto 0);	-- the right player's score
		
		rgb: out STD_LOGIC_VECTOR(23 downto 0)	-- the color of the current pixel
	);
end renderer;

architecture procedural of renderer is
	component numeric_display is
		port (
			num: in UNSIGNED(3 downto 0);					-- number to display
			pos_x: in INTEGER;								-- horizontal pos of top-left corner of score
			pos_y: in INTEGER;								-- vertical pos of top-left corner of score
			hcount, vcount: in UNSIGNED(11 downto 0); -- current pixel position
			lit: out STD_LOGIC								-- whether the current pixel should be lit by the displayed number
		);
	end component;

	constant PADDLE_H: 	NATURAL := 100;	-- width of the paddles, in px
	constant PADDLE_W: 	NATURAL := 12;		-- height of the paddles, in px
	constant BALL_R: 		INTEGER := 10;		-- radius of the ball, in px
	constant PL_X: 		INTEGER := 40;									-- position of the left player on screen
	constant PR_X: 		INTEGER := H_ACTIVE - 40 - PADDLE_W;	-- position of the right player on screen
	
	signal on_scorel: STD_LOGIC;	-- whether the current pixel is on the left player's score
	signal on_scorer: STD_LOGIC;	-- whether the current pixel is on the right player's score
	
	signal on_pl: STD_LOGIC;		-- whether the current pixel is on the left paddle
	signal on_pr: STD_LOGIC;		-- whether the current pixel is on the right paddle
	
	signal on_ball: STD_LOGIC;		-- whether the current pixel is on the ball
begin
	-- component to render left score
	score_l_render: numeric_display
		port map (
			pos_x => H_ACTIVE/2 - 16,
			pos_y => 16,
			hcount => hcount,
			vcount => vcount,
			num => score_l,
			lit => on_scorel
		);
	
	-- component to render right score
	score_r_render: numeric_display
		port map (
			pos_x => H_ACTIVE/2 + 16,
			pos_y => 16,
			hcount => hcount,
			vcount => vcount,
			num => score_r,
			lit => on_scorer
		);

	-- checking if current pixel is in left/right paddle
	on_pl <= '1' when
		(hcount >= PL_X) and (hcount < PL_X + PADDLE_W) and -- in horizontal range
		(vcount >= pl_y) and (vcount < pl_y + PADDLE_H)		 -- in vertical range
		else '0';
	on_pr <= '1' when
		(hcount >= PR_X) and (hcount < PR_X + PADDLE_W) and -- in horizontal range
		(vcount >= pr_y) and (vcount < pr_y + PADDLE_H)		 -- in vertical range
		else '0';

	-- checking if current pixel is in ball
	on_ball <= '1' when
		(hcount >= ball_x - BALL_R) and (hcount <= ball_x + BALL_R) and	-- in horizontal range
		(vcount >= ball_y - BALL_R) and (vcount <= ball_y + BALL_R)			-- in vertical range
		else '0';
	
	-- process runs every time pixel changes
	process(hcount, vcount, de) is
	begin

		if de = '0' then
			-- do not output color when we're outside visible area
			rgb <= x"000000";
		else
			-- otherwise, color based on what game components we're on
			if (on_scorel = '1') or (on_scorer = '1') then
				rgb <= x"FFFFFF";	-- color for player scores
			elsif on_pl = '1' then
				rgb <= x"FFFFFF";	-- color for left paddle
			elsif on_pr = '1' then
				rgb <= x"FFFFFF"; -- color for right paddle
			elsif on_ball = '1' then
				rgb <= x"FFFFFF";	-- color for ball
			else
				rgb <= x"000000";	-- background color
			end if;
		end if;
		
	end process;
end procedural;