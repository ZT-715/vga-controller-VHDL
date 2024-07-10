library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rgb is
    generic (
        V_BUS      : integer := 10;
        H_BUS      : integer := 10;
        DATA_BUS   : integer := 12 
    );
    port (
        clk, test_en, en   : in  std_logic;        
        
        rgb_in    : in std_logic_vector(DATA_BUS - 1 downto 0);
        
        h_address : in  std_logic_vector(H_BUS - 1 downto 0);
        v_address : in  std_logic_vector(V_BUS - 1 downto 0);
        
        rgb       : out std_logic_vector(DATA_BUS - 1 downto 0)
    );

end entity rgb;

architecture imp of rgb is
	 signal rgb_test: std_logic_vector(DATA_BUS - 1 downto 0);
	 signal rgb_out: std_logic_vector(DATA_BUS - 1 downto 0);

	 signal int_h_address: natural range 0 to H_BUS;
    signal int_v_address: natural range 0 to V_BUS;
    
	 constant COLOR_LENGTH: natural := DATA_BUS/3;

    constant RED:    std_logic_vector(DATA_BUS - 1 downto 0) := (DATA_BUS - 1 downto COLOR_LENGTH*2 => '1', others => '0'); 
    constant GREEN:  std_logic_vector(DATA_BUS - 1 downto 0) := (COLOR_LENGTH*2 - 1 downto COLOR_LENGTH => '1', others => '0');
    constant BLUE:   std_logic_vector(DATA_BUS - 1 downto 0) := (COLOR_LENGTH - 1 downto 0 => '1', others => '0');
    constant CYAN:   std_logic_vector(DATA_BUS - 1 downto 0) := (COLOR_LENGTH*2 - 1 downto 0 => '1', others => '0');
    constant MAGENTA:std_logic_vector(DATA_BUS - 1 downto 0) := (COLOR_LENGTH*2 - 1 downto COLOR_LENGTH => '0', others => '1');
    constant YELLOW: std_logic_vector(DATA_BUS - 1 downto 0) := (DATA_BUS - 1 downto COLOR_LENGTH => '1', others => '0');
    constant WHITE:  std_logic_vector(DATA_BUS - 1 downto 0) := (others => '1');
    constant BLACK:  std_logic_vector(DATA_BUS - 1 downto 0) := (others => '0');

begin
    int_h_address <= to_integer(unsigned(h_address));
    int_v_address <= to_integer(unsigned(v_address));

	 rgb <= rgb_out when en = '1' else BLACK;
	 
	 rgb_out <= rgb_test when test_en = '1' else rgb_in;

	process (clk, int_v_address, int_h_address)
   begin
        if rising_edge(clk) then
			  if int_v_address > 450 then
					if int_v_address = 0 then
						 rgb_test <= RED;
					elsif int_v_address = 74 then
						 rgb_test <= GREEN;
					elsif int_v_address = 149 then
						 rgb_test <= BLUE;
					elsif int_v_address = 224 then
						 rgb_test <= BLACK;
					elsif int_v_address = 299 then
						 rgb_test <= WHITE;
					elsif int_v_address = 374 then
						 rgb_test <= CYAN;
					elsif int_v_address = 449 then
						 rgb_test <= MAGENTA;
					elsif int_v_address = 524 then
						 rgb_test <= YELLOW;
					else
						 rgb_test <= rgb_test; 
					end if;
				else
					if  (int_h_address = 0) then
						 rgb_test <= RED;
					elsif int_h_address = 100 - 1 then
						 rgb_test <= GREEN;
					elsif int_h_address = 200 - 1 then
						 rgb_test <= BLUE;
					elsif int_h_address = 300 - 1 then
						 rgb_test <= BLACK;
					elsif int_h_address = 400 - 1 then
						 rgb_test <= WHITE;
					elsif int_h_address = 500 - 1 then
						 rgb_test <= CYAN;
					elsif int_h_address = 600 - 1 then
						 rgb_test <= MAGENTA;
					elsif int_h_address = 700 - 1 then
						 rgb_test <= YELLOW;
					else
						 rgb_test <= rgb_test; 
					end if;
				end if;
        end if;
    end process;
 end architecture;