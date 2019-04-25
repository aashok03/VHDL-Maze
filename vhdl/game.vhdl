library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity GAME is
  port(
	  L      : in std_logic;
	  R      : in std_logic;
	  clk    : in std_logic;
	  ball_x_position : out integer (16 downto 0);
	  ball_y_position : out integer (16 downto 0);
          paddle_position : out integer (16 downto 0);
          game_over       : out std_logic;

	  --ball_array : out unsigned(99 downto 0);
  );    
end;

architecture GAME_ARCH of GAME is

  -- 17 bits => can store  (-2*WIDTH -> 2*WIDTH-1)
  -- to avoid unsigned underflow

  
  -- Every constant must be power of 2
  constant UNIT   : integer (16 downto 0)  := 17d"1024";
  
  constant WIDTH  : integer (16 downto 0)  := 17d"32" * UNIT;
  constant HEIGHT : integer (16 downto 0)  := 17d"16" * UNIT;
  
  constant PADDLE_WIDTH : integer (16 downto 0)  := 17d"4" * UNIT;
  constant PADDLE_SPEED : integer (16 downto 0)  := 1; -- 
  
  constant BRICK_ROWS : integer (16 downto 0)  := 8;
  constant BRICK_COLS : integer (16 downto 0)  := 32;
  constant BRICK_SIZE : integer (16 downto 0)  := WIDTH/BRICK_COLS;

  signal L : std_logic := '0';
  signal R : std_logic := '1';
  
  signal paddle  : integer (16 downto 0) := 0;
  signal ball_x  : integer (16 downto 0) := 0;
  signal ball_y  : integer (16 downto 0) := HEIGHT; -- y=0 is top
  signal ball_vx : integer (16 downto 0) :=  UNIT; -- MUST LOWER SIGNIFICANTLY
  signal ball_vy : integer (16 downto 0) := -UNIT; -- MUST LOWER SIGNIFICANTLY

begin
  process (clk) is
    if rising_edge(clk) then

      -- PADDLE (changes 'paddle')
      if L = '1' and R = '0' then
        paddle <= max (17d"0", paddle-PADDLE_SPEED);
      elsif L = '0' and R = '1' then
        paddle <= min (WIDTH-PADDLE_WIDTH-1, paddle+PADDLE_SPEED);
      else
        paddle <= paddle;
      end if;

      -- BALL MOVE (changes 'ball_x', 'ball_y')
      ball_x <= ball_x + ball_vx;
      ball_y <= ball_y + ball_vy;

      -- BALL COLLISION (changes 'ball_vx', 'ball_vy')
      if (ball_x <= 17d"0" or ball_x >= WIDTH) then
        ball_vx <= -ball_vx;
      end if;

      if (ball_y <= "0" or ball_y >= HEIGHT) then
        ball_vy <= -ball_vy;
      end if;

      -- LOST CONDITION
      game_over <= '1' when ball_y >= HEIGHT and
              (ball_x < paddle or ball_x > paddle+PADDLE_WIDTH) else '0';

      -- MAPPING TO OUTPUTS
      ball_x_position <= ball_x;
      ball_y_position <= ball_y;
      paddle_position <= paddle;

    end if;
  end process;
end;
