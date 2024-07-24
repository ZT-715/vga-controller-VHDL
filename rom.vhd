library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    generic(
        H_BUS : natural := 7;
        V_BUS : natural := 6;
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

    assert H_BUS > 0 and V_BUS > 0 and VALUE_LENGTH > 0
    report "All SLVs must be of size 1 or greater."
    severity failure;

    assert 2**V_BUS - 1 >= V_ADDRESS_END
    report "V_ADDRESS_MAX rgb_value is less than the V_BUS allows."
    severity failure;
    
    assert 2**H_BUS - 1 >= H_ADDRESS_END
    report "H_ADDRESS_MAX rgb_value is less than the H_BUS allows."
    severity failure;

end entity; 

architecture rgb_image_50x32_12bits of rom is
    signal int_h_address: natural range 0 to H_ADDRESS_END;
    signal int_v_address: natural range 0 to V_ADDRESS_END;

    constant BLACK   : std_logic_vector(VALUE_LENGTH - 1 downto 0) := "000000000000";
    constant WHITE   : std_logic_vector(VALUE_LENGTH - 1 downto 0) := "111111111111";
    constant GREY    : std_logic_vector(VALUE_LENGTH - 1 downto 0) := "110011001100";
    constant L_BROWN : std_logic_vector(VALUE_LENGTH - 1 downto 0) := "101010001000";
    constant BROWN   : std_logic_vector(VALUE_LENGTH - 1 downto 0) := "100010001010";
    constant D_BROWN : std_logic_vector(VALUE_LENGTH - 1 downto 0) := "011011001011";

    constant H_SHIFT: natural := 12;
    constant V_SHIFT: natural := 12;
    
    constant RGB_SHIFT: natural := (2**VALUE_LENGTH - 1)/(H_ADDRESS_END*V_ADDRESS_END);
begin
    int_h_address <= to_integer(unsigned(h_address));
    int_v_address <= to_integer(unsigned(v_address));


    IMAGE: process(int_h_address, int_v_address)
    begin
            
            -- TODO
            -- Adicionar degrade RGB do endereço 0 ao 1850 pare exibir blocos
            
            -- Fundo			
            --rgb_value <= std_logic_vector(to_unsigned(int_h_address*int_v_address*RGB_SHIFT, VALUE_LENGTH));
            rgb_value <= std_logic_vector(to_unsigned(H_ADDRESS_END*V_ADDRESS_END*RGB_SHIFT, VALUE_LENGTH));
            
            -- Linha fumaça 1
            if (int_v_address >= 0 + V_SHIFT) and (int_v_address <= 2 + V_SHIFT) then
                if (int_h_address = 3 + H_SHIFT) or (int_h_address = 3 + 2 + H_SHIFT) then
                    rgb_value <= WHITE;
                end if;
            end if;          
            
            -- Linha fumaça 2
            if (int_v_address >= 3 + V_SHIFT) and (int_v_address <= 5 + V_SHIFT) then
                if (int_h_address = 4 + H_SHIFT) or (int_h_address = 4 + 2 + H_SHIFT) then
                    rgb_value <= GREY;
                end if;
            end if;          
                   
            
            -- Linha Chícara1
            if (int_v_address = 0 + 10 + V_SHIFT) then
                if (int_h_address = 1 + H_SHIFT) or (int_h_address = 8 + H_SHIFT) then
                    rgb_value <= BLACK;
                elsif (int_h_address > 1 + H_SHIFT and int_h_address < 8 + H_SHIFT) then
                    rgb_value <= BROWN;
                end if;
            end if;
            
            -- Linha Chícara2
            if (int_v_address = 1 + 10 + V_SHIFT) then
                if (int_h_address = 0 + H_SHIFT) or 
                   (int_h_address >= 2 + H_SHIFT and int_h_address <= 7 + H_SHIFT) or
                   (int_h_address = 9 + H_SHIFT) then
                    rgb_value <= BLACK;
                elsif int_h_address = 1 + H_SHIFT then
                    rgb_value <= WHITE;
                elsif int_h_address = 8 + H_SHIFT then
                    rgb_value <= GREY;
                end if;
            end if;
            
             -- Linha Chícara2 - 6
            if (int_v_address >= 2 + 10 + V_SHIFT) and (int_v_address <= 5 + 10 + V_SHIFT) then
                if (int_h_address = 0 + H_SHIFT) or (int_h_address = 9 + H_SHIFT) then
                    rgb_value <= BLACK;
                elsif (int_h_address >= 1 + H_SHIFT) and (int_h_address <= 6 + H_SHIFT) then
                    rgb_value <= WHITE;
                elsif (int_h_address = 7 + H_SHIFT) or (int_h_address = 8 + H_SHIFT) then
                    rgb_value <= GREY;
                end if;
            end if;          

             -- Linha Chícara7
            if (int_v_address = 6 + 10 + V_SHIFT) then
                if (int_h_address = 1 + H_SHIFT) or (int_h_address = 8 + H_SHIFT) then
                    rgb_value <= BLACK;
                elsif int_h_address >= 2 + H_SHIFT and int_h_address <= 6 + H_SHIFT then
                    rgb_value <= WHITE;
                elsif int_h_address = 7 + H_SHIFT then
                    rgb_value <= GREY;
                end if;
            end if;                      

             -- Linha Chícara8
            if (int_v_address = 7 + 10 + V_SHIFT) then
                    rgb_value <= BLACK;
            end if;   
            
            -- Bordas
            if (int_h_address = 37) or (int_h_address = 38) then
                rgb_value <= BLACK;
            end if;
            
            
            -- Bordas
            if (int_v_address = 37) or (int_v_address = 38) then
                rgb_value <= BLACK;
            end if;
    end process;

    
end architecture;

    
