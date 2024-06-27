-- Reescrever com loops e timedeltas para validar mudanças ao invés de estados
-- afinal, o modelsim não lê estados corretamente...

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_controller_tb is
   
  constant ADDR_LINE_LENGTH: natural := 10;
  constant ADDR_COLUMN_LENGTH: natural := 10;
  
  constant CLOCK_PERIOD: time := 20 ns;
  
  constant H_ADDRESSABLE: natural := 8;
  constant H_FRONT_PORCH: natural := 5; 
  constant H_SYNC: natural := 4; 
  constant H_BACK_PORCH: natural := 4;
  constant H_PERIOD: natural := H_BACK_PORCH + H_SYNC + H_FRONT_PORCH + H_ADDRESSABLE;
 
--    constant H_ADDRESSABLE: natural := 800;
--    constant H_FRONT_PORCH: natural := 56; 
--    constant H_SYNC: natural := 120; 
--    constant H_BACK_PORCH: natural := 64;
--    constant H_PERIOD: natural := H_BACK_PORCH + H_SYNC + H_FRONT_PORCH + H_ADDRESSABLE;

  constant V_ADDRESSABLE: natural := 6; 
  constant V_FRONT_PORCH: natural := 3; 
  constant V_SYNC: natural := 3; 
  constant V_BACK_PORCH: natural := 3;
  constant V_PERIOD: natural := V_BACK_PORCH + V_SYNC + V_FRONT_PORCH + V_ADDRESSABLE;
  
  constant BLACK: std_logic_vector(11 downto 0) := (others => '0');

end entity;

architecture tb of vga_controller_tb is

    signal clk, rst: std_logic := '1';
    signal hsync, vsync: std_logic;
    signal h_address: std_logic_vector(ADDR_LINE_LENGTH-1 downto 0);
    signal v_address: std_logic_vector(ADDR_COLUMN_LENGTH-1 downto 0);
	signal addressing: std_logic;
    signal rgb: std_logic_vector(11 downto 0);
	 
	 signal int_h_address, int_v_address: integer range 0 to 999;
    
