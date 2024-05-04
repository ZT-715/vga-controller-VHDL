library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_controller is

    generic(
        H_ADDRESSABLE: natural := 800;
        H_FRON_PORCH: natural := 56; 
        H_SYNC: natural := 120; 
        H_BACH_PORCH: natural := 64;

        V_ADDRESSABLE: natural := 600; 
        V_FRON_PORCH: natural := 37; 
        V_SYNC: natural := 6; 
        V_BACV_PORCH: natural := 23;

        H_COUNTER_LENGTH: natural := 11;
        V_COUNTER_LENGTH: natural := 10;

        ADDR_LINE_LENGTH: natural := 10;
        ADDR_COLUMN_LENGTH: natural := 10
    );
    port(
        rst, clk: in std_logic;
        hsync, vsync: out std_logic;
        h_address: out std_logic_vector(ADDR_LINE_LENGTH-1 downto 0);
        v_address: out std_logic_vector(ADDR_COLUMN_LENGTH-1 downto 0);
        r, g, b: out std_logic_vector(3 downto 0)
    );

end entity;

architecture imp of vga_controller is
    
    signal h_counter: std_logic_vector(H_COUNTER_LENGTH-1 downto 0); 
    signal v_counter: std_logic_vector(V_COUNTER_LENGTH-1 downto 0);

    signal v_enable: std_logic;
    signal v_addressing, h_addressing: std_logic;

begin

    r <= (others => '1') ;
    g <= (others => '1');
    b <= (others => '1');

    -- Enable contagem vertical por 1 pixel a cada ciclo da contagem horizontal
    v_enable <= '1' when unsigned(h_counter) = 0 else '0';

--     h_address <= std_logic_vector(h_counter(ADDR_LINE_LENGTH-1 downto 0));
--     v_address <= std_logic_vector(v_counter(ADDR_COLUMN_LENGTH-1 downto 0));

    -- Contagem de pixels para lógica de sincronismo horizontal
    h_count: entity work.gen_counter(imp)
            generic map(LIMIT => H_ADDRESSABLE + H_FRON_PORCH + H_SYNC + H_BACH_PORCH,
                        COUNTER_LENGTH => H_COUNTER_LENGTH)
            port map(rst => rst,
                     clk => clk,
                     en => '1',
                     y => h_counter);

    -- Gera indicador de sincronismo horizontal
    horizontal_sync: entity work.gen_sync(imp)
            generic map(LOW =>  H_SYNC,
                        COUNTER_LENGTH => H_COUNTER_LENGTH)
            port map(clk => clk,
							rst => rst,
							c => std_logic_vector(h_counter),
                     sync => hsync);

    -- Gera indicador de zone horizontal endereçável
    horizontal_address: entity work.gen_sync(imp)
            generic map(LOW => H_FRON_PORCH + H_SYNC + H_BACH_PORCH,
                        COUNTER_LENGTH => H_COUNTER_LENGTH)
            port map(clk => clk,
							rst => rst,
							c => std_logic_vector(h_counter),
                     sync => h_addressing);

    -- Contagem de pixels endereçáveis 
    h_addr_counter: entity work.gen_counter(imp)
            generic map(LIMIT => V_ADDRESSABLE,
                        COUNTER_LENGTH => ADDR_LINE_LENGTH)
            port map(rst => rst,
                     clk => clk,
                     en => h_addressing,
                     y => h_address);

    -- Contagem de linhas para geradores de lógica de sincronismo vertical
    v_count: entity work.gen_counter(imp)
            generic map(LIMIT => V_ADDRESSABLE + V_FRON_PORCH + V_SYNC + V_BACV_PORCH,
                        COUNTER_LENGTH => V_COUNTER_LENGTH)
            port map(rst => rst,
                     clk => clk,
                     en => v_enable,
                     y => (v_counter));

    -- Gera indicador de sincronia vertical
    vertical_sync: entity work.gen_sync(imp)
            generic map(LOW =>  V_SYNC, 
                        COUNTER_LENGTH => V_COUNTER_LENGTH)
            port map(clk => clk,
							rst => rst,
							c => (v_counter),
                     sync => vsync);
 
    -- Gera indicador de zona vertical endereçável
    vertical_address: entity work.gen_sync(imp)
            generic map(LOW => V_FRON_PORCH + V_SYNC + V_BACV_PORCH, 
                        COUNTER_LENGTH => V_COUNTER_LENGTH)
            port map(clk => clk,
							rst => rst,
							c => (v_counter),
                     sync => v_addressing);      

    -- Contagem de linhas endereçáveis 
    v_addr_counter: entity work.gen_counter(imp)
            generic map(LIMIT => H_ADDRESSABLE,
                        COUNTER_LENGTH => ADDR_COLUMN_LENGTH)
            port map(rst => rst,
                     clk => clk,
                     en => v_addressing,
                     y => v_address);

end architecture;
