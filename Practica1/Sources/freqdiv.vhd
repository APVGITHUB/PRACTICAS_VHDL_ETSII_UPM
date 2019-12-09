library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; --Interpreta operaciones matematicas



-- Lo que pone en mayusculas en el guion puede ir en minusculas 
-- respetar las sangrias y ponerlo bonito suma para el final 


entity freqdiv is
    PORT(
        clk          : IN std_logic;
        reset        : IN std_logic;
        Enable       : IN std_logic;
        Output_signal: OUT std_logic
        );
end freqdiv;

architecture behavioral of freqdiv is
-- el nombre de behavioral se puede cambiar por "cosa", pero se usa para estandarizar

-- zona para declarar
    constant MAX_1Hz :integer:= 125*10**6; -- **=elevar a
    signal cnt_1Hz : integer range 0 to MAX_1Hz-1; --usamos el 0 para contar
    -- para contadores usamos señales de tipo entero, por defecto son de 32 bits, pero la vamos a limitar para ahorrar memoria
    signal en_1Hz  : std_logic; -- señal habilitante
    signal ovf_1Hz : std_logic; -- señal de overflow

begin
-- zona para implementar

    process(clk,reset)
    begin
        if reset = '1' then
            cnt_1Hz <=0;
        elsif clk'event and clk='1' then
        -- si quisieramos resetear la señal sincrona (contadores) lo pondriamos aqui
            if en_1Hz = '1' then            -- verifica el contador de overflow
                if cnt_1Hz =MAX_1Hz-1 then
                    cnt_1Hz <=0;
                else 
                 cnt_1Hz <= cnt_1Hz +1;
                end if;
            end if;
        end if;
    end process;

    en_1Hz <= Enable;
    ovf_1Hz <= '1' when (cnt_1Hz = MAX_1Hz -1) and en_1Hz = '1' else '0';
    Output_signal <= ovf_1Hz;

end behavioral;
