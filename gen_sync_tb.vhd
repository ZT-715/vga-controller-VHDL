library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity gen_sync_tb is
end entity;

architecture tb of gen_sync_tb is
    
	 constant COUNTER_LENGTH: natural := 8;
    constant LOW: natural := 50;
	 
    constant LIMIT: natural := LOW*2;
    
	 signal rst, clk: std_logic := '0';
    signal sync: std_logic;
    signal c: std_logic_vector(COUNTER_LENGTH - 1 downto 0);

begin
    counter: entity work.gen_counter(imp)
					generic map(LIMIT, COUNTER_LENGTH)
					port map(rst, clk, '1', c);

    uut: entity work.gen_sync(imp) 
                generic map(LOW, COUNTER_LENGTH) 
                port map(rst,clk, c, sync);

    rst <= '1', '0' after 20 ns;
    clk <= not clk after 10 ns;

    process
    begin
        wait until rst = '0';
        assert sync = '0'
        report "Synchrony signal started LOW."
        severity failure;

        wait for LOW * 20 ns;
		  
        assert sync = '1'
        report "Synchrony signal did't changed correctly."
        severity failure;
    end process;


end architecture;
