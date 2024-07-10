library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_controller is

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
        rst, clk	: in std_logic;
		  rgb_test_en	: in std_logic;
		  
        hsync, vsync  : out std_logic;
        addressing_out: buffer std_logic;
		  
		  h_address_out : buffer std_logic_vector(ADDR_LINE_LENGTH - 1 downto 0);
        v_address_out : buffer std_logic_vector(ADDR_COLUMN_LENGTH - 1 downto 0);
		  
		  rgb_in			 : in std_logic_vector(RGB_LENGTH - 1 downto 0);
        rgb				 : out std_logic_vector(RGB_LENGTH - 1 downto 0)
    );
	 
	 begin
	 
	--	 ToDo:
	--	 Adicionar asserts para valores genéricos utilizados, com comentários do escopo 
	--	 de alterações viáveis ao componente.

end entity;

architecture imp of vga_controller is
	
    -- Conta pixels     
    signal h_counter: std_logic_vector(H_COUNTER_LENGTH-1 downto 0); 
    -- Conta rows
    signal v_counter: std_logic_vector(V_COUNTER_LENGTH-1 downto 0);

    -- Enable do v_counter
    signal v_enable: std_logic;
    
    -- Flags de zona ativa
    signal v_addressing, h_addressing: std_logic;
    signal v_not_addressing, h_not_addressing: std_logic;
	
    -- Enable de contador de endereço vertical
    signal v_addressing_enable: std_logic;
	 
	 -- Buffer de saída do indicador de zona ativa
	 signal addressing: std_logic; 
	 
	 -- Buffer de saída dos endereços horizontal e vertical
	 signal h_address : std_logic_vector(ADDR_LINE_LENGTH - 1 downto 0);
	 signal v_address : std_logic_vector(ADDR_COLUMN_LENGTH - 1 downto 0);

    
    -- Ponto do contador horizontal em que o contador vertical é ativo,
    -- utiliza H_FRONT_PORCH - 2 para descontar tanto o início em 0 
    -- quanto o delay entre enable e contagem, assim, a contagem ocorre
    -- junto ao inicio do pulso de hsync
    constant H_COUNTER_END: std_logic_vector(H_COUNTER_LENGTH - 1 downto 0) :=
    std_logic_vector(to_unsigned(H_FRONT_PORCH - 2, H_COUNTER_LENGTH));

begin

	 -- Conexão de sinais de buffer da saída
    addressing_out <= addressing;
    h_address_out  <= h_address;
    v_address_out  <= v_address;
	 
	 -- Indicador de zona ativa
    addressing <= v_addressing and h_addressing;
	 
 	 v_addressing <= not v_not_addressing;
	 h_addressing <= not h_not_addressing;

	 -- Enable contagem vertical por 1 pixel a cada ciclo da contagem horizontal
    v_enable <= '1' when h_counter = H_COUNTER_END else '0';
	
	 -- Enable para contador de endereço vertical
	 v_addressing_enable <= v_enable and v_addressing;
	 
	 -- Controlador de saída RGB
    pixel_data: entity work.rgb(imp) 
                generic map(v_bus => ADDR_COLUMN_LENGTH,
                            h_bus => ADDR_LINE_LENGTH,
                            data_bus => RGB_LENGTH)
    
                port map(clk => clk,
								 test_en => rgb_test_en,
					          en => addressing,
                         
                         h_address => h_address,
                         v_address => v_address,
								 
								 rgb_in => rgb_in,
                         rgb => rgb);


    -- Contagem de pixels para lógica de sincronismo horizontal
    h_count: entity work.gen_counter(imp)
            generic map(LIMIT => H_FRONT_PORCH + H_SYNC + H_BACK_PORCH + H_ADDRESSABLE,
                        COUNTER_LENGTH => H_COUNTER_LENGTH)
            port map(rst => rst,
                     clk => clk,
                     en => '1',
                     y => h_counter);	
							
    -- Gera indicador de sincronismo horizontal
    horizontal_sync: entity work.gen_sync(imp)
            generic map(HIGH_START_COUNT => H_FRONT_PORCH,
								LOW_COUNT =>  H_SYNC,
								TOTAL_COUNT => H_FRONT_PORCH + H_SYNC + H_BACK_PORCH + H_ADDRESSABLE,
                        COUNTER_LENGTH => H_COUNTER_LENGTH)
            port map(clk => clk,
                     rst => rst,
                     c => h_counter,
                     sync => hsync);

    -- Gera indicador de zone horizontal endereçável
    horizontal_address: entity work.gen_sync(imp)
            generic map(HIGH_START_COUNT => H_FRONT_PORCH + H_SYNC + H_BACK_PORCH,
								LOW_COUNT => H_ADDRESSABLE,
								TOTAL_COUNT => H_FRONT_PORCH + H_SYNC + H_BACK_PORCH + H_ADDRESSABLE,
                        COUNTER_LENGTH => H_COUNTER_LENGTH)
            port map(clk => clk,
							rst => rst,
							c => h_counter,
                     sync => h_not_addressing);

    -- Contagem de pixels endereçáveis 
    h_addr_counter: entity work.gen_counter(imp)
            generic map(LIMIT => H_ADDRESSABLE,
                        COUNTER_LENGTH => ADDR_LINE_LENGTH)
            port map(rst => rst,
                     clk => clk,
                     en => h_addressing,
                     y => h_address);

    -- Contagem de linhas para geradores de lógica de sincronismo vertical
    v_count: entity work.gen_counter(imp)
            generic map(LIMIT => V_FRONT_PORCH + V_SYNC + V_BACK_PORCH + V_ADDRESSABLE,
                        COUNTER_LENGTH => V_COUNTER_LENGTH)
            port map(rst => rst,
                     clk => clk,
                     en => v_enable,
                     y => v_counter);

    -- Gera indicador de sincronia vertical
    vertical_sync: entity work.gen_sync(imp)
            generic map(HIGH_START_COUNT => V_FRONT_PORCH,
								LOW_COUNT => V_SYNC,
								TOTAL_COUNT => V_FRONT_PORCH + V_SYNC + V_BACK_PORCH + V_ADDRESSABLE,
                        COUNTER_LENGTH => V_COUNTER_LENGTH)
            port map(clk => clk,
							rst => rst,
							c => v_counter,
                     sync => vsync);
 
    -- Gera indicador de zona vertical endereçável
    vertical_address: entity work.gen_sync(imp)
            generic map(HIGH_START_COUNT => V_FRONT_PORCH + V_SYNC + V_BACK_PORCH,
								LOW_COUNT => V_ADDRESSABLE,
								TOTAL_COUNT => V_FRONT_PORCH + V_SYNC + V_BACK_PORCH + V_ADDRESSABLE,
                        COUNTER_LENGTH => V_COUNTER_LENGTH)
            port map(clk => clk,
							rst => rst,
							c => v_counter,
                     sync => v_not_addressing);      

    -- Contagem de linhas endereçáveis 
    v_addr_counter: entity work.gen_counter(imp)
            generic map(LIMIT => V_ADDRESSABLE,
                        COUNTER_LENGTH => ADDR_COLUMN_LENGTH)
            port map(rst => rst,
                     clk => clk,
                     en => v_addressing_enable,
                     y => v_address);

end architecture;
