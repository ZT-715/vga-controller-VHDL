library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gen_sync_tb is
end entity;

architecture tb of gen_sync_tb is
    
  -- pixel count of each interval
	 constant HIGH_START_COUNT: natural := 56; 
	 constant LOW_COUNT: natural := 120;
	 constant TOTAL_COUNT: natural := 1040;
  
	 constant COUNTER_LENGTH: natural := 11;

    constant LIMIT: natural := TOTAL_COUNT;
    
	 signal rst, clk: std_logic := '0';
    signal sync: std_logic;
    signal c: std_logic_vector(COUNTER_LENGTH - 1 downto 0);

begin
    counter: entity work.gen_counter(imp)
					generic map(LIMIT, COUNTER_LENGTH)
					port map(rst => rst,
								clk => clk,
								en => '1',
								y => c);

    uut: entity work.gen_sync(imp) 
                generic map(HIGH_START_COUNT => HIGH_START_COUNT,
									 LOW_COUNT => LOW_COUNT,
									 TOTAL_COUNT => TOTAL_COUNT) 
                port map(rst => rst,
								 clk => clk, 
								 c => c,
								 sync => sync);

    clk <= not clk after 10 ns;

--    rst <= '1', '0' after 20 ns;
	 process
	 begin
	  rst <= '0';
	  wait for 20 ns;
	  rst <= '1';
	  wait for 40 ns;
	  rst <= '0';
	  wait;
	 end process;

    process
    begin
        wait until rst = '0';
        assert sync = '1'
        report "Synchrony signal started LOW."
        severity failure;

        wait for HIGH_START_COUNT* 20 ns;
		  
        assert sync = '0'
        report "Synchrony signal did't changed from high to low."
        severity failure;
		  
		  wait for LOW_COUNT * 20 ns;
		  
        assert sync = '1'
        report "Synchrony signal did't changed to high."
        severity failure;
		  
		  wait;
    end process;

	process
	begin
		wait until rst = '0';
		
		wait for TOTAL_COUNT * 20 ns;
		
		assert to_integer(unsigned(c)) = 0
		report "Counter didn't end at LIMIT"
		severity failure;
		
		wait for HIGH_START_COUNT* 20 ns;  
		
		assert sync = '0'
		report "Synchrony signal did't changed from high to low."
		severity failure;
		
		assert now = 0 ns
		report "Tests ended successfully"
		severity note;
		
		wait;
	end process;
	 
end architecture;
