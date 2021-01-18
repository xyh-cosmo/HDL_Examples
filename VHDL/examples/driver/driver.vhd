---------------------------------------
-- driver
--
-- two descriptions provided
---------------------------------------

library ieee;
use ieee.std_logic_1164.all;

---------------------------------------

entity Driver is
    port(
        x: in std_logic;
        F: out std_logic
    );
end Driver;


---------------------------------------

architecture behave1 of Driver is
begin
    process (x) is
    begin
        -- compare to truth table
        if (x='1') then
            F <= '0';
        else
            F <= '1';
        end if;
    end process;
end behave1;

-- architecture behave2 of Driver is
-- begin
--     F <= x;
-- end behave2;