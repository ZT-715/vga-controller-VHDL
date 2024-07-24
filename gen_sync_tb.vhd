library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gen_sync_tb is
end entity;

architecture tb of gen_sync_tb is
    
    -- Contagem de pixeis para cada intervalo do gerador de pulso
	constant HIGH_START_COUNT: natural := 5; 
	constant LOW_COUNT: natural := 5;
	constant TOTAL_COUNT: natural := 15;
  
	constant COUNTER_LENGTH: natural := 5;

    constant LIMIT: natural := TOTAL_COUNT;
    
	signal rst, clk: std_logic := '0';
    signal sync: std_logic;
    signal c: std_logic_vector(COUNTER_LENGTH - 1 downto 0);

begin
    counter: entity work.gen_counter(imp)
					generic map(LIMIT,
                                COUNTER_LENGTH)
					port map(rst => rst,
                             clk => clk,
                             en => '1',
                             y => c);

    uut: entity work.gen_sync(imp) 
                generic map(HIGH_START_COUNT => HIGH_START_COUNT,
                            LOW_COUNT => LOW_COUNT,
                            TOTAL_COUNT => TOTAL_COUNT,
                            COUNTER_LENGTH => COUNTER_LENGTH) 
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

    TEST: process
    begin
        wait until rst = '0';
        
        for i in natural range 0 to 2 loop
            assert sync = '1'
            report time'image(now) & " - Signal low after reset."
            severity failure;

            wait for HIGH_START_COUNT * 20 ns;
              
            assert sync = '0'
            report time'image(now) & " - Sync pulse failed to start."
            severity failure;
              
            wait for LOW_COUNT * 20 ns;
              
            assert sync = '1'
            report time'image(now) & " - Sync pulse failed to end."
            severity failure;
            
            wait for (TOTAL_COUNT - LOW_COUNT - HIGH_START_COUNT)* 20 ns;
            report time'image(now) & " - End of cycle " & integer'image(i) & ".";
		 end loop;
         
         report time'image(now) & " - Success!";
		 wait;
    end process;
	 
end architecture;
