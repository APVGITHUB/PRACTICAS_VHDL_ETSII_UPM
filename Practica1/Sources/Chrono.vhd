library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; --Interpreta operaciones matematicas

entity Chrono is
    port(
        clk             : in std_logic;
        reset           : in std_logic;
        segundos        : out std_logic_vector(3 downto 0);
        dec_segundos    : out std_logic_vector(3 downto 0);
        minutos         : out std_logic_vector(3 downto 0);
        dec_minutos     : out std_logic_vector(3 downto 0)
        );
end Chrono;

architecture behavioral of Chrono is
 
---- Divisor de frecuencias 1 ----------    
    constant MAX_1Hz :integer:= 125; --*10**6; -- **=elevar a
    signal cnt_1Hz : integer range 0 to MAX_1Hz-1; --usamos el 0 para contar
    -- para contadores usamos señales de tipo entero, por defecto son de 32 bits, pero la vamos a limitar para ahorrar memoria
    signal en_1Hz  : std_logic; -- señal habilitante
    signal ovf_1Hz : std_logic; -- señal de overflow

---- contadores BCD------------------------
    signal cnt_s  : unsigned(3 downto 0);     -- ahora si que se cuantos bits necesito, antes no lo sabia por eso lo declaraba con rango, con el unsigned se pueden hacer suma resta y multiplicacion 
    signal en_s   : std_logic;
    signal ovf_s  : std_logic;
    
    signal cnt_ds : unsigned(3 downto 0);     -- ahora si que se cuantos bits necesito, antes no lo sabia por eso lo declaraba con rango, con el unsigned se pueden hacer suma resta y multiplicacion 
    signal en_ds  : std_logic;
    signal ovf_ds : std_logic;
    
    signal cnt_m  : unsigned(3 downto 0);     -- ahora si que se cuantos bits necesito, antes no lo sabia por eso lo declaraba con rango, con el unsigned se pueden hacer suma resta y multiplicacion 
    signal en_m   : std_logic;
    signal ovf_m  : std_logic;
    
    signal cnt_dm : unsigned(3 downto 0);     -- ahora si que se cuantos bits necesito, antes no lo sabia por eso lo declaraba con rango, con el unsigned se pueden hacer suma resta y multiplicacion 
    signal en_dm  : std_logic;
    signal ovf_dm : std_logic;
--------------------------------------------    
    
    
     
 begin 
 ------ DIVISOR DE FRECUENCIAS 1 -----------------
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

    en_1Hz <= '1';
    ovf_1Hz <= '1' when (cnt_1Hz = MAX_1Hz -1) and en_1Hz = '1' else '0';
    
------- FIN DE DIVISOR DE FRECUENCIAS 1 ----------------------------    
    
   
----- CONTADORES BCD-----------------------------------------------------------
 
    process (clk,reset)
    begin
        if reset ='1' then
            cnt_s <= (others => '0');
        elsif clk'event and clk='1' then
            if en_s ='1' then
                if cnt_s =9 then
                    cnt_s <= (others => '0');
                else
                    cnt_s <= cnt_s +1;
                end if;
            end if;
        end if;
    end process;
 -------------------------------------------
     process (clk,reset)
     begin
         if reset ='1' then
             cnt_ds <= (others => '0');
         elsif clk'event and clk='1' then
             if en_ds ='1' then
                 if cnt_ds = 5 then
                     cnt_ds <= (others => '0');
                 else
                     cnt_ds <= cnt_ds +1;
                 end if;
             end if;
         end if;
     end process;
  -----------------------------------------------   
       process (clk,reset)
       begin
          if reset ='1' then
              cnt_m <= (others => '0');
          elsif clk'event and clk='1' then
             if en_m ='1' then
                if cnt_m = 9 then
                    cnt_m <= (others => '0');
                else
                      cnt_m <= cnt_m +1;
                end if;
             end if;
           end if;
         end process;
----------------------------------------------
    process (clk,reset)
        begin
            if reset ='1' then
                cnt_dm <= (others => '0');
           elsif clk'event and clk='1' then
              if en_dm ='1' then
                 if cnt_dm = 5 then
                     cnt_dm <= (others => '0');
                 else
                     cnt_dm <= cnt_dm +1;
                 end if;
              end if;
           end if;
    end process;
----------------------------------------------------------
      en_s  <= ovf_1Hz;
      ovf_s <= '1' when (cnt_s=9) and en_s='1' else '0';
      segundos <= std_logic_vector(cnt_s);
        
      en_ds <= ovf_s;
      ovf_ds <= '1' when (cnt_ds=5) and en_ds ='1' else '0';
      dec_segundos <= std_logic_vector(cnt_ds);    
      
      en_m <= ovf_ds;
      ovf_m <= '1' when (cnt_m=9) and en_m ='1' else '0';
      minutos <= std_logic_vector(cnt_m);
      
      en_dm <= ovf_m;
      ovf_dm <= '1' when (cnt_dm=5) and en_dm ='1' else '0';
      dec_minutos <= std_logic_vector(cnt_dm);
      
------- FIN BCD--------------------------------------------
   
end behavioral;
    
