library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is 
    generic(
        H_BUS : natural := 6;
        V_BUS : natural := 4;
        VALUE_LENGTH : natural := 12)
        
        H_ADDRESS_END : natural := 50;
        V_ADDRESS_END : natural := 37);
    
    port(
        clk : in std_logic;
        h_address   : in std_logic_vector(H_BUS - 1 downto 0);
        v_address   : in std_logic_vector(V_BUS - 1 downto 0);
        value       : out std_logic_vector(VALUE_LENGTH - 1 downto 0));

begin

    assert H_BUS > 0 and V_BUS > 0 and VALUE_LENGHT > 0
    report "All SLVs must be of size 1 or greater."
    severity failure;

    assert 2**V_BUS - 1 > V_ADDRESS_MAX
    report "V_ADDRESS_MAX value is less than the V_BUS allows."
    severity failure;
    
    assert 2**H_BUS - 1 > H_ADDRESS_MAX
    report "H_ADDRESS_MAX value is less than the H_BUS allows."
    severity failure;

end entity; 

architecture imp of rom is
begin

end architecture;

    
