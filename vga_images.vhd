library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_images is
    generic(
        H_ADDRESSABLE: natural := 800;
        H_FRONT_PORCH: natural := 56; 
        H_SYNC: natural := 120; 
        H_BACK_PORCH: natural := 64;

        V_ADDRESSABLE: natural := 600; 
        V_FRONT_PORCH: natural := 37; 
        V_SYNC: natural := 6; 
        V_BACK_PORCH: natural := 23;

        H_COUNTER_LENGTH: natural := 11;
        V_COUNTER_LENGTH: natural := 10;

        ADDR_LINE_LENGTH: natural := 10;
        ADDR_COLUMN_LENGTH: natural := 10;

        RGB_LENGTH: natural := 12
    );
	 port(
        clk, en   : in  std_logic;        
		  sel       : in std_logic_vector(1 downto 0);   
        
        hsync, vsync: out std_logic;
		  addressing: out std_logic;
		  
		  h_address	: buffer std_logic_vector(ADDR_LINE_LENGTH - 1 downto 0);
        v_address	: buffer std_logic_vector(ADDR_COLUMN_LENGTH - 1 downto 0);		  
		 
        rgb			: out std_logic_vector(RGB_LENGTH - 1 downto 0)
    );

end entity;

architecture imp of vga_images is
 
	 signal int_v_address: integer range 0 to 600;
	 signal int_h_address: integer range 0 to 800;
 
	 signal rgb_out_v: std_logic_vector(RGB_LENGTH -1 downto 0);
	 signal rgb_out_h: std_logic_vector(RGB_LENGTH -1 downto 0);
 
	 signal rgb_out: std_logic_vector(RGB_LENGTH -1 downto 0);

	 constant COLOR_LENGTH: natural := RGB_LENGTH/3;

    constant RED:    std_logic_vector(RGB_LENGTH - 1 downto 0) := (RGB_LENGTH - 1 downto COLOR_LENGTH*2 => '1', others => '0');
    constant GREEN:  std_logic_vector(RGB_LENGTH - 1 downto 0) := (COLOR_LENGTH*2 - 1 downto COLOR_LENGTH => '1', others => '0');
    constant BLUE:   std_logic_vector(RGB_LENGTH - 1 downto 0) := (COLOR_LENGTH - 1 downto 0 => '1', others => '0');
    constant CYAN:   std_logic_vector(RGB_LENGTH - 1 downto 0) := (COLOR_LENGTH*2 - 1 downto 0 => '1', others => '0');
    constant MAGENTA:std_logic_vector(RGB_LENGTH - 1 downto 0) := (COLOR_LENGTH*2 - 1 downto COLOR_LENGTH => '0', others => '1');
    constant YELLOW: std_logic_vector(RGB_LENGTH - 1 downto 0) := (RGB_LENGTH - 1 downto COLOR_LENGTH => '1', others => '0');
    constant WHITE:  std_logic_vector(RGB_LENGTH - 1 downto 0) := (others => '1');
    constant BLACK:  std_logic_vector(RGB_LENGTH - 1 downto 0) := (others => '0');


begin
	int_h_address <= to_integer(unsigned(h_address));
	int_v_address <= to_integer(unsigned(v_address));
		 
   rgb <= rgb_out_h when sel = "00",
	   rgb_out_v when sel = "01",
	   RED when sel = "11",
	   else rgb_rom;
			
	vga: entity vga_controller(imp) port map(
        rst, clk	: in std_logic;
		  
        hsync, vsync: out std_logic;
        addressing: buffer std_logic;
		  
		  h_address	: buffer std_logic_vector(ADDR_LINE_LENGTH - 1 downto 0);
        v_address	: buffer std_logic_vector(ADDR_COLUMN_LENGTH - 1 downto 0);
		  
		  rgb_in		: in std_logic_vector(RGB_LENGTH - 1 downto 0);
        rgb			: out std_logic_vector(RGB_LENGTH - 1 downto 0));	
		 
	image_rom: entity rom port map(
        clk : in std_logic;
        h_address   : in std_logic_vector(H_BUS - 1 downto 0);
        v_address   : in std_logic_vector(V_BUS - 1 downto 0);
        rgb_value       : out std_logic_vector(VALUE_LENGTH - 1 downto 0)
    );

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


