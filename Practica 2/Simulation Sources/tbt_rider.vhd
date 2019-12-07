
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tbt_rider is
end tbt_rider;



architecture Behavioral of tbt_rider is

component rider is
    Port (
            clk : in std_logic;
            reset : in std_logic;
            start : in std_logic;
            leds : out std_logic_vector(7 downto 0)
           
    );
end component;

    signal clk_tb : std_logic;
    signal reset_tb : std_logic;
    signal start_tb : std_logic;
    signal leds_tb : std_logic_vector(7 downto 0);

    constant clk_period : time := 8 ns;
    
begin

clk_stimuli:process
begin
    clk_tb<='1';
    wait for clk_period/2;
    clk_tb<='0';
    wait for clk_period/2;
end process;

control_stimuli: process
begin
    reset_tb<='1';
    start_tb<='0';
    wait for 10*clk_period;
    reset_tb<='0';
    start_tb<='0';
    wait for 10*clk_period;
    reset_tb<='0';
    start_tb<='1';
    wait for 100*clk_period;
    reset_tb<='0';
    start_tb<='0';
    wait;
end process;

ControlLeds: rider
    Port Map (
                clk => clk_tb ,
                reset=> reset_tb ,
                start=> start_tb ,
                leds => leds_tb 
              );


end Behavioral;

