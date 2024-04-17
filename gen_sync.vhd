library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity gen_sync is
    generic(
    -- pixel count of each interval
        LOW, PULSE integer := (800 + 56, 120);
        COUNTER_LENGTH: integer := 11
    );

    port(
        c: in std_logic_vector(COUNTER_LENGTH-1 downto 0);
        sync: out std_logic
    );

begin

    assert LOW + PULSE <= 2**COUNTER_LENGTH
    report "Counter range doesnt reach total time range."
    severity failure;

end entity gen_sync;

architecture imp of gen_sync is
    signal count: unsigned(COUNTER_LENGTH-1 downto 0);
    signal 
begin
    count <= unsigned(c);

    with count select
        sync =>
            '1' when 0,
            '0' when LOW - 1,
            '1' when LOW+PULSE - 1,
            unaffected when others;

end architecture;
    

