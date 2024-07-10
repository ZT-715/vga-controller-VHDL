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
    signal int_v_address: integer range 0 to 600;
    signal int_h_address: integer range 0 to 800;
    signal int_rom_v_address: integer range 0 to 37;
    signal int_rom_h_address: integer range 0 to 50;
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

    int_h_address <= to_integer(unsigned(h_address));
    int_v_address <= to_integer(unsigned(v_address));
    
    rom_v_address <= std_logic_vector(to_unsigned(int_rom_v_address, V_BUS));
    rom_h_address <= std_logic_vector(to_unsigned(int_rom_h_address, H_BUS));
    
    with int_h_address select
        int_rom_h_address <=
            1 when 16,
            2 when 32,
            3 when 48,
            4 when 64,
            5 when 80,
            6 when 96,
            7 when 112,
            8 when 128,
            9 when 144,
            10 when 160,
            11 when 176,
            12 when 192,
            13 when 208,
            14 when 224,
            15 when 240,
            16 when 256,
            17 when 272,
            18 when 288,
            19 when 304,
            20 when 320,
            21 when 336,
            22 when 352,
            23 when 368,
            24 when 384,
            25 when 400,
            26 when 416,
            27 when 432,
            28 when 448,
            29 when 464,
            30 when 480,
            31 when 496,
            32 when 512,
            33 when 528,
            34 when 544,
            35 when 560,
            36 when 576,
            37 when 592,
            0 when others;
    
    with int_v_address select
        int_rom_v_address <=
            1 when 16,
            2 when 32,
            3 when 48,
            4 when 64,
            5 when 80,
            6 when 96,
            7 when 112,
            8 when 128,
            9 when 144,
            10 when 160,
            11 when 176,
            12 when 192,
            13 when 208,
            14 when 224,
            15 when 240,
            16 when 256,
            17 when 272,
            18 when 288,
            19 when 304,
            20 when 320,
            21 when 336,
            22 when 352,
            23 when 368,
            24 when 384,
            25 when 400,
            26 when 416,
            27 when 432,
            28 when 448,
            29 when 464,
            30 when 480,
            31 when 496,
            32 when 512,
            33 when 528,
            34 when 544,
            35 when 560,
            36 when 576,
            37 when 592,
            0 when others;
            
end architecture imp;
