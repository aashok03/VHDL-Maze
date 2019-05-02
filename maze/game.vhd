library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

entity GAME is
  port(
    L1      : in std_logic;
    R1      : in std_logic;
    U1	  : in std_logic;
    D1	  : in std_logic;
    
    L2      : in std_logic;
    R2      : in std_logic;
    U2	  : in std_logic;
    D2	  : in std_logic;
    
    tick    : in std_logic;
    paddle_position_x_1 : out unsigned (9 downto 0);
    paddle_position_y_1 : out unsigned (9 downto 0);
    paddle_position_x_2 : out unsigned (9 downto 0);
    paddle_position_y_2 : out unsigned (9 downto 0)
  );
end;

architecture synth of GAME is
  signal paddlex1     : unsigned (14 downto 0);
  signal paddley1     : unsigned (14 downto 0);
  signal paddlex2     : unsigned (14 downto 0);
  signal paddley2     : unsigned (14 downto 0);
  
  signal little_count  : unsigned (11 downto 0) := 12d"0";
  signal big_count     : unsigned (7 downto 0) := 8d"0";
  signal once          : std_logic := '0';
begin

  paddle_position_x_1 <= paddlex1     (14 downto 5);
  paddle_position_x_2 <= paddlex2     (14 downto 5);
  paddle_position_y_1 <= paddley1     (14 downto 5);
  paddle_position_y_2 <= paddley2     (14 downto 5);
  
  
  process (tick) is
  begin
    if rising_edge(tick) then
      little_count <= little_count + 1;
      
      -- PADDLE MOVES
      if little_count = 0 then
        big_count <= big_count + 1;
        paddlex1 <= (paddlex1 + 1) when (L1 = '1' and R1 = '0') and paddlex1 < 14000 else
                    (paddlex1 - 1) when (L1 = '0' and R1 = '1') and paddlex1 > 6500  else
                    paddlex1;
        paddley1 <= (paddley1 + 1) when (U1 = '1' and D1 = '0') and paddley1 < 12000 else
                    (paddley1 - 1) when (U1 = '0' and D1 = '1') and paddley1 > 5000  else
                    paddley1;
        paddlex2 <= (paddlex2 + 1) when (L2 = '1' and R2 = '0') and paddlex2 < 12000 else
                    (paddlex2 - 1) when (L2 = '0' and R2 = '1') and paddlex2 > 5000  else
                    paddlex2;
        paddley2 <= (paddley2 + 1) when (U2 = '1' and D2 = '0') and paddley2 < 14000 else
                    (paddley2 - 1) when (U2 = '0' and D2 = '1') and paddley2 > 6500  else
                    paddley2;
        
        -- BALL MOVES
        if big_count = 0 then		    
          
          if once = '0' then -- This happens once
            once <= '1';		
            paddlex1     <= 15d"4800";
            paddley1     <= 15d"5000";
            paddlex2     <= 15d"5000";
            paddley2     <= 15d"5200";
          end if;
          
          if paddlex1 = 14000 or paddlex1 = 6500 or paddley1 = 5000 or
            (paddlex1 > 9600 and paddlex1 < 9920 and paddley1 < 6400 and paddley1 > 4800) --1
            
            or (paddley1 > 9920 and paddley1 < 10240 and paddlex1 > 8000 and paddlex1 < 13120)--2
            or (paddley1 > 8320 and paddley1 < 8640 and paddlex1 > 6400 and paddlex1 < 8000)--3
            or (paddley1 > 6080 and paddley1 < 6400 and paddlex1 > 11520 and paddlex1 < 14400)--4

            or (paddley1 > 8320 and paddley1 < 10240 and paddlex1 > 8960 and paddlex1 < 9280)--5				
            or (paddley1 > 8640 and paddley1 < 10240 and paddlex1 > 11520 and paddlex1 < 11840)--6				
            or (paddley1 > 6080 and paddley1 < 7360 and paddlex1 > 11520 and paddlex1 < 11840)--7
            or (paddley1 > 7040 and paddley1 < 7360 and paddlex1 > 11520 and paddlex1 < 13120)--8
            
            or (paddley1 > 7040 and paddley1 < 8000 and paddlex1 > 12800 and paddlex1 < 13120)--9				
            or (paddley1 > 8640 and paddley1 < 8960 and paddlex1 > 10560 and paddlex1 < 11840)--10				
            or (paddley1 > 6400 and paddley1 < 8960 and paddlex1 > 10560 and paddlex1 < 10880)--11				
            or (paddley1 > 7040 and paddley1 < 7360 and paddlex1 > 8000 and paddlex1 < 10880)--12				
            or (paddley1 > 6080 and paddley1 < 7360 and paddlex1 > 8000 and paddlex1 < 8320)--13
            
            or (paddley1 > 3200 and paddley1 < 5120 and paddlex1 > 12800 and paddlex1 < 13120)--14
          then
            paddlex1 <= 15d"7000";
            paddley1 <= 15d"12000";				
          end if;
          
          
          if paddley2 = 14000 or paddley2 = 6500 or paddlex2 = 5000 or
            (paddley2 > 9600 and paddley2 < 9920 and paddlex2 < 6400 and paddlex2 > 4800) --1
            
            or (paddlex2 > 9920 and paddlex2 < 10240 and paddley2 > 8000 and paddley2 < 13120)--2
            or (paddlex2 > 8320 and paddlex2 < 8640 and paddley2 > 6400 and paddley2 < 8000)--3
            or (paddlex2 > 6080 and paddlex2 < 6400 and paddley2 > 11520 and paddley2 < 14400)--4

            or (paddlex2 > 8320 and paddlex2 < 10240 and paddley2 > 8960 and paddley2 < 9280)--5				
            or (paddlex2 > 8640 and paddlex2 < 10240 and paddley2 > 11520 and paddley2 < 11840)--6				
            or (paddlex2 > 6080 and paddlex2 < 7360 and paddley2 > 11520 and paddley2 < 11840)--7
            or (paddlex2 > 7040 and paddlex2 < 7360 and paddley2 > 11520 and paddley2 < 13120)--8
            
            or (paddlex2 > 7040 and paddlex2 < 8000 and paddley2 > 12800 and paddley2 < 13120)--9				
            or (paddlex2 > 8640 and paddlex2 < 8960 and paddley2 > 10560 and paddley2 < 11840)--10				
            or (paddlex2 > 6400 and paddlex2 < 8960 and paddley2 > 10560 and paddley2 < 10880)--11				
            or (paddlex2 > 7040 and paddlex2 < 7360 and paddley2 > 8000 and paddley2 < 10880)--12				
            or (paddlex2 > 6080 and paddlex2 < 7360 and paddley2 > 8000 and paddley2 < 8320)--13
            
            or (paddlex2 > 3200 and paddlex2 < 5120 and paddley2 > 12800 and paddley2 < 13120)--14
          then
            paddley2 <= 15d"7000";
            paddlex2 <= 15d"12000";				
          end if;
        end if;
      end if;
    end if;
  end process;
end;
