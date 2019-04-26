library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity GAME is
  port(
	  L      : in std_logic;
	  R      : in std_logic;
	  clk    : in std_logic;
	  ball_x_position : out unsigned (10 downto 0);
	  ball_y_position : out unsigned (10 downto 0);
          paddle_position : out unsigned (10 downto 0);
          game_over       : out std_logic;

	  --ball_array : out unsigned(99 downto 0);
  );    
end;

architecture GAME_ARCH of GAME is

  -- 17 bits => can store  (-2*WIDTH -> 2*WIDTH-1)
  -- to avoid unsigned underflow

  
  constant PIXEL : unsigned (16 downto 0) := 17d"32";
  constant BRICK : unsigned (16 downto 0) := 16d"32" * PIXEL;
  constant PIXEL_SHIFT : unsigned (16 downto 0) := 17d"5";       
  
  
--  constant WIDTH  : unsigned (16 downto 0) := 17d"512" * PIXEL;
--  constant HEIGHT : unsigned (16 downto 0) := 17d"480" * PIXEL;

  constant MIN_X : unsigned (16 downto 0) := 17d"63"  * PIXEL;
  constant MAX_X : unsigned (16 downto 0) := 17d"575" * PIXEL;
  constant MIN_Y : unsigned (16 downto 0) := 17d"9"   * PIXEL;
  constant MAX_Y : unsigned (16 downto 0) := 17d"480" * PIXEL;
  constant MAX_SPEED : unsigned (16 downto 0) := 17d"8" * PIXEL; -- (< 9)!
  
  constant PADDLE_WIDTH : unsigned (16 downto 0)  := 17d"80" * PIXEL;
  constant PADDLE_SPEED : unsigned (16 downto 0)  := MAX_SPEED;
  
  constant BRICK_ROWS : unsigned (16 downto 0)  := 17d"5";
  constant BRICK_COLS : unsigned (16 downto 0)  := 16d"16";
  constant BRICK_SIZE : unsigned (16 downto 0)  := BRICK_ROWS * BRICK_COLS;

  
  signal paddle  : unsigned (16 downto 0) := MIN_X;
  signal ball_x  : unsigned (16 downto 0) := MIN_X;
  signal ball_y  : unsigned (16 downto 0) := MAX_Y;
  signal ball_vx : unsigned (16 downto 0) := MAX_SPEED; 
  signal ball_vy : unsigned (16 downto 0) := -MAX_SPEED;

begin
  process (clk) is
    if rising_edge(clk) then

      -- PADDLE (changes 'paddle')
      if L = '1' and R = '0' then
        paddle <= max (MIN_X, paddle-PADDLE_SPEED);
      elsif L = '0' and R = '1' then
        paddle <= min (MAX_X-PADDLE_WIDTH, paddle+PADDLE_SPEED);
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
