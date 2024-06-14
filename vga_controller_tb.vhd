library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_controller_tb is
   
  constant ADDR_LINE_LENGTH: natural := 10;
  constant ADDR_COLUMN_LENGTH: natural := 10;
  
  constant CLOCK_PERIOD: time := 20 ns;
  
  constant H_ADDRESSABLE: natural := 800;
  constant H_FRONT_PORCH: natural := 56; 
  constant H_SYNC: natural := 120; 
  constant H_BACK_PORCH: natural := 64;
  constant H_PERIOD: natural := H_BACK_PORCH + H_SYNC + H_FRONT_PORCH + H_ADDRESSABLE;

  constant V_ADDRESSABLE: natural := 600; 
  constant V_FRONT_PORCH: natural := 37; 
  constant V_SYNC: natural := 6; 
  constant V_BACK_PORCH: natural := 23;
  constant V_PERIOD: natural := V_BACK_PORCH + V_SYNC + V_FRONT_PORCH + V_ADDRESSABLE;
  
end entity;

architecture tb of vga_controller_tb is

    signal clk, rst: std_logic := '1';
    signal hsync, vsync: std_logic;
    signal h_address: std_logic_vector(ADDR_LINE_LENGTH-1 downto 0);
    signal v_address: std_logic_vector(ADDR_COLUMN_LENGTH-1 downto 0);
	signal addressing: std_logic;
    signal r, g, b: std_logic_vector(3 downto 0);
	 
	 signal int_h_address, int_v_address: integer;
    
begin

    uut: entity work.vga_controller(imp) port map(rst => rst,
																  clk => clk,
																  hsync => hsync, 
																  vsync => vsync, 
																  h_address => h_address, 
																  v_address => v_address,
																  addressing => addressing,
																  r => r, 
																  g => g, 
																  b => b);

    int_h_address <= to_integer(unsigned(h_address));
    int_v_address <= to_integer(unsigned(v_address));
	 
	 clk <= not clk after CLOCK_PERIOD/2;

	 RESET:process
	 begin
		rst <= '0';
		wait for CLOCK_PERIOD;
		rst <= '1';
		wait for CLOCK_PERIOD*2;
		rst <= '0';
		wait;
	 end process;

	TEST_INITIAL_STATE:process
		constant zero_h_address: std_logic_vector(ADDR_LINE_LENGTH-1 downto 0) := (others => '0');
		constant zero_v_address: std_logic_vector(ADDR_LINE_LENGTH-1 downto 0) := (others => '0');
	 
	begin
	  wait until rst = '0';
	  assert (hsync = '1' and vsync = '1' and h_address = zero_h_address and
      v_address = zero_v_address and addressing = '0')
	  report "Incorrect state after reset."
	  severity failure;
	  
	  wait;
	end process;
	 
	TEST_HORIZONTAL_SYNC:process
	begin
		wait until rst = '0';
		loop 
			assert hsync = '1'
			report "Hsync low on start of horizontal period."
			severity failure;
			
			wait for H_FRONT_PORCH*CLOCK_PERIOD;
			
			assert hsync = '0'
			report "Hsync high on high on sync pulse."
			severity failure;
			
			wait for V_SYNC*CLOCK_PERIOD;
			assert hsync = '1'
			report "Sync pulse larger than expected."
			severity failure;
			
			wait for (H_PERIOD - H_FRONT_PORCH - V_SYNC)*CLOCK_PERIOD;
		end loop;
	end process;
	
	TEST_VERTICAL_SYNC:process
	begin
		wait until rst = '0';
		loop
			assert vsync = '1'
			report "Vsync low on start of horizontal period."
			severity failure;
			
			wait for V_FRONT_PORCH*CLOCK_PERIOD;
			
			assert vsync = '0';
			report "Vsync high on high on sync pulse."
			severity failure;
			
			wait for V_SYNC*CLOCK_PERIOD;
			assert vsync = '1'
			report "Vsync pulse larger than expected."
			severity failure;
			
			wait for (V_PERIOD - V_FRONT_PORCH - V_SYNC)*CLOCK_PERIOD;
		end loop;
	end process;
	
	TEST_HORIZONTAL_ADDRESS:process
	begin
		wait until addressing = '1';
		horizontal_test: for n in natural range 0 to H_ADDRESSABLE - 1 loop
			assert n = int_h_address
			report "Horizontal Address diverges from expected."
			severity failure;
			wait for CLOCK_PERIOD;
		end loop;
	end process; 
	 
	TEST_VERTICAL_ADDRESS:process
	begin
		wait until addressing = '1';
		vertical_test: for n in natural range 0 to V_ADDRESSABLE - 1 loop
			assert n = int_v_address
			report "Vertical Address diverges from expected."
			severity failure;
			wait for H_PERIOD*CLOCK_PERIOD;
		end loop;
	end process;
	
end architecture;





