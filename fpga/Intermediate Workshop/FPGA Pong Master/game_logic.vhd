-- keeps track of game state, including player movement, ball movement, scores, and serving
-- all positions are in screen-space coordinates, where 1 unit of movement corresponds to 1 pixel on the screen
-- the orientation of the axes are as shown here:
-- +-------> +x
-- |
-- |
-- |
-- "
-- +y

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity game_logic is
	generic (
		H_ACTIVE: NATURAL := 1280;	-- active horizontal area, cols of pixels
		V_ACTIVE: NATURAL := 720	-- active vertical area, rows of pixels
	);
	port (
		clk: 				in STD_LOGIC;	-- pixel clock to ensure process is updated in synchrony with pixel timing
		game_clk: 		in STD_LOGIC;	-- game clock to time game updates to each frame
		reset: 			in STD_LOGIC;	-- game reset signal
		pl_up, pl_dn: 	in STD_LOGIC;	-- whether left paddle should move up/down
		pr_up, pr_dn: 	in STD_LOGIC;	-- whether right paddle should move up/down
		pl_y: 			out INTEGER;	-- left player y position
		pr_y: 			out INTEGER;	-- right player y position
		ball_x: 			out INTEGER;	-- ball x position
		ball_y: 			out INTEGER;	-- ball y position
		score_l: 		out NATURAL;	-- score of left player
		score_r: 		out NATURAL		-- score of right player
	);
end game_logic;


architecture procedural of game_logic is
	constant PADDLE_H: 	NATURAL := 100;	-- width of the paddles, in px
	constant PADDLE_W: 	NATURAL := 12;		-- height of the paddles, in px
	constant BALL_R: 		INTEGER := 10;		-- radius of the ball, in px
	constant PL_X: 		INTEGER := 40;									-- position of the left player on screen
	constant PR_X: 		INTEGER := H_ACTIVE - 40 - PADDLE_W;	-- position of the right player on screen
	
	constant PADDLE_V: INTEGER := 6; -- move speed of the paddles in px/frame
	constant SERVE_DUR: NATURAL := 40; -- duration of the serving phase, in frames
	constant PADDLE_RESET_Y: INTEGER := V_ACTIVE-PADDLE_H/2; -- initial position of paddles after reset
	
	type GAME_STATE is (ST_PLAY, ST_SERVE); -- simple state machine for game status
	
	signal state: GAME_STATE := ST_SERVE; -- current game state
	
	-- function to maintain a value between two bounds by limiting the extreme values
	--   out
	--    |    
	-- max|     --
	--    |    /
	--    |   /
	--    |  /
	-- min|--
	--    |
	--    +--------
	--      input
	function clamp (
		x: INTEGER;
		min: INTEGER;
		max: INTEGER
	) return INTEGER is
	begin
		if x >= max then
			-- when above upper limit, return upper limit
			return max;
		elsif x <= min then
			-- when below lower limit, return lower limit
			return min;
		else
			-- if within bounds, return original value
			return x;
		end if;
	end function;
	
	begin
	
	process(clk)
		variable ply_n, pry_n: INTEGER;		-- internal values for paddle positions (required for readback)
		variable bx_n, by_n: INTEGER;			-- internal values for ball position (required for readback)
		variable vx, vy: INTEGER;				-- internal values for ball velocity
		variable sn_l, sn_r: NATURAL;			-- internal values for player scores
		variable serve_countdown: NATURAL;	-- number of frames remaining in serve phase
		
	begin
		if rising_edge(clk) then
			if reset = '1' then
				-- reset our internal values when reset pressed
				ply_n := PADDLE_RESET_Y;
				pry_n := PADDLE_RESET_Y;
				bx_n := H_ACTIVE/2;
				by_n := V_ACTIVE/2;
				vx := 4;
				vy := 3;
				
				sn_l := 0;
				sn_r := 0;
				
				state <= ST_SERVE;
				serve_countdown := SERVE_DUR;
				
			elsif game_clk = '1' then
				-- paddle movement with saturation to prevent out-of-bounds movement
				if pl_up = '1' then
					ply_n := ply_n - PADDLE_V;
				elsif pl_dn = '1' then
					ply_n := ply_n + PADDLE_V;
				end if;
				ply_n := clamp(ply_n, 0, V_ACTIVE - PADDLE_H); -- clamps paddle position within screen bounds
				
				if pr_up = '1' then
					pry_n := pry_n - PADDLE_V;
				elsif pr_dn = '1' then
					pry_n := pry_n + PADDLE_V;
				end if;
				pry_n := clamp(pry_n, 0, V_ACTIVE - PADDLE_H); -- clamps paddle position within screen bounds
				
				-- ball motion & serving logic
				case state is
					when ST_PLAY => 
						-- update ball position
						bx_n := bx_n + vx;
						by_n := by_n + vy;
						
						-- ball-wall collision handling
						if by_n < BALL_R then
							by_n := (BALL_R+BALL_R)-by_n;
							vy := -vy;
						elsif by_n >= V_ACTIVE-BALL_R then
							by_n := (V_ACTIVE+V_ACTIVE-BALL_R-BALL_R)-by_n;
							vy := -vy;
						end if;
						
						-- ball-paddle collision handling
						if (vx < 0) and
							(bx_n+BALL_R > pl_X) and (bx_n-BALL_R <= pl_X+PADDLE_W) and
							(by_n+BALL_R >= ply_n) and (by_n-BALL_R <= ply_n+PADDLE_H)
							then
							vx := -vx;
							bx_n := pl_X+PADDLE_W+BALL_R;
						elsif (vx > 0) and
							(bx_n+BALL_R >= pr_X) and (bx_n-BALL_R < pr_X+PADDLE_W) and
							(by_n+BALL_R >= pry_n) and (by_n-BALL_R <= pry_n+PADDLE_H)
							then
							vx := -vx;
							bx_n := pr_X-BALL_R;
						end if;
						
						-- goal handling
						if bx_n < 0 then
							sn_r := sn_r + 1;
							state <= ST_SERVE;
						elsif bx_n > H_ACTIVE then
							sn_l := sn_l + 1;
							state <= ST_SERVE;
						end if;
						
						-- game over condition
						if (sn_l > 9) or (sn_r > 9) then
							sn_l := 0;
							sn_r := 0;
						end if;
						
					when ST_SERVE =>
						-- maitain ball in center of screen for serving
						bx_n := H_ACTIVE / 2;
						by_n := V_ACTIVE / 2;
						serve_countdown := serve_countdown - 1; -- remove on frame from the serve timer duration
						
						-- check if the serve is done yet
						if serve_countdown = 0 then
							-- reset serve timer duration and begin play
							serve_countdown := SERVE_DUR;
							vx := -vx;
							vy := -vy;
							state <= ST_PLAY;
						end if;
				end case;
			end if;
			
			-- synchronzing external signals with internal values
			pl_y <= ply_n;
			pr_y <= pry_n;
			ball_x <= bx_n;
			ball_y <= by_n;
			score_l <= sn_l;
			score_r <= sn_r;
		end if;
	end process;
	
end procedural;