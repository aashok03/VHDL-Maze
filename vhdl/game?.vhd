-- Kostas Version!

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity GAME is
  port(
	  L      : in std_logic;
	  R      : in std_logic;
	  clk    : in std_logic;
	  ball_x_position : out signed (11 downto 0);
	  ball_y_position : out signed (11 downto 0);
      paddle_position : out signed (11 downto 0);
      game_over       : out std_logic

	  --ball_array : out signed(99 downto 0);
  );    
end;

architecture GAME_ARCH of GAME is

  -- 17 bits => can store  (-2*WIDTH -> 2*WIDTH-1)
  -- to avoid signed underflow

  
  constant PIXEL : signed (16 downto 0) := 17d"32";
  constant BRICK : signed (16 downto 0) := 17d"1024";--to_signed(32 * to_integer(PIXEL), 17);
  constant PIXEL_SHIFT : signed (16 downto 0) := 17d"5";       
  
  
--  constant WIDTH  : signed (16 downto 0) := 17d"512" * PIXEL;
--  constant HEIGHT : signed (16 downto 0) := 17d"480" * PIXEL;

  constant MIN_X : signed (16 downto 0) := 17d"2016"; --to_signed(63  * to_integer(PIXEL), 17);
  constant MAX_X : signed (16 downto 0) := 17d"18368";--to_signed(574 * to_integer(PIXEL), 17);
  constant MIN_Y : signed (16 downto 0) := 17d"288";--to_signed(9   * to_integer(PIXEL), 17);
  constant MAX_Y : signed (16 downto 0) := 17d"15168";--to_signed(474 * to_integer(PIXEL), 17);
  constant MAX_SPEED : signed (16 downto 0) := 17d"256";--to_signed(8 * to_integer(PIXEL), 17);
  
  constant PADDLE_WIDTH : signed (16 downto 0)  := 17d"2560";--to_signed(80 * to_integer(PIXEL), 17);
  constant PADDLE_SPEED : signed (16 downto 0)  := MAX_SPEED;
  
  constant BRICK_ROWS : signed (16 downto 0)  := 17d"160"; --to_signed(5  * to_integer(PIXEL), 17);
  constant BRICK_COLS : signed (16 downto 0)  := 17d"512";--to_signed(16 * to_integer(PIXEL), 17);
  constant BRICK_NUM  : signed (16 downto 0)  := 17d"80";--to_signed(to_integer(BRICK_ROWS) * to_integer(BRICK_COLS), 17);

  
  signal paddle  : signed (16 downto 0) := MIN_X;
  signal ball_x  : signed (16 downto 0) := MIN_X;
  signal ball_y  : signed (16 downto 0) := MAX_Y;
  signal ball_vx : signed (16 downto 0) := MAX_SPEED; 
  signal ball_vy : signed (16 downto 0) := -MAX_SPEED;

begin
  process (clk) is
  begin
    if rising_edge(clk) then

      -- PADDLE (changes 'paddle')
      if L = '1' and R = '0' then
        paddle <= MIN_X when (MIN_X >= paddle-PADDLE_SPEED) else paddle-PADDLE_SPEED; -- max
		--max (MIN_X, paddle-PADDLE_SPEED);
      elsif L = '0' and R = '1' then
        paddle <= MAX_X-PADDLE_WIDTH when (MAX_X-PADDLE_WIDTH <= paddle+PADDLE_SPEED) else paddle+PADDLE_SPEED; -- min
		--min (MAX_X-PADDLE_WIDTH, paddle+PADDLE_SPEED);
      else
        paddle <= paddle;
      end if;

      -- BALL MOVE (changes 'ball_x', 'ball_y')
      ball_x <= ball_x + ball_vx;
      ball_y <= ball_y + ball_vy;

      -- BALL COLLISION (changes 'ball_vx', 'ball_vy')
      if (ball_x <= MIN_X or ball_x >= MAX_X) then
        ball_vx <= -ball_vx;
      end if;

      if (ball_y <= MIN_Y or ball_y >= MAX_Y) then
        ball_vy <= -ball_vy;
      end if;

      -- LOST CONDITION
      game_over <= '1' when ball_y >= MAX_Y and
              (ball_x < paddle or ball_x > paddle+PADDLE_WIDTH) else '0';

      -- MAPPING TO OUTPUTS (shifting for pixel)
      ball_x_position <= ball_x (16 downto 5);
      ball_y_position <= ball_y (16 downto 5);
      paddle_position <= paddle (16 downto 5);

    end if;
  end process;
end;
