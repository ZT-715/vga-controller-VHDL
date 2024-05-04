library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity gen_sync is
    generic(
    -- pixel count of each interval
        LOW: natural := 120;
        COUNTER_LENGTH: natural := 11
    );

    port(
        rst, clk: in std_logic; 
		  c: in std_logic_vector(COUNTER_LENGTH-1 downto 0);
        sync: out std_logic
    );

end entity gen_sync;

architecture imp of gen_sync is
	signal count: unsigned(COUNTER_LENGTH - 1 downto 0);
	signal d: std_logic;
begin
	
    count <= (unsigned(c));

	process(count)
	begin
		-- report integer'image(count);
		if(count >= LOW-2) then
			d <= '1';
		else 
		  d <= '0';
		end if;
	end process;
   			 
   sync <= d;

end architecture;

--architecture imp2 of gen_sync is
--	signal count: unsigned(COUNTER_LENGTH - 1 downto 0);
--	signal d, q: std_logic;
--begin
--	
--	 dff: entity work.dflipflop(imp) port map(rst, clk, d, q);
--
--    count <= (unsigned(c));
--
--	process(count, q)
--	begin
--		-- report integer'image(count);
--		if(count = 0) then
--			d <= '0';
--		elsif(count = LOW-2) then
--			d <= '1';
--		else
--			d <= q;
--		end if;
--	end process;
--   			 
--   sync <= q;
--
--end architecture;
--    

