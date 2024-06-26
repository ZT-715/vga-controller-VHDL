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
        sel, en, clk   : in  std_logic;        
        h_address : in  std_logic_vector(h_bus - 1 downto 0);
        v_address : in  std_logic_vector(v_bus - 1 downto 0);
        rgb       : out std_logic_vector(data_bus - 1 downto 0)
    );

    constant COLOR_LENGTH: natural := data_bus/3;

    constant RED:    std_logic_vector(data_bus - 1 downto 0) := (data_bus - 1 downto color_length*2 => '1', others => '0');
    constant GREEN:  std_logic_vector(data_bus - 1 downto 0) := (color_length*2 - 1 downto color_length => '1', others => '0');
    constant BLUE:   std_logic_vector(data_bus - 1 downto 0) := (color_length - 1 downto 0 => '1', others => '0');
    constant CYAN:   std_logic_vector(data_bus - 1 downto 0) := (color_length*2 - 1 downto 0 => '1', others => '0');
    constant MAGENTA:std_logic_vector(data_bus - 1 downto 0) := (color_length*2 - 1 downto color_length => '0', others => '1');
    constant YELLOW: std_logic_vector(data_bus - 1 downto 0) := (data_bus - 1 downto color_length => '1', others => '0');
    constant WHITE:  std_logic_vector(data_bus - 1 downto 0) := (others => '1');
    constant BLACK:  std_logic_vector(data_bus - 1 downto 0) := (others => '0');

end entity rgb;

architecture imp of rgb is

signal int_v_address: integer range 0 to 600;
signal int_h_address: integer range 0 to 800;

signal rgb_out_v: std_logic_vector(data_bus -1 downto 0);
signal rgb_out_h: std_logic_vector(data_bus -1 downto 0);

signal rgb_out: std_logic_vector(data_bus -1 downto 0);

begin
int_h_address <= to_integer(unsigned(h_address));
int_v_address <= to_integer(unsigned(v_address));


rgb_out <= rgb_out_h when sel = '0' else rgb_out_v;

rgb <= BLACK when en = '0' else rgb_out;

process (clk, int_v_address)
   begin
        if rising_edge(clk) then
            if int_v_address = 0 then
                rgb_out_v <= RED;
            elsif int_v_address = 74 then
                rgb_out_v <= GREEN;
            elsif int_v_address = 149 then
                rgb_out_v <= BLUE;
            elsif int_v_address = 224 then
                rgb_out_v <= BLACK;
            elsif int_v_address = 299 then
                rgb_out_v <= WHITE;
            elsif int_v_address = 374 then
                rgb_out_v <= CYAN;
            elsif int_v_address = 449 then
                rgb_out_v <= MAGENTA;
            elsif int_v_address = 524 then
                rgb_out_v <= YELLOW;
            else
                rgb_out_v <= rgb_out_v; 
            end if;
        end if;
    end process;
    
    
process (clk, int_h_address)
   begin
        if rising_edge(clk) then 
            if (int_h_address = 0) or (int_h_address = 800 - 1) then
                rgb_out_h <= RED;
            elsif int_h_address = 100 - 1 then
                rgb_out_h <= GREEN;
            elsif int_h_address = 200 - 1 then
                rgb_out_h <= BLUE;
            elsif int_h_address = 300 - 1 then
                rgb_out_h <= BLACK;
            elsif int_h_address = 400 - 1 then
                rgb_out_h <= WHITE;
            elsif int_h_address = 500 - 1 then
                rgb_out_h <= CYAN;
            elsif int_h_address = 600 - 1 then
                rgb_out_h <= MAGENTA;
            elsif int_h_address = 700 - 1 then
                rgb_out_h <= YELLOW;
            else
                rgb_out_h <= rgb_out_h; 
            end if;
        end if;
end process;
end architecture;
