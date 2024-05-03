library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gen_counter is

    generic(
        LIMIT: integer := 1040;
        COUNTER_LENGTH: integer := 11;
    );

    port(
        rst, clk, en: in std_logic;
        y: out std_logic_vector(COUNTER_LENGTH-1 downto 0));

end entity;

architecture imp of gen_counter is
    signal count: unsigned(COUNTER_LENGTH-1 downto 0);
begin
    
    process(clk, rst, en)
        variable count: natural range 0 to LIMIT;
    begin
        if rst = '1' then 
            count <= 0;
        elsif rising_edge(clk) then
            if en = '1' then
                if count = LIMIT then
                    count <= 0;
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
        y <= std_logic_vector(to_unsigned(count, COUNTER_LENGTH));
    end process;


end architecture;
