library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Libraries for generic input range calculation 
use ieee.math_real."ceil";
use ieee.math_real."log2";


entity gen_counter is

    generic(
        LIMIT: integer := 1040
    );

    port(
        rst, clk, en: in std_logic;
        y: out std_logic_vector(integer(ceil(log2(real(LIMIT))))-1 downto 0));

end entity;

architecture imp of gen_counter is
    signal count: unsigned(y'range);

begin
    process(clk, rst, en)
    begin
        if rst = '1' then 
            count <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                if count = LIMIT - 1 then
                    count <= (others => '0');
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;

    y <= std_logic_vector(count);

end architecture;
