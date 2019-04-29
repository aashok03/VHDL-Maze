--Pattern Module. Currently working for Ball and Paddle

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

  -- MAX SPEED 63px
  constant X_MIN : unsigned (9 downto 0) := 10d"63"
  constant X_MAX : unsigned (9 downto 0) := 10d"574"; -- 512+63-1
  constant Y_MIN : unsigned (9 downto 0) := 10d"63" ;
  constant Y_MAX : unsigned (9 downto 0) := 10d"416"; -- 480-63-1

  constant BLANK   : unsigned (5 downto 0) := 6d"000000";
  constant OUTSIDE : unsigend (5 downto 0) := 6d"101010";
  constant INSIDE  : unsigned (5 downto 0) := 6d"010101";
  constant OBJECT  : unsigned (5 downto 0) := 6d"111000";

begin
  RGB <= BLANK   when (valid = '0')                                                     else
         OUTSIDE when (row >= Y_MIN and row <= Y_MAX and col >= X_MIN and col <= X_MAX) else 
         INSIDE;
end;
