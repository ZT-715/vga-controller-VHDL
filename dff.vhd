library ieee;
use ieee.std_logic_1164.all;

entity dff is

    port(
        clk, rst, cr, pr, d: in std_logic;
        q: out std_logic;)

end entity;

architecture imp of dff is

begin

process(clk, rst, cr, pr)
begin
    if rst = '1' then
        q <= '0';
    elsif rising_edge(clk) then 
        if pr = '0' then
            q <= '1';
        elsif cr = '0' then
            q <= '0';
        else 
            q <= d;
        end if;
    end if;
end process;

end architecture;
