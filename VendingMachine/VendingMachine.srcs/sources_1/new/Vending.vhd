-- echipa : Cristea Marius-Cristian, Tudosie Maria, Dobre Iliana Emilia, grupa 323CB(toti)
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Vending is
port(
    Clock               : in std_logic; --  clock
    Reset               : in std_logic; --  reset
    doreste_produs      : in std_logic; -- semnal pentru atunci cand vrea sa cumpere un produs
    doreste_rest        : in std_logic; -- semnal pentru atunci cand vrea rest
    continua_cumparaturi : in std_logic;
    produse_alese       : in std_logic_vector (2 downto 0);     -- pe pozitia 0 este produsul de 2,5 lei
    bancnote_inserate   : in std_logic_vector  (3 downto 0);    -- pe pozitia 1 este produsul de 3 lei
    produse_dispensate  : out std_logic_vector (2 downto 0);    -- pe pozitia 2 este produsul de 5 lei
    refuza_bani         : out std_logic; -- daca a introdus mai mult de 15 lei
    insuficienti_bani   : out std_logic;
    rest                : out integer -- restul
    );
end Vending;

architecture behaviour of Vending is 
    
    signal stare_curenta     : std_logic_vector(3 downto 0);
    signal stare_urmatoare   : std_logic_vector(3 downto 0);
    signal suma_curenta      : integer; -- Suma curenta de bani introdusi in aparat
    signal rest_intern       : integer;
    constant idle      : std_logic_vector(3 downto 0) :="0000"; 
    constant inserare_bani : std_logic_vector(3 downto 0) := "0001";
    constant adauga_50_bani : std_logic_vector(3 downto 0) := "0010";
    constant adauga_1_leu : std_logic_vector(3 downto 0) := "0011";
    constant adauga_5_lei : std_logic_vector(3 downto 0) := "0100";
    constant adauga_10_lei : std_logic_vector(3 downto 0) := "0101";
    constant alegere_produs : std_logic_vector(3 downto 0 ) := "0110";
    constant produs_1 : std_logic_vector(3 downto 0) := "0111";
    constant produs_2 : std_logic_vector(3 downto 0) := "1000";
    constant produs_3 : std_logic_vector(3 downto 0) := "1001";
    constant continuare_cumparaturi : std_logic_vector(3 downto 0) := "1010";
    constant eliberare_rest : std_logic_vector(3 downto 0) := "1111";
    
begin
    process(Clock, Reset) is 
    begin
            if Reset = '1' then
                stare_curenta <= idle;
            elsif rising_edge(Clock) then
                stare_curenta <= stare_urmatoare;
            end if;
     end process;
     
     process(stare_curenta) is
     begin
     
            case stare_curenta is
                when idle =>
                    rest <= 0;
                    refuza_bani <= '0';
                    insuficienti_bani <= '0';
                    produse_dispensate <= ( others => '0');
                    rest_intern <= 0;
                    suma_curenta <= 0;
                    stare_urmatoare <= inserare_bani;
                when inserare_bani =>
                    if suma_curenta < 1500 then
                        if bancnote_inserate(0) = '1' then
                            stare_urmatoare <=  adauga_50_bani;
                        
                        elsif bancnote_inserate(1) = '1' then
                             stare_urmatoare <=  adauga_1_leu;
                        
                        elsif bancnote_inserate(2) = '1' then
                            stare_urmatoare <=  adauga_5_lei;
                        
                        elsif bancnote_inserate(3) = '1' then
                            stare_urmatoare <=  adauga_10_lei; 
                        end if;
                     else
                     refuza_bani <= '1';
                     report "Suma depaseste 15 lei";
                      if doreste_rest = '1' then
                        rest_intern <= suma_curenta - 100;
                        stare_urmatoare <= eliberare_rest;
                      else
                        report "Alegeti produs";
                        stare_urmatoare <= inserare_bani;
                      end if;  
                     end if;
                        
                    if doreste_produs = '1' then
                        stare_urmatoare <= alegere_produs;
                    end if;
                    if doreste_rest = '1' then
                        if suma_curenta > 500 then
                            rest_intern <= suma_curenta - 100;
                        else 
                            rest_intern <= suma_curenta - 50;
                        end if;
                        stare_urmatoare <= eliberare_rest;
                    end if;
                    
                    
                   when adauga_50_bani =>
                       suma_curenta <= suma_curenta + 50;
                       stare_urmatoare <= inserare_bani;
                   when adauga_1_leu =>
                        suma_curenta <= suma_curenta + 100;
                        stare_urmatoare <= inserare_bani;   
                   when adauga_5_lei =>
                       suma_curenta <= suma_curenta + 500;
                       stare_urmatoare <= inserare_bani;    
                   when adauga_10_lei =>
                       suma_curenta <= suma_curenta + 1000;
                       stare_urmatoare <= inserare_bani;   
                                    
                   when alegere_produs =>
                        if produse_alese(0) = '1' then -- produsul de 2,5 lei
                            stare_urmatoare <= produs_1;
                        elsif produse_alese(1) = '1' then -- produsul de 3 lei
                            stare_urmatoare <= produs_2;
                        elsif produse_alese(2) = '1' then -- produsul de 5 lei
                            stare_urmatoare <= produs_3;
                        end if;
                   when produs_1 =>
                       if suma_curenta > 250 then 
                          suma_curenta <= suma_curenta - 250;
                          produse_dispensate(0) <= '1';
                          stare_urmatoare <= continuare_cumparaturi;
                       else
                          insuficienti_bani <= '1';
                           report "bani insuficienti";
                           report "suma curenta este " & Integer'image(suma_curenta);
                          stare_urmatoare <= inserare_bani;
                       end if;
                        
                   when produs_2 =>
                         if suma_curenta > 300 then 
                            suma_curenta <= suma_curenta - 300;
                            produse_dispensate(1) <= '1';
                            stare_urmatoare <= continuare_cumparaturi;
                         else 
                           
                             insuficienti_bani <= '1';
                              report "bani insuficienti";
                              report "suma curenta este " & Integer'image(suma_curenta);
                            stare_urmatoare <= inserare_bani;
                         end if;
                        
                   when produs_3 =>  
                         if suma_curenta > 500 then 
                            suma_curenta <= suma_curenta - 500;
                            produse_dispensate(2) <= '1';
                            stare_urmatoare <= continuare_cumparaturi;
                         else 
                            insuficienti_bani <= '1';
                             report "bani insuficienti";
                             report "suma curenta este " & Integer'image(suma_curenta);
                            stare_urmatoare <= inserare_bani;
                         end if;
                            
                  when continuare_cumparaturi =>
                       if continua_cumparaturi = '1' then
                            stare_urmatoare <= inserare_bani;
                       elsif continua_cumparaturi = '0' then
                            rest_intern <= suma_curenta;
                            stare_urmatoare <= eliberare_rest;
                       end if;
                       
                  when eliberare_rest =>
                        rest <= rest_intern;
                  when others =>
                        
              end case;   
         
    end process;
end behaviour;