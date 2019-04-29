library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity TOP is
  port ( 
    left_in   : in std_logic := '0';
    right_in  : in std_logic := '0';
    HSYNC_out : out std_logic;
    VSYNC_out : out std_logic;
    RGB_out   : out std_logic_vector (5 downto 0)
  );
end;

architecture synth of TOP is

  component HSOSC is
    generic (CLKHF_DIV : String := "0b00");
    port(
      CLKHFPU : in std_logic := '1'; -- Set to 1 to power up
      CLKHFEN : in std_logic := '1'; -- Set to 1 to enable output
      CLKHF : out std_logic := 'X'); -- Clock output
  end component;

  component pll is
    port(
      outglobal_o : out std_logic; -- DISCARD
      outcore_o   : out std_logic; -- Vga Clock Output
      ref_clk_i   : in std_logic;  -- Clock Input
      rst_n_i     : in std_logic := '1'
    );
  end component;

  component VGA is
    port(
      tick  : in std_logic;
      valid : out std_logic;
      row   : out unsigned (9 downto 0);
      col   : out unsigned (9 downto 0);
      HSYNC : out std_logic;
      VSYNC : out std_logic
    );
  end component;

  component PATTERN is
    port(
      valid : in std_logic;
      row   : in unsigned (9 downto 0);
      col   : in unsigned (9 downto 0);
      
      paddle : in unsigned (9 downto 0);
      ball_x : in unsigned (9 downto 0);
      ball_y : in unsigned (9 downto 0);
      
      RGB    : out std_logic_vector (5 downto 0)      
    );
  end component;

  component GAME is
    port(
      L      : in std_logic;
      R      : in std_logic;
      tick   : in std_logic;
      ball_x_position : out unsigned (9 downto 0);
      ball_y_position : out unsigned (9 downto 0);
      paddle_position : out unsigned (9 downto 0)
    );
  end component;

  signal temp_clk : std_logic;
  signal CLOCK : std_logic;

  signal valid_sig : std_logic;
  signal row_sig : unsigned (9 downto 0);
  signal col_sig : unsigned (9 downto 0);
  signal HSYNC_sig : std_logic;       
  signal VSYNC_sig : std_logic;

  signal ball_x_sig : unsigned (9 downto 0);
  signal ball_y_sig : unsigned (9 downto 0);
  signal paddle_sig : unsigned (9 downto 0);

  signal RGB_sig : std_logic_vector (5 downto 0);
  
begin

  clock_inst   : HSOSC port map (CLKHFPU => '1', CLKHFEN => '1', CLKHF => temp_clk); -- 2 in 1 out
  pll_inst     : pll   port map (open, CLOCK, temp_clk, '1'); -- 2 out 2 in

  game_inst    : GAME  port map(left_in, right_in, CLOCK, ball_x_sig, ball_y_sig, paddle_sig); -- 3 in 2 out
  
  vga_inst     : VGA port map(CLOCK, valid_sig, row_sig, col_sig, HSYNC_sig, VSYNC_sig); -- 1 in 5 out
  pattern_inst : PATTERN port map(valid_sig, row_sig, col_sig, paddle_sig, ball_x_sig, ball_y_sig, RGB_sig); -- 6 in 1 out

  HSYNC_OUT <= HSYNC_sig;
  VSYNC_out <= VSYNC_sig;
  RGB_out   <= RGB_sig;
  
end;
