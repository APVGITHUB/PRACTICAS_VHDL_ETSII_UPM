


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rider is
Port (
        clk : in std_logic;
        reset : in std_logic;
        start : in std_logic;
        leds : out std_logic_vector(7 downto 0)
       
);
end rider;

architecture Behavioral of rider is

constant  Max: integer:=8929571/1000-1;
signal contador_Hz : integer range 0 to Max;
signal divisor: std_logic;
signal contador_7 : unsigned (3 downto 0);
signal sentido : std_logic; --0 subida y 1 bajada
signal enable: std_logic;
begin

--enable
process(clk,reset)
begin
if reset ='1' then
        enable <= '0';
 elsif clk'event and clk ='1' then
     if start='1' then
     enable <= '1';
     end if;
 end if;
end process;

-- Divisor de Frecuencia (14 pulsos por segundo)
process(clk,reset)
begin

if reset ='1' then
        contador_Hz <= 0;
   elsif clk'event and clk ='1' then
        if enable = '1' then
            if contador_Hz < Max then 
                contador_Hz <= contador_Hz +1;
            else
              contador_Hz <= 0; 
            end if;
        end if;
    end if;
    
end process;

divisor<= '1' when contador_Hz = Max else '0';


-- Contador Registro
process(clk, reset)
begin
if reset='1' then
    contador_7<= (others=> '0');
elsif clk'event and clk = '1' then
        if divisor ='1' then
            if sentido= '0' then
            contador_7 <= contador_7 + 1;
            elsif sentido= '1' then
            contador_7 <= contador_7 - 1;
            end if;    
        end if;  
        if contador_7= 6 or contador_7=1 then
        sentido <= not sentido;
        end if;  
end if;       


end process;

-- Lógica de decodificación

with contador_7 select
leds<=  "10000000" when "0001",
        "01000000" when "0010",
        "00100000" when "0011",
        "00010000" when "0100",
        "00001000" when "0101",
        "00000100" when "0110",
        "00000010" when "0111",
        "00000001" when "1000",
        "--------" when others
        ;
       
-- 
       
       
       
end Behavioral;

