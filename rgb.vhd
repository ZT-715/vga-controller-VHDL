library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rgb is
    generic (
        v_bus      : integer := 10;
        h_bus      : integer := 10;
        data_bus   : integer := 12 
    );
    port (
        clk, en   : in  std_logic;        
        
        rbg_in    : in std_logic_vector(data_bus - 1 downto 0);
        
        h_address : in  std_logic_vector(h_bus - 1 downto 0);
        v_address : in  std_logic_vector(v_bus - 1 downto 0);
        
        rgb       : out std_logic_vector(data_bus - 1 downto 0)
    );



end entity rgb;

architecture imp of rgb is

rgb <= BLACK when en = '0' else rgb_in;

end architecture;
