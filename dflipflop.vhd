library ieee;
use ieee.std_logic_1164.all;

entity dflipflop is
  port(
        clk, rst: in std_logic;
		  d: in std_logic;
        q: out std_logic
		  );

	begin
		
end entity;

architecture imp of dflipflop is

begin

process(clk, rst)
begin
    if rst = '1' then
        q <= '1';
    elsif rising_edge(clk) then 
        q <= d;
    end if;
end process;

end architecture;
