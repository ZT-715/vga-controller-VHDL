library ieee;
use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;

entity vga_controller_tb is
   
  constant ADDR_LINE_LENGTH: natural := 10;
  constant ADDR_COLUMN_LENGTH: natural := 10;
  
end entity;

architecture tb of vga_controller_tb is

    signal clk, rst: std_logic := '1';
    signal hsync, vsync: std_logic;
    signal h_address: std_logic_vector(ADDR_LINE_LENGTH-1 downto 0);
    signal v_address: std_logic_vector(ADDR_COLUMN_LENGTH-1 downto 0);
    signal r, g, b: std_logic_vector(3 downto 0);
    
begin

    uut: entity work.vga_controller(imp) port map(rst => rst,
																  clk => clk,
																  hsync => hsync, 
																  vsync => vsync, 
																  h_address => h_address, 
																  v_address => v_address,
																  r => r, 
																  g => g, 
																  b => b);

    clk <= not clk after 10 ns;

	 process
	 begin
	  rst <= '0';
	  wait for 20 ns;
	  rst <= '1';
	  wait for 40 ns;
	  rst <= '0';
	  wait;
	 end process;

end architecture;
