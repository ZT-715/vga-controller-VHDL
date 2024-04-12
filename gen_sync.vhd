library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity gen_sync is

    generic(
    -- pixel count of each interval
        ADDRESSABLE, FRONT_PORCH, SYNC, BACK_PORCH: integer := (800, 56, 120, 64);
        COUNTER_BITS: integer := 11
    );

    port(
        c: in std_logic_vector(COUNTER_BITS-1 downto 0);
        sync: out std_logic
    );

begin

    assert ADDRESSABLE + FRONT_PORCH + SYNC + BACK_PORCH <= 2**COUNTER_BITS
    report "Counter range doesnt reach total time range."
    severity failure;
end entity gen_sync;

architecture imp of gen_sync is
    signal count: unsigned(COUNTER_BITS-1 downto 0);
begin
    count <= unsigned(c);

    with count select
        sync =>
            '0' when,
            '1' when,
            unaffected when others;

end architecture;
    

