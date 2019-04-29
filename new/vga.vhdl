--vga_driver module
--Creates the outputs necessary to drive the display

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity VGA is
  port(
    tick  : in std_logic;
    valid : out std_logic;
    row   : out unsigned (9 downto 0);
    col   : out unsigned (9 downto 0);
    HSYNC : out std_logic;
    VSYNC : out std_logic
  );	
end;

architecture synth of VGA is

begin
  process (tick) is
  begin
    if rising_edge(tick) then
      HSYNC <= '0' when col >= to_unsigned(656,10) and col < to_unsigned(752,10) else '1';
      VSYNC <= '0' when row >= to_unsigned(490,10) and tow < to_unsigned(492,10) else '1';      
      valid <= '1' when col <  to_unsigned(640,10) and row < to_unsigned(480,10) else '1';

      col <= (col + 1) mod to_unsigned(800,10);
      row <= (row + 1) when col = to_unsigned(799,10) else row;
    end if;
  end process;
end;
