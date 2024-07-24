library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_images is
    generic (
        ADDR_LINE_LENGTH: natural := 10;
        ADDR_COLUMN_LENGTH: natural := 10;
        RGB_LENGTH: natural := 12;
        H_BUS : natural := 7;
        V_BUS : natural := 6;
        H_ADDRESS_END : natural := 50;
        V_ADDRESS_END : natural := 37
    );
    port (
        rst, clk     : in  std_logic;        
        rgb_test_en  : in  std_logic;   
        hsync, vsync : out std_logic;
        addressing   : out std_logic;
        h_address    : buffer std_logic_vector(ADDR_LINE_LENGTH - 1 downto 0);
        v_address    : buffer std_logic_vector(ADDR_COLUMN_LENGTH - 1 downto 0);		  
        rgb          : out std_logic_vector(RGB_LENGTH - 1 downto 0)
    );
end entity vga_images;

architecture imp of vga_images is
    signal rom_v_address: std_logic_vector(V_BUS-1 downto 0);
    signal rom_h_address: std_logic_vector(H_BUS-1 downto 0);
    
    signal rgb_rom: std_logic_vector(RGB_LENGTH - 1 downto 0);
   
begin

    VGA: entity work.vga_controller(imp)
        port map (
            rst => rst,
            clk => clk,
            rgb_test_en => rgb_test_en,
            hsync => hsync, 
            vsync => vsync, 
            h_address_out => h_address, 
            v_address_out => v_address,
            addressing_out => addressing,
            rgb_in => rgb_rom,
            rgb => rgb
        );
							 
    rom: entity work.rom 
        port map (
            clk => clk,
            h_address => rom_h_address,
            v_address => rom_v_address,
            rgb_value => rgb_rom);       
       
    h_address_divider: entity work.divider_by_16
        generic map(
            IN_BUS_SIZE => ADDR_LINE_LENGTH, 
            OUT_BUS_SIZE => H_BUS)
        port map(
            clk => clk,
            rst => rst,
            input => h_address,
            output => rom_h_address);
            
    v_address_divider: entity work.divider_by_16
        generic map(
            IN_BUS_SIZE => ADDR_COLUMN_LENGTH,
            OUT_BUS_SIZE => V_BUS)
        port map(
            clk => clk,
            rst => rst,
            input => v_address,
            output => rom_v_address);           
end architecture;