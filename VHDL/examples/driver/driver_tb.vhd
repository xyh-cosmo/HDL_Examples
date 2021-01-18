library ieee;
use ieee.std_logic_1164.all;

entity driver_tb is
    -- port(
    --     a: in std_logic;
    --     b: out std_logic
    -- );
end driver_tb;

architecture test of driver_tb is
    component driver
    port(
        x: in std_logic;
        F: out std_logic
    );
    end component;

    signal xt, Ft : std_logic;

begin
    -- dr : driver port map(xt=>x, Ft=>F); -- this does not work !!!!
    dr : driver port map(x=>xt, F=>Ft);

    process begin
        xt <= '0';
        wait for 1 ps;

        xt <= '1';
        wait for 1 ps;

        assert false report "reached end of test.";
        wait;
    end process;
end test;