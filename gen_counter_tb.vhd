library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gen_counter_tb is 

end entity;

architecture tb of gen_counter_tb is
constant LIMIT: natural := 100;
constant COUNTER_LENGHT: natural := 8;

signal rst, clk, en: std_logic := '1';
signal y: std_logic_vector(COUNTER_LENGHT-1 downto 0);

begin

	clk <= not clk after 10 ns;
	rst <= '1', '0' after 20 ns;
	en <= '0', '1' after 50 ns;
	
	uut: entity work.gen_counter(imp) 
					generic map(LIMIT, COUNTER_LENGHT)
					port map(rst, clk, en, y);
					
	process
		variable count: natural range 0 to LIMIT - 1;
		begin
			wait until en = '1';
            
            for n in natural range 0 to 2 loop
                for counting in natural range 0 to LIMIT - 1 loop
                        count := to_integer(unsigned(y));
                                            
                        report time'image(now) & " - " & integer'image(counting) & 
                        " vs. " & integer'image(count);
                
                        assert counting = count
                        severity failure;
                        
                       wait for 20 ns;
                end loop;
                
                report "End of cycle " & integer'image(n);
            end loop;
            
            report "Success!"; -- run 6050 ns
            
			wait;
	end process;
end architecture;
													
	