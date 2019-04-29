library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity VGA is
  port(
    tick  : in std_logic;
    valid : out std_logic := '1';
    row   : out unsigned (9 downto 0) := 10d"0";
    col   : out unsigned (9 downto 0) := 10d"0";
    HSYNC : out std_logic;
    VSYNC : out std_logic
  );	
end;

architecture synth of VGA is
begin

horz_pos_counter : process(tick)
begin
    if(rising_edge(tick)) then
		col <= 10d"0" when col = 799 else (col + 1);
		row <= 10d"0" when col = 799 and row = 524 else 
			(row + 1) when col = 799;
			HSYNC <= '0' when col > 655 and col < 752 else '1';
	    VSYNC <= '0' when row > 489 and row < 492 else '1';
	    valid <= '1' when row < 480 and col < 640 else '0';
    end if;

end process;
end;
