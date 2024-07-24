library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divider_by_16 is
    generic(
        IN_BUS_SIZE : natural := 10;
        OUT_BUS_SIZE: natural := 6);
    port(
        clk, rst   : in std_logic;
        input : in std_logic_vector(IN_BUS_SIZE - 1 downto 0);
        output: out std_logic_vector(OUT_BUS_SIZE - 1 downto 0));
        
end entity;

architecture imp of divider_by_16 is
begin

    process(input)
        variable int_in: natural range 0 to 2**IN_BUS_SIZE;
        variable int_out: natural range 0 to 2**OUT_BUS_SIZE;
    begin
        int_in := to_integer(unsigned(input));
        int_out := int_in / 16;
        output <= std_logic_vector(to_unsigned(int_out, OUT_BUS_SIZE));
    end process;
   
end architecture;