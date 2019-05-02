library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PATTERN is
  port(
    valid    : in std_logic;
    row      : in unsigned (9 downto 0);
    col      : in unsigned (9 downto 0);    
    paddlex1 : in unsigned (9 downto 0);
    paddley1 : in unsigned (9 downto 0);
    paddlex2 : in unsigned (9 downto 0);
    paddley2 : in unsigned (9 downto 0);    
    RGB    : out std_logic_vector (5 downto 0)      
    );
end;

architecture synth of PATTERN is

  
begin
  
  RGB <= "011001" when (col < (paddlex1 + 15) and col > paddlex1 - 1 and row < paddley1 + 10 and row > paddley1 - 1) else
         "000111" when (row  < (paddlex2 + 15) and row > paddlex2 - 1 and col < paddley2 + 10 and col > paddley2 - 1) else
         "111111" when (row > 150 and row < 160 and col > 200 and col < 410)--top border
         or (row > 350 and row < 360 and col > 240 and col < 450)--bottom border
         or (row > 150 and row < 360 and col > 200 and col < 210)--left border
         or (row > 100 and row < 360 and col > 440 and col < 450)--right border
         
         or (row > 150 and row < 200 and col > 300 and col < 310)--1
         or (row > 310 and row < 320 and col > 250 and col < 410)--2
         or (row > 260 and row < 270 and col > 200 and col < 250)--3
         or (row > 190 and row < 200 and col > 360 and col < 450)--4

         or (row > 260 and row < 320 and col > 280 and col < 290)--5				
         or (row > 270 and row < 320 and col > 360 and col < 370)--6				
         or (row > 190 and row < 230 and col > 360 and col < 370)--7
         or (row > 220 and row < 230 and col > 360 and col < 410)--8
         
         or (row > 220 and row < 250 and col > 400 and col < 410)--9				
         or (row > 270 and row < 280 and col > 330 and col < 370)--10				
         or (row > 200 and row < 280 and col > 330 and col < 340)--11				
         or (row > 220 and row < 230 and col > 250 and col < 340)--12				
         or (row > 190 and row < 230 and col > 250 and col < 260)--13
         
         or (row > 100 and row < 160 and col > 400 and col < 410)--14
         else "000000";
end;
