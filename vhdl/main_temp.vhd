--Main module, as working with a static ball and paddle (no bricks)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity topLevel is
    Port ( 
			left_in : in std_logic := '0';
			right_in : in std_logic := '0';
			sync_horzC : out std_logic;
			sync_vertC : out std_logic;
            RGB_pat : out std_logic_vector (5 downto 0);
			LO : out std_logic;
			RO : out std_logic
		   
           );
end topLevel;
         
architecture synth of topLevel is

component HSOSC is
port(
CLKHFPU : in std_logic := '1'; -- Set to 1 to power up
CLKHFEN : in std_logic := '1'; -- Set to 1 to enable output
CLKHF : out std_logic := 'X'); -- Clock output
end component;

component pll is
    port(
	     ref_clk_i: in std_logic;
         rst_n_i: in std_logic;
	     outglobal_o: out std_logic;
         outcore_o: out std_logic);
end component;

component VGA_design is
port(
    clk : in std_logic;
    valid : out std_logic;
    count_horz : out unsigned (9 downto 0);
    count_vert : out unsigned (9 downto 0);
    HSYNC : out std_logic;
    VSYNC : out std_logic
    );	
end component;

component pattern is
Port(
    valid : in std_logic;
    count_horz : in unsigned  (9 downto 0);
    count_vert : in unsigned  (9 downto 0);
	paddle_x : in unsigned (9 downto 0);
	ball_x : in unsigned (9 downto 0);
	ball_y : in unsigned (9 downto 0);
    RGB_pattern : out std_logic_vector (5 downto 0)
    );
end component;

component GAME is
  port(
	  L      : in std_logic;
	  R      : in std_logic;
	  clk    : in std_logic;
	  ball_x_position : out unsigned (9 downto 0);
	  ball_y_position : out unsigned (9 downto 0);
      paddle_out : out unsigned (9 downto 0);
      game_over       : out std_logic

	  --ball_array : out signed(99 downto 0);
  );    
end component;

signal clock : std_logic;
signal clk : std_logic;
signal test : std_logic;
signal valid_out : std_logic;
signal horz_count : unsigned (9 downto 0);
signal vert_count : unsigned (9 downto 0);
signal sync_horz : std_logic;
signal sync_vert : std_logic;
signal RGB : std_logic_vector (5 downto 0);
signal paddle_loc : unsigned (9 downto 0);

begin

clock_to_pll : HSOSC port map (CLKHFPU => '1', CLKHFEN => '1', CLKHF => clock);
pll_from_clock : pll port map ( clock, '1', clk, test);
vga_to_pattern : VGA_design port map (clk, valid_out, horz_count, vert_count, sync_horz, sync_vert);
pattern_to_vga_cable : pattern port map (valid_out, horz_count, vert_count, paddle_loc, to_unsigned(150, 10), to_unsigned(150, 10), RGB);
paddle_mover : GAME port map(left_in, right_in, clk, open, open, paddle_loc, open);

LO <= left_in;
RO <= right_in;

RGB_pat <= RGB;
sync_horzC <= sync_horz;
sync_vertC <= sync_vert;

end;
