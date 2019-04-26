-- Paddle mover, basically

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity GAME is
  port(
	  --L      : in std_logic;
	  --R      : in std_logic;
	  clk    : in std_logic;
	  --paddle_in : in unsigned (9 downto 0);
	  --ball_x_position : out unsigned (9 downto 0);
	  --ball_y_position : out unsigned (9 downto 0);
      paddle_out : out unsigned (9 downto 0)
      --game_over       : out std_logic

	  --ball_array : out signed(99 downto 0);
  );    
end;

architecture GAME_ARCH of GAME is
	signal paddle : unsigned (9 downto 0) := 10d"8";
	signal temp : std_logic := '1';
begin

  process (clk) is
  begin
    if rising_edge(clk) then

      -- PADDLE (changes 'paddle')
      --if L = '1' and R = '0' then
		--paddle <= paddle - 1 when paddle >= 63;
      --elsif L = '0' and R = '1' then
		--paddle <= paddle + 1 when paddle <= 495; -- 575-80 (rightmost edge of screen minus width of paddle)
	  --end if;
	  
	paddle_out <= paddle;
	paddle <= paddle + 0;

      -- MAPPING TO OUTPUTS (shifting for pixel)
      --ball_x_position <= 11d"150";
      --ball_y_position <= 11d"150";
      --paddle_position <= paddle (15 downto 5);

    end if;
  end process;
end;
