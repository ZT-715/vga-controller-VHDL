library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity gen_sync is
    generic(
    -- pixel count of each interval
		  HIGH_START_COUNT: natural := 56; 
        LOW_COUNT: natural := 120;
		  TOTAL_COUNT: natural := 1040;
		  
        COUNTER_LENGTH: natural := 11
    );

    port(
        rst, clk: in std_logic; 
		  c: in std_logic_vector(COUNTER_LENGTH-1 downto 0);
        sync: out std_logic
    );
	 
end entity gen_sync;

architecture imp of gen_sync is
	signal count: integer range 0 to 2**COUNTER_LENGTH - 1;
	signal d, q: std_logic;
begin
	
	assert HIGH_START_COUNT > 0 	
	report "HIGH_START_COUNT must be 1 or greater"
	severity failure;
	
--  	 dff: entity work.dflipflop(imp) 
--  			port map(clk => clk,
--  						rst => rst,
--  						d => d,
--  						q => q);

    count <= to_integer(unsigned(c));

    with count select
        d <=
            '1' when 0,
            '1' when TOTAL_COUNT - 1,
            '0' when HIGH_START_COUNT - 1,
            '1' when HIGH_START_COUNT + LOW_COUNT - 1,
            unaffected when others;    
	 	 
   sync <= d;

end architecture;
--    

