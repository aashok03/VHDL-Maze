--Pattern Module. Currently working for Ball and Paddle

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern is
Port(
    valid : in std_logic;
    count_horz : in unsigned  (9 downto 0);
    count_vert : in unsigned  (9 downto 0);
	paddle_x : in unsigned (9 downto 0);
	ball_x : in unsigned (9 downto 0);
	ball_y : in unsigned (9 downto 0);
    RGB_pattern : out std_logic_vector (5 downto 0)
    );
 end pattern;
  
architecture synth of pattern is

signal RGB : std_logic_vector (5 downto 0);

begin

RGB <= "111111" when (count_horz < (paddle_x + 40) and count_horz > (paddle_x - 40) and count_vert < 455 and count_vert > 445) --The paddle
           or (count_horz < 63 or count_horz > 576 or count_vert < 9) --The border
					 or ( (count_horz = ball_x + 4 or count_horz = ball_x - 4) and (count_vert < ball_y + 2 and count_vert > ball_y - 2) ) --Ball top/bottom row 1
					 or ( (count_horz = ball_x + 3 or count_horz = ball_x - 3) and (count_vert < ball_y + 3 and count_vert > ball_y - 3) ) --Ball top/bottom row 2
					 or ( (count_horz = ball_x + 2 or count_horz = ball_x - 2) and (count_vert < ball_y + 4 and count_vert > ball_y - 4) ) --Ball top/bottom row 3
					 or ( (count_horz < ball_x + 2 and count_horz > ball_x - 2) and (count_vert < ball_y + 5 and count_vert > ball_y - 5) ) --Ball center (3 rows)
                     else "000000";

RGB_pattern <= RGB;
end synth;
