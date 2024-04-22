library ieee;
use ieee.std_logic_1164.all;

entity vga_controller is

    generic(
        H_ADDRESSABLE, H_FRON_PORCH, H_SYNC, H_BACH_PORCH: integer := ();
        V_ADDRESSABLE, V_FRON_PORCH, V_SYNC, V_BACV_PORCH: integer := ();

        H_COUNTER_LENGTH: integer := ;
        V_COUNTER_LENGTH: integer := ;

        ADDR_LINE_LENGTH: integer := ;
        ADDR_COLUMN_LENGTH: integer := ;
        
    );
    port(
        rst, clk: in std_logic;
        hsync, vsync, addr: out std_logic;
        r, g, b: out std_logic_vector(3 downto 0)
    );

end entity;

architecture imp of vga_controller is
    
    signal h_counter: unsigned(H_COUNTER_LENGTH-1 downto 0); 
    signal v_counter: unsigned(V_COUNTER_LENGTH-1 downto 0);

    signal h_address: unsigned(ADDR_LINE_LENGTH-1 downto 0);
    signal v_address: unsigned(ADDR_COLUMN_LENGTH-1 downto 0);

    signal v_enable: std_logic;
    signal v_addressable, h_addressable: std_logic;

    v_enable <= '1' when h_counter = H_ADDRESSABLE + H_FRON_PORCH + H_SYNC
                + H_BACH_PORCH - 1 else '0';

    h_address <= std_logic_vector(h_counter(ADDR_LINE_LENGTH-1 downto 0));
    v_address <= std_logic_vector(v_counter(ADDR_COLUMN_LENGTH-1 downto 0));

    h_counter: entity work.gen_counter(imp)
            generic map(LIMIT => H_ADDRESSABLE + H_FRON_PORCH + H_SYNC + H_BACH_PORCH,
                        COUNTER_LENGTH => H_COUNTER_LENGTH)
            port map(rst => rst,
                     clk => clk,
                     en => '1',
                     y => std_logic_vector(h_counter));

    h_sync: entity work.gen_sync(imp)
            generic map(LOW => H_ADDRESSABLE + H_FRONT_PORT,
                        PULSE => H_SYNC, 
                        COUNTER_LENGHT => H_COUNTER_LENGTH)
            port map(c => std_logic_vector(h_counter),
                     sync => hsync);

    h_addressable: entity work.gen_sync(imp)
            generic map(LOW => 0,
                        PULSE => H_ADDRESSABLE, 
                        COUNTER_LENGHT => H_COUNTER_LENGTH)
            port map(c => std_logic_vector(h_counter),
                     sync => h_addressable);

    v_counter: entity work.gen_counter(imp)
            generic map(LIMIT => V_ADDRESSABLE + V_FRON_PORCH + V_SYNC + V_BACV_PORCH,
                        COUNTER_LENGTH => V_COUNTER_LENGTH)
            port map(rst => rst,
                     clk => clk,
                     en => v_enable,
                     y => std_logic_vector(v_counter));

    v_sync: entity work.gen_sync(imp)
            generic map(LOW => V_ADDRESSABLE + V_FRONT_PORT,
                        PULSE => V_SYNC, 
                        COUNTER_LENGHT => V_COUNTER_LENGTH)
            port map(c => std_logic_vector(v_counter),
                    sync => vsync);
 
    v_addressable: entity work.gen_sync(imp)
            generic map(LOW => 0,
                        PULSE => V_ADDRESSABLE, 
                        COUNTER_LENGHT => V_COUNTER_LENGTH)
            port map(c => std_logic_vector(v_counter),
                     sync => v_addressable);      

end architecture;
