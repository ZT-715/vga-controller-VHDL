library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gen_counter is
    generic(
        LIMIT           : integer := 1040;
        COUNTER_LENGTH  : integer := 11
    );
    port(
        rst, clk, en   : in  std_logic;
        y              : out std_logic_vector(COUNTER_LENGTH-1 downto 0)
    );

	 begin
	 
	 assert (2**COUNTER_LENGTH - 1) >= LIMIT
	 report "COUNTER_LENGHT too small for LIMIT value"
	 severity failure;
	 
end entity;

architecture imp of gen_counter is
begin
    process(clk)
	  variable count: natural range 0 to LIMIT := 0;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                count := 0; 
            elsif en = '1' then
                count := count + 1;
                if count = LIMIT then
                    count := 0;
                end if;
            end if;
        end if;
		    y <= std_logic_vector(to_unsigned(count, COUNTER_LENGTH));
    end process;

end architecture;

