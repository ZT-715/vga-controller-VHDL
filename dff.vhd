library ieee;
use ieee.std_logic_1164.all;

entity dflipfflop is
	generic(NUM_BITS: natural := 8);

    port(
        clk, rst: in std_logic;
		  d: in std_logic_vector(NUM_BITS -1 downto 0);
        q: out std_logic_vector(NUM_BITS -1 downto 0)
		  );

	begin
	
		assert NUM_BITS >= 1
		report "DFF bus is null"
		severity failure;
		
end entity;

architecture imp of dff is

begin

process(clk, rst)
begin
    if rst = '1' then
        q <= (others => '0');
    elsif rising_edge(clk) then 
            q <= d;
    end if;
end process;

end architecture;
