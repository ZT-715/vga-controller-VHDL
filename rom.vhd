library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    generic(
        H_BUS : natural := 6;
        V_BUS : natural := 4;
        VALUE_LENGTH : natural := 12;
        H_ADDRESS_END : natural := 50;
        V_ADDRESS_END : natural := 37
    );
    port(
        clk : in std_logic;
        h_address   : in std_logic_vector(H_BUS - 1 downto 0);
        v_address   : in std_logic_vector(V_BUS - 1 downto 0);
        rgb_value   : out std_logic_vector(VALUE_LENGTH - 1 downto 0)
    );
begin

    assert H_BUS > 0 and V_BUS > 0 and VALUE_LENGHT > 0
    report "All SLVs must be of size 1 or greater."
    severity failure;

    assert 2**V_BUS - 1 >= V_ADDRESS_MAX
    report "V_ADDRESS_MAX rgb_value is less than the V_BUS allows."
    severity failure;
    
    assert 2**H_BUS - 1 >= H_ADDRESS_MAX
    report "H_ADDRESS_MAX rgb_value is less than the H_BUS allows."
    severity failure;

end entity; 

architecture rgb_image_50x32_12bits of rom is
    signal int_h_address: natural range 0 to H_ADDRESS_END;
    signal int_v_address: natural range 0 to V_ADDRESS_END;

    constant BLACK   : std_logic_vector(VALUE_LENGTH - 1 downto 0) := "000000000000";
    constant WHITE   : std_logic_vector(VALUE_LENGTH - 1 downto 0) := "111111111111";
    constant GREY    : std_logic_vector(VALUE_LENGTH - 1 downto 0) := "100010001000";
    constant L_BROWN : std_logic_vector(VALUE_LENGTH - 1 downto 0) := "101010001000";
    constant BROWN   : std_logic_vector(VALUE_LENGTH - 1 downto 0) := "100010001010";
    constant D_BROWN : std_logic_vector(VALUE_LENGTH - 1 downto 0) := "011011001011";

    constant H_SHIFT: natural := 0;
    constant V_SHIFT: natural := 0;
begin
    int_h_address <= to_integer(unsigned(h_address));
    int_v_address <= to_integer(unsigned(v_address));


    IMAGE: process(clk, int_h_address, int_v_address)
    begin
        if rising_edge(clk) then
            
				-- TODO
				-- Adicionar degrade RGB do endereço 0 ao 1850 pare exibir blocos
				
				-- Fundo			
            rgb_value <= WHITE;

            -- LINHAS PRETAS
            -- Linha 1
            if (int_v_address = 0 + V_SHIFT) and (int_h_address >= 5 + H_SHIFT) and (int_h_address <= 12 + H_SHIFT) then
                rgb_value <= BLACK;
            -- Linha 2
            elsif (int_v_address = 1 + V_SHIFT) and 
                  (((int_h_address >= 3 + H_SHIFT) and (int_h_address <= 4 + H_SHIFT)) or
                   ((int_h_address >= 13 + H_SHIFT) and (int_h_address <= 14 + H_SHIFT))) then
                rgb_value <= BLACK;
            -- Linha 3
            elsif (int_v_address = 2 + V_SHIFT) and 
                  ((int_h_address = 2 + H_SHIFT) or (int_h_address = 15 + H_SHIFT)) then
                rgb_value <= BLACK;
            -- Linha 4
            elsif (int_v_address = 3 + V_SHIFT) and 
                  ((int_h_address = 1 + H_SHIFT) or (int_h_address = 16 + H_SHIFT)) then
                rgb_value <= BLACK;
            -- Linha 5
            elsif (int_v_address = 4 + V_SHIFT) and (int_h_address = 1 + H_SHIFT) then
                rgb_value <= BLACK;
            elsif (int_v_address = 5 + V_SHIFT) and (int_h_address >= 16 + H_SHIFT) and (int_h_address <= 18 + H_SHIFT) then
                rgb_value <= BLACK;
            -- Lines 6 to 20 
            elsif (int_h_address = 0 + H_SHIFT or int_h_address = 17 + H_SHIFT) and 
                  (int_v_address >= 5 + V_SHIFT) and (int_v_address <= 20 + V_SHIFT) then
                rgb_value <= BLACK;
            -- Linha 21
            elsif (int_v_address = 20 + V_SHIFT) and 
                  ((int_h_address = 1 + H_SHIFT) or (int_h_address = 16 + H_SHIFT)) then
                rgb_value <= BLACK;
            -- Linha 22
            elsif (int_v_address = 21 + V_SHIFT) and 
                  ((int_h_address = 2 + H_SHIFT) or (int_h_address = 17 + H_SHIFT)) then
                rgb_value <= BLACK;
            -- Linha 23
            elsif (int_v_address = 22 + V_SHIFT) and 
                  (((int_h_address = 3 + H_SHIFT) or (int_h_address = 18 + H_SHIFT)) or
                   ((int_h_address = 4 + H_SHIFT) or (int_h_address = 19 + H_SHIFT))) then
                rgb_value <= BLACK;
            -- Linha 24
            elsif (int_v_address = 23 + V_SHIFT) and 
                  (int_h_address >= 5 + H_SHIFT) and (int_h_address <= 12 + H_SHIFT) then
                rgb_value <= BLACK;
            

            -- CIRCULO
            elsif (int_v_address >= 3 + V_SHIFT) and (int_v_address <= 7 + V_SHIFT) and
                  ((int_v_address = 3 + V_SHIFT and int_h_address >= 7 + H_SHIFT and int_h_address <= 10 + H_SHIFT) or
                   (int_v_address = 4 + V_SHIFT and int_h_address >= 5 + H_SHIFT and int_h_address <= 11 + H_SHIFT) or
                   (int_v_address >= 5 + V_SHIFT and int_v_address <= 6 + V_SHIFT and int_h_address >= 4 + H_SHIFT and int_h_address <= 11 + H_SHIFT) or
                   (int_v_address = 7 + V_SHIFT and int_h_address >= 5 + H_SHIFT and int_h_address <= 12 + H_SHIFT)) then
                rgb_value <= BLACK;

            -- FIM PRETO
            -- CIRCULO MARROM ESCURO
            elsif (int_v_address >= 3 + V_SHIFT) and (int_v_address <= 6 + V_SHIFT) and
                  ((int_v_address = 3 + V_SHIFT and int_h_address >= 7 + H_SHIFT and int_h_address <= 10 + H_SHIFT) or
                   (int_v_address = 4 + V_SHIFT and int_h_address >= 5 + H_SHIFT and int_h_address <= 11 + H_SHIFT) or
                   (int_v_address >= 5 + V_SHIFT and int_v_address <= 6 + V_SHIFT and int_h_address >= 4 + H_SHIFT and int_h_address <= 11 + H_SHIFT) or
                   (int_v_address = 6 + V_SHIFT and int_h_address >= 5 + H_SHIFT and int_h_address <= 12 + H_SHIFT)) then
                rgb_value <= D_BROWN;
	    -- CIRCULO MARROM ESCURO

	    -- DETALHES MARROM

        -- FIM DETALHES MARROM

	    -- DETALHES MARROM CALRO

        -- FIM DETALHES MARROM CLARO

            end if;
        end if;
    end process;

    
end architecture;

    
