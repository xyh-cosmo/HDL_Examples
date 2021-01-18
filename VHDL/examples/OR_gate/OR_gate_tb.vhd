library ieee;
use ieee.std_logic_1164.all;

entity OR_gate_tb is
end OR_gate_tb;


architecture test of OR_gate_tb is
    component OR_gate
    port(
        x : in std_logic;
        y : in std_logic;
        F : out std_logic
    );
    end component;

    signal xs, ys, Fs : std_logic;

begin
    og : OR_gate port map(x=>xs, y=>ys, F=>Fs);
    
    process begin
        -- xs <= 'X';
        -- ys <= 'X';

        xs <= '0';
        ys <= '0';
        wait for 5 ns;

        xs <= '1';
        ys <= '0';
        wait for 5 ns;

        xs <= '1';
        ys <= '1';
        wait for 5 ns;

        xs <= '0';
        ys <= '1';
        wait for 5 ns;

        assert false report "reached end of test.";
        wait;
    end process;
end test;