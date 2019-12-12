library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
     port(
            clk : in std_logic;
            reset : in std_logic;
            A : in std_logic;
            B : in std_logic;
            Led: out std_logic
       );
end FSM;

architecture Behavioral of FSM is
    type state_t is (S_RST, S_B, S_BB, S_A, S_AB, S_ABB, S_AA, S_AAB, S_AABB);
    signal state : state_t;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            state <= S_RST;
        elsif clk'event and clk = '1' then
            case state is
                when S_RST =>
                    if B='1' then
                    state <= S_B;
                    end if;
                    if A='1' then 
                    state <= S_A;
                    end if;
               when S_B =>
                   if B='1' then
                   state <= S_BB;
                   end if;
                   if A='1' then
                   state <= S_AB;
                   end if;
               when S_A =>
                   if A='1' then
                   state <= S_AA;
                   end if;
                   if B='1' then
                   state <= S_AB;
                   end if;
               when S_AB =>
                   if B='1' then
                   state <= S_ABB;
                   end if;
                   if A='1' then
                   state <= S_AAB;
                   end if;
               when S_BB =>
                   if A='1' then 
                   state <= S_ABB;
                   end if;
               when S_ABB =>
                   if A='1' then
                   state <= S_AABB;
                   end if;
               when S_AA => 
                   if B='1' then
                   state <= S_AAB;
                   end if;
               when S_AAB =>
                   if B='1' then
                   state <= S_AABB;
                   end if;
               when S_AABB =>
                   
             end case;       
        end if;
    end process;
Led <= '1' when state = S_AABB else '0';
end Behavioral;
