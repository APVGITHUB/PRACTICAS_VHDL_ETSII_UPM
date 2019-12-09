library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; --Interpreta operaciones matematicas

entity Practica1 is
    port(
        clk             : in std_logic;
        reset           : in std_logic;
        segmentos       : out std_logic_vector(6 downto 0);
        selector        : out std_logic_vector(3 downto 0)   
        );
end Practica1;



 architecture behavioral of Practica1 is
 
---- Divisor de frecuencias 1 ----------    
    constant MAX_1Hz :integer:= 125*10**6; -- **=elevar a
    signal cnt_1Hz : integer range 0 to MAX_1Hz-1; --usamos el 0 para contar
    -- para contadores usamos señales de tipo entero, por defecto son de 32 bits, pero la vamos a limitar para ahorrar memoria
    signal en_1Hz  : std_logic; -- señal habilitante
    signal ovf_1Hz : std_logic; -- señal de overflow
    
---- Divisor de frecuencias 2 ------------
    constant MAX_4KHz :integer:= 31250;
    signal cnt_4KHz : integer range 0 to MAX_4KHz-1;
    signal en_4KHz  : std_logic;
    signal ovf_4KHz : std_logic;    


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
    
    
-----Multiplexor----------------------    
    signal interna :  unsigned(3 downto 0);
    signal C : unsigned(1 downto 0);
    
----Contador de 2 bits------------

    signal cnt_2 : unsigned(1 downto 0);
    signal en_2 : std_logic;
    
----Decodificadores---------

    signal seg : std_logic_vector(6 downto 0);
    signal sel : std_logic_vector(3 downto 0);
    
     
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
       
      en_ds <= ovf_s;
      ovf_ds <= '1' when (cnt_ds=5) and en_ds ='1' else '0';
    
      en_m <= ovf_ds;
      ovf_m <= '1' when (cnt_m=9) and en_m ='1' else '0';

      en_dm <= ovf_m;
      ovf_dm <= '1' when (cnt_dm=5) and en_dm ='1' else '0';
      
------- FIN BCD--------------------------------------------
   
 ------ DIVISOR DE FRECUENCIAS 2 -----------------
   process(clk,reset)
   begin
       if reset = '1' then
           cnt_4KHz <=0;
       elsif clk'event and clk='1' then
       -- si quisieramos resetear la señal sincrona (contadores) lo pondriamos aqui
           if en_4KHz = '1' then            -- verifica el contador de overflow
               if cnt_4KHz =MAX_4KHz-1 then
                   cnt_4KHz <=0;
               else 
                cnt_4KHz <= cnt_4KHz +1;
               end if;
           end if;
       end if;
   end process;

   en_4KHz <= '1';
   ovf_4KHz <= '1' when (cnt_4KHz = MAX_4KHz -1) and en_4KHz = '1' else '0';
   
------- FIN DE DIVISOR DE FRECUENCIAS 2 ---------------------------- 

------- Contador de 2 bits --------------   
   process (clk,reset)
   begin
     if reset ='1' then
         cnt_2 <= (others => '0');
     elsif clk'event and clk='1' then
        if en_2 ='1' then
             if cnt_2 =3 then
                  cnt_2 <= (others => '0');
             else
                  cnt_2 <= cnt_2 +1;
             end if;
        end if;
    end if;
  end process;
   
   en_2 <= ovf_4KHz;
   C <= cnt_2;
   
   
-------- MULTIPLEXOR--------
    with C select 
        interna <= cnt_s when "00",
                   cnt_ds when "01",
                   cnt_m when "10",
                   cnt_dm when "11",
                   "--" when others;
-------------------------------


------ DECOFIFICADOR BCD A 7 SEGMENTOS------
with interna select
    seg <= "0000001" when "0000",
            "1001111" when "0001",
            "0010010" when "0010",
            "0000110" when "0011",
            "1001100" when "0100",
            "0100100" when "0101",
            "0100000" when "0110",
            "0001111" when "0111",
            "0000000" when "1000",
            "0000100" when "1001",
            "-------" when others;
            
 ------Decodificador de 2 a 4-------------
 
 with cnt_2 select
    sel <=  "0001" when "00",
            "0010" when "01",
            "0100" when "10",
            "1000" when "11",
            "----" when others;
            
 segmentos <= seg;
 selector <= sel;                                   
end behavioral;
