library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PATTERN is
  port(
    valid : in std_logic;
    row   : in unsigned (9 downto 0);
    col   : in unsigned (9 downto 0);
    
    paddle : in unsigned (9 downto 0);
    ball_x : in unsigned (9 downto 0);
    ball_y : in unsigned (9 downto 0);
    
    RGB    : out std_logic_vector (5 downto 0)      
    );
end;

architecture synth of PATTERN is

  -- MAX BALL SPEED 63px
  constant X_MIN : unsigned (9 downto 0) := 10d"63";
  constant X_MAX : unsigned (9 downto 0) := 10d"574"; -- 512+63-1
  constant Y_MIN : unsigned (9 downto 0) := 10d"63" ;
  constant Y_MAX : unsigned (9 downto 0) := 10d"416"; -- 480-63-1

  constant BLANK   : std_logic_vector (5 downto 0) := 6b"010011";
  constant OUTSIDE : std_logic_vector (5 downto 0) := 6b"101010";
  constant INSIDE  : std_logic_vector (5 downto 0) := 6b"010101";
  constant OBJECT  : std_logic_vector (5 downto 0) := 6b"111000";

begin
--RGB <= INSIDE when valid = '1' else BLANK;
--RGB <= "001011" when valid = '1' and row > 200 and row < 400 and col > 200 and col < 300 else "011101";
--RGB <= OUTSIDE when row < 10d"640" and row > 10d"100" and col < 10d"480" and col > 10d"100"else BLANK;
  --RGB <= BLANK   when (valid = '0')                                                     else
         --OUTSIDE when (row >= Y_MIN and row <= Y_MAX and col >= X_MIN and col <= X_MAX) else 
         --INSIDE;
	
 RGB <= "111111" when (col < (paddle + 81) and col > paddle - 1 and row < 456 and row > 445) --The paddle
			 or (col < 63 or col > 574 or row < 9) --The border
			 or ( (col = ball_x + 4 or col = ball_x - 4) and (row < ball_y + 2 and row > ball_y - 2) ) --Ball top/bottom row 1
			 or ( (col = ball_x + 3 or col = ball_x - 3) and (row < ball_y + 3 and row > ball_y - 3) ) --Ball top/bottom row 2
			 or ( (col = ball_x + 2 or col = ball_x - 2) and (row < ball_y + 4 and row > ball_y - 4) ) --Ball top/bottom row 3
			 or ( (col < ball_x + 2 and col > ball_x - 2) and (row < ball_y + 5 and row > ball_y - 5) ) --Ball center (3 rows)
			 --or ( (col < 600 and col > 0) and (row < 120 and row > 0) ) --Ball center (3 rows)
			 else "000000";
		 
		 
		 
end;
