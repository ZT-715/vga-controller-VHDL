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

    signal rom_v_address: std_logic_vector(V_BUS-1 downto 0);
    signal rom_h_address: std_logic_vector(H_BUS-1 downto 0);
    
    signal rgb_rom: std_logic_vector(RGB_LENGTH - 1 downto 0);
    
    signal int_rom_v_address_next: integer range 0 to 37;
    signal int_rom_h_address_next: integer range 0 to 50;
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
       
    process(clk, rst)
    begin
        if rst = '1' then
            rom_v_address <= (others => '0');
            rom_h_address <= (others => '0');
        
        elsif rising_edge(clk) then
            rom_v_address <= std_logic_vector(to_unsigned(int_rom_v_address_next, V_BUS));
            rom_h_address <= std_logic_vector(to_unsigned(int_rom_h_address_next, H_BUS));
        end if;
    end process;
    


    process(int_h_address)
    begin
        for n in 1 to 49 loop
            if (int_h_address = 799) or (int_h_address = 0) then
                int_rom_h_address_next <= 0;
            elsif (n*16) - 1 = int_h_address then
                int_rom_h_address_next <= n;
            end if;
        end loop;
    end process;
    
    process(int_v_address)
    begin
        for n in 1 to 37 loop
            if (int_v_address = 599) or (int_v_address = 0) then
                int_rom_v_address_next <= 0;
            elsif (n*16) - 1 = int_v_address then
                int_rom_v_address_next <= n;
            end if;
        end loop;
    end process;
           
end architecture;