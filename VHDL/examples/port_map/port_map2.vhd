library ieee;
use ieee.std_logic_1164.all;

-- -------------------------------------------
-- -- SUB_MODULE --

-- entity sub_module is
--     port(
--         x,y : in std_logic;
--         s: in std_logic;
--         z: out std_logic
--     );
-- end sub_module;


-- architecture behave of sub_module is
-- begin
--     process(x,y,s) is
--     begin
--         if (s = '0') then
--             z <= x;
--         else
--             z <= y;
--         end if;
--     end process;
-- end behave;

-- -------------------------------------------

-- TOP_MODULE --
-- top_module uses sub_modle inside its architecture

entity top_module is
    port(
        A,B,C,D : in std_logic;
        S0,S1 : in std_logic;
        Z : out std_logic
    );
end top_module;

architecture behave_top of top_module is
    component sub_module
    port(
        x,y : in std_logic;
        s : in std_logic;
        z : out std_logic
    );
    end component;

    signal m1,m2: std_logic;

    begin
        -- c1: sub_module port map(A,B,S0,m1);
        -- c2: sub_module port map(C,D,S0,m2);
        -- c3: sub_module port map(m1,m2,S1,Z);

        -- c1: sub_module port map(A=>x, B=>y, S0=>s, m1=>z);
        -- c2: sub_module port map(C=>x, D=>y, S0=>s, m2=>z);
        -- c3: sub_module port map(m1=>x, m2=>y, S1=>s, Z=>z);

        c1: sub_module port map(x=>A, y=>B, s=>S0, z=>m1);
        c2: sub_module port map(x=>C, y=>D, s=>S0, z=>m2);
        c3: sub_module port map(x=>m1, y=>m2, s=>S1, z=>Z);
end behave_top;