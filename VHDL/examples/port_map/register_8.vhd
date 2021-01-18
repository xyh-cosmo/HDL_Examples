library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_arith.all;

entity register_8 is 
    port(
        clk, reset : in bit;
        A : in bit_vector(7 downto 0);
        B : out bit_vector(7 downto 0)
    );
end register_8;

architecture behave of register_8 is
begin
    process(clk, reset)
    begin
        if reset = '1' then 
            B <= "00000000";
        elsif (clk 'event and clk='1') then
            B <= A;
        end if;
    end process;
end behave;
