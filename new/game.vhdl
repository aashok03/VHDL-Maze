-- Paddle mover, basically

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity GAME is
  port(
      L      : in std_logic;
      R      : in std_logic;
      tick    : in std_logic;
      ball_x_position : out unsigned (9 downto 0);
      ball_y_position : out unsigned (9 downto 0);
      paddle_pos      : out unsigned (9 downto 0);
      game_over       : out std_logic
   );
end;

architecture synth of GAME is
	signal paddle : unsigned (14 downto 0) := 10d"150";

begin

  process (tick) is
  begin
    if rising_edge(tick) then

      -- PADDLE (changes 'paddle')
      paddle <= (paddle + 1) when (L = '1' and R = '0') else
                (paddle - 1) when (R = '0' and R = '1') else
                paddle;
      
      -- MAPPING TO OUTPUTS (shifting for pixel)
      ball_x_position <= 10d"150";
      ball_y_position <= 10d"150";
      paddle_position <= paddle (14 downto 4);
    end if;
  end process;
end;
