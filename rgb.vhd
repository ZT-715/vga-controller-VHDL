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
        en        : in  std_logic;
        h_address : in  std_logic_vector(h_bus - 1 downto 0);
        v_address : in  std_logic_vector(v_bus - 1 downto 0);
        rgb       : out std_logic_vector(data_bus - 1 downto 0)
    );

    constant COLOR_LENGHT: natural := data_bus/3;

end entity rgb;

architecture imp of rgb is
    constant RED: std_logic_vector(data_bus - 1 downto 0) := (data_bus - 1 downto color_lenght*2 => '1',
                                                              color_lenght*2 - 1 downto 0 => '0'); 
    constant BLACK: std_logic_vector(data_bus - 1 downto 0) := (others => '0'); 
begin
    process(en)
    begin
        if en = '1' then
            rgb <= RED;
        else
            rgb <= BLACK;
        end if;
    end process;
end architecture imp;