begin

    uut: entity work.vga_controller(imp)
             generic map(
                     H_ADDRESSABLE => H_ADDRESSABLE,
                     H_FRONT_PORCH =>H_FRONT_PORCH,
                     H_SYNC => H_SYNC,
                     H_BACK_PORCH => H_BACK_PORCH,

                     V_ADDRESSABLE => V_ADDRESSABLE,
                     V_FRONT_PORCH => V_FRONT_PORCH,
                     V_SYNC => V_SYNC,
                     V_BACK_PORCH => V_BACK_PORCH)

               port map(sel => '0', 
                      rst => rst,
                      clk => clk,
                      hsync => hsync, 
                      vsync => vsync, 
                      h_address => h_address, 
                      v_address => v_address,
                      addressing => addressing,
                      rgb => rgb);
                
    int_h_address <= to_integer(unsigned(h_address));
    int_v_address <= to_integer(unsigned(v_address));
	 
	 clk <= not clk after CLOCK_PERIOD/2;

	 RESET:process
	 begin

		rst <= '1';
		wait for CLOCK_PERIOD*2;
		rst <= '0';
        
        report "End rst state.";

		wait;
	 end process;

	TEST_INITIAL_STATE:process	 
	begin

      wait until rst = '0';
	  
      assert (hsync = '1' and vsync = '1' and int_h_address = 0 and
      int_v_address = 0 and addressing = '0')
	  report "Incorrect state after reset."
	  severity failure;
	  
	  wait;
      
	end process;
	 
	TEST_HORIZONTAL_SYNC_AND_ADDRESS:process
	begin
        wait until rst = '0';  
    
        wait until int_h_address = H_ADDRESSABLE - 1;
        report "End first row."
        severity note;

        -- Garantees ModelSim evaluates signal on clk edge
        -- and not before
        wait until clk = '1'; 
        wait for CLOCK_PERIOD/2;

        report "Start TEST_VERTICAL_SYNC_AND_ADDRESS."
        severity note;

        
        h_sync_test: for n in natural range 0 to 3 loop
            
            report "TEST_HORIZONTAL_SYNC_AND_ADDRESS: " & natural'image(n)
            severity note;
        
            assert int_h_address = 0
            report "h_address incorrect end."
            severity failure;
        
			assert hsync = '1'
			report "Hsync low on start of horizontal period."
			severity failure;
			
			wait for H_FRONT_PORCH*CLOCK_PERIOD;
			
			assert hsync = '0'
			report "Hsync high on sync pulse."
			severity failure;
			
			wait for H_SYNC*CLOCK_PERIOD;
            
			assert hsync = '1'
			report "Sync pulse larger than expected."
			severity failure;
            
            wait for H_BACK_PORCH*CLOCK_PERIOD;
            
			assert int_h_address = 0
			report "Wrong h_address at horizontal address start."
			severity failure;
            
            wait for (H_ADDRESSABLE - 1)*CLOCK_PERIOD;
            
			assert int_h_address = H_ADDRESSABLE - 1
			report "Wrong h_address at horizontal address end."
			severity failure;
            
            wait for CLOCK_PERIOD;
            
            report "End TEST_HORIZONTAL_SYNC_AND_ADDRESS " & natural'image(n);
            
		end loop;
        wait;
	end process;
	
	TEST_VERTICAL_SYNC_AND_ADDRESS:process
	begin
        wait until rst = '0';      
		
        wait until int_v_address = V_ADDRESSABLE - 1;
        report "End frame."
        severity note;

        -- Garantees ModelSim evaluates signal on clk edge
        -- and not before
        wait for CLOCK_PERIOD/2;



        assert int_v_address = V_ADDRESSABLE - 1       
        report "Simulator ERROR."
        severity failure;


        wait for CLOCK_PERIOD*H_PERIOD;

        report "Start TEST_VERTICAL_SYNC_AND_ADDRESS."
        severity note;
        
		v_sync_test: for n in natural range 0 to 3 loop
        
            report "TEST_VERTICAL_SYNC_AND_ADDRESS: " & natural'image(n)
            severity note;

        
            wait for 1 ns;
            assert v_address = "0000000000"
            report "v_address incorrect end."
            severity failure;
        
			assert vsync = '1'
			report "vsync low on start of vertical period."
			severity failure;
			
			wait for V_FRONT_PORCH*H_PERIOD*CLOCK_PERIOD;
			
			assert vsync = '0'
			report "Vsync high on sync pulse."
			severity failure;
			
			wait for V_SYNC*H_PERIOD*CLOCK_PERIOD;            
			assert vsync = '1'
			report "Sync pulse larger than expected."
			severity failure;
            
            wait for V_BACK_PORCH*H_PERIOD*CLOCK_PERIOD;            
			assert int_v_address = 0
			report "Wrong v_address at vertical address start."
			severity failure;
            
            wait for V_ADDRESSABLE*H_PERIOD*CLOCK_PERIOD;            
            report "End TEST_VERTICAL_SYNC_AND_ADDRESS " & natural'image(n);
            
        end loop;

        wait;
	end process;
	
	TEST_HORIZONTAL_ADDRESS:process
	begin
		wait until addressing = '1';
        report "Start horizontal address test.";
        wait for CLOCK_PERIOD/2;

		horizontal_test: for n in natural range 0 to H_ADDRESSABLE - 1 loop
			assert n = int_h_address
			report "Horizontal address " & 
                    integer'image(int_h_address) &
                    " diverges from expected " &
                    natural'image(n)
			severity failure;
			wait for CLOCK_PERIOD;
		end loop;

        report "End horizontal address test.";
        wait;
	end process; 
	 
	TEST_VERTICAL_ADDRESS:process
	begin
		wait until addressing = '1';
        report "Start vertical address test.";
        wait for CLOCK_PERIOD/2;

		vertical_test: for n in natural range 0 to V_ADDRESSABLE - 1 loop
			assert n = int_v_address
            report "Vertical address " & 
                    integer'image(int_v_address) &
                    " diverges from expected " &
                    natural'image(n)
			severity failure;
			wait for H_PERIOD*CLOCK_PERIOD;
		end loop;

        report "End vertical address test.";
        wait;
	end process;
	
    TEST_DEAD_ZONE: process
    begin
    
      wait until rst = '0';
      wait for CLOCK_PERIOD/2;
      
      loop
      
      if addressing = '0' then
            
            assert rgb = BLACK
            report "Colors in dead zone"
            severity failure;
            
            wait for CLOCK_PERIOD;
        else
            wait until addressing = '0';
            wait for CLOCK_PERIOD/2;
        end if;
      end loop;
    end process;       
        
end architecture;
