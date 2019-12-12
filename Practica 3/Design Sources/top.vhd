-- PARA JUNTAR TODOS LOS COMPONENTES

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port (
        clk : in std_logic;
        reset : in std_logic;
        Boton_A : in std_logic;
        Boton_B : in std_logic;
        Led : out std_logic
    );
end top;

architecture Behavioral of top is
    
    --Declaracion del componente "Antirrebotes"
    component Antirrebotes is
    port(
         clk : in std_logic;
         reset : in std_logic;
         boton : in std_logic;
         filtrado: out std_logic
       );
    end component;
    
    --Declaracion del componente "FSM"
    component FSM is
        port(
             clk : in std_logic;
             reset : in std_logic;
             A : in std_logic;
             B : in std_logic;
             Led: out std_logic
        );
     end component;
     
    
    --Declaracion de señales internas
    signal A : std_logic;
    signal B : std_logic;
    
begin

    ar_a: Antirrebotes
    port map (
        clk      => clk,
        reset    => reset,
        boton    => Boton_A,
        filtrado => A
    );
    
    ar_b: Antirrebotes
    port map (
        clk      => clk,
        reset    => reset,
        boton    => Boton_B,
        filtrado => B
     );
    
    fsm_i: FSM
    port map(
        clk => clk,
        reset => reset,
        A => A,
        B => B,
        Led => Led
    );
        
end Behavioral;
