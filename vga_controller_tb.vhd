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

    uut: entity work.vga_controller(imp) port map(rst, clk, hsync, vsync, h_address, v_address, r, g, b);

    clk <= not clk after 10 ns;
    rst <= '0' after 20 ns;

	 process
	 begin
	 wait for 1040 * 20 ns;
	 end process;
	 
end architecture;