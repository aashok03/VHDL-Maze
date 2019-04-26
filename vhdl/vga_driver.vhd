--vga_driver module
--Creates the outputs necessary to drive the display

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity VGA_design is
port(
    clk : in std_logic;
    valid : out std_logic;
    count_horz : out unsigned (9 downto 0);
    count_vert : out unsigned (9 downto 0);
    HSYNC : out std_logic;
    VSYNC : out std_logic
    );	
end VGA_design;
    
architecture synth of VGA_design is

constant vfp : integer := 10;
constant vd : integer := 479;
constant vbp : integer := 33;
constant vsp : integer := 2;

constant hfp : integer := 16;
constant hd  : integer := 639;
constant hbp : integer := 48;
constant hsp : integer := 96;

signal horz_pos : integer range 0 to 799;
signal vert_pos : integer range 0 to 524;
signal HSYNC_val    : std_logic;
signal VSYNC_val    : std_logic;


begin

horz_pos_counter: process(clk)
begin
    if(rising_edge(clk)) then
        if(horz_pos = 799) then
            horz_pos <= 0;
			if (vert_pos = 524) then
				vert_pos <= 0;
			else
				vert_pos <= vert_pos + 1;
			end if;
        else
            horz_pos <= horz_pos + 1;
		end if;
    end if;
end process;

horz_sync : process(clk, horz_pos)
begin
    if(rising_edge(clk)) then
        if(horz_pos > 655 and horz_pos < 752)then
            HSYNC_val <= '0';
        else
            HSYNC_val <= '1';
        end if;
    end if;
end process;

vert_sync : process(clk, vert_pos)
begin
    if(rising_edge(clk)) then
        if(vert_pos > 489 and vert_pos < 492) then
            VSYNC_val  <= '0';
        else
            VSYNC_val  <= '1';
        end if;
    end if;
end process;

validation: process(clk, horz_pos, vert_pos)
begin
    if(rising_edge(clk)) then
        if (vert_pos <= vd and horz_pos <= hd) then
            valid <= '1';
        else
            valid <= '0';
        end if;
    end if;
end process;

count_horz <= to_unsigned(horz_pos, 10);
count_vert <= to_unsigned(vert_pos, 10);
HSYNC  <=  HSYNC_val;
VSYNC  <=  VSYNC_val ;

end synth;
