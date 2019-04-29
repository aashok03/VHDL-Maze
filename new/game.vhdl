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
      paddle_position : out unsigned (9 downto 0)
   );
end;

architecture synth of GAME is
	signal paddle     : unsigned (14 downto 0);
	signal ball_x_pos : signed (15 downto 0);
	signal ball_y_pos : signed (15 downto 0);
	
	signal little_count  : unsigned (9 downto 0) := 10d"0";
	signal big_count     : unsigned (7 downto 0) := 8d"0";
	signal once          : std_logic := '0';
	
	signal ball_vx : signed (15 downto 0) := 16d"15";
	signal ball_vy : signed (15 downto 0) := 16d"25";
begin

  paddle_position <= paddle     (14 downto 5);
  ball_x_position <= unsigned(ball_x_pos(14 downto 5));
  ball_y_position <= unsigned(ball_y_pos(14 downto 5));
  
  process (tick) is
  begin
    if rising_edge(tick) then
	  little_count <= little_count + 1;
	  
	  -- PADDLE MOVES
      if little_count = 0 then
	      big_count <= big_count + 1;
		  paddle <= (paddle + 1) when (L = '1' and R = '0') and paddle < 15776 else
					(paddle - 1) when (L = '0' and R = '1') and paddle > 2016  else
					paddle;
		  
		  -- BALL MOVES
		  if big_count = 0 then
		    
			
			if once = '0' then -- This happens once
			    once <= '1';
			    ball_x_pos <= 16d"9000";
				ball_y_pos <= 16d"4800";
				paddle     <= 15d"4800";
				ball_vx    <= 16d"15";
				ball_vy    <= 16d"25";
			else
			    ball_x_pos <= ball_x_pos - ball_vx;
			    ball_y_pos <= ball_y_pos + ball_vy;
			end if;
			

			
	      if 0 > ball_x_pos - 2016 then --63px
			ball_vx <= (-ball_vx) when ball_vx < 0 else ball_vx;
		  elsif ball_x_pos > 18368 then --574px
			ball_vx <= (-ball_vx) when ball_vx > 0 else ball_vx;
		  end if;
					
		  if 0 > ball_y_pos - 288 then --9px
			ball_vy <= (-ball_vy) when ball_vy < 0 else ball_vy;
		  elsif ball_y_pos > 14592 then --456px
			ball_vy <= (-ball_vy) when ball_vy > 0 else ball_vy;
		  end if;
			
			
			
			--if (ball_x_pos < 23d"2016") then --or (ball_x_pos > 23d"18368") then
			--if (ball_x_pos > 23d"18368") then
				--ball_vx <= 0-ball_vx;
			--end if;
			
			--if (ball_y_pos < to_signed(288,23)) or (ball_y_pos > to_signed(14592,23)) then
				--ball_vy <= 0-ball_vy;
			--end if;
			
		  end if;
	  end if;
    end if;
  end process;
end;
