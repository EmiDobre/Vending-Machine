library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Vending_tb is
end;

architecture bench of Vending_tb is

  component Vending
  port(
      Clock               : in std_logic;
      Reset               : in std_logic;
      doreste_produs      : in std_logic;
      doreste_rest        : in std_logic;
      continua_cumparaturi : in std_logic;
      produse_alese       : in std_logic_vector (2 downto 0);
      bancnote_inserate   : in std_logic_vector  (3 downto 0);
      produse_dispensate  : out std_logic_vector (2 downto 0);
      refuza_bani         : out std_logic;
      insuficienti_bani   : out std_logic;
      rest                : out integer
      );
  end component;

  signal Clock: std_logic;
  signal Reset: std_logic;
  signal doreste_produs: std_logic;
  signal doreste_rest: std_logic;
  signal continua_cumparaturi: std_logic;
  signal produse_alese: std_logic_vector (2 downto 0);
  signal bancnote_inserate: std_logic_vector (3 downto 0);
  signal produse_dispensate: std_logic_vector (2 downto 0);
  signal refuza_bani: std_logic;
  signal insuficienti_bani: std_logic;
  signal rest: integer ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: Vending port map ( Clock                => Clock,
                          Reset                => Reset,
                          doreste_produs       => doreste_produs,
                          doreste_rest         => doreste_rest,
                          continua_cumparaturi => continua_cumparaturi,
                          produse_alese        => produse_alese,
                          bancnote_inserate    => bancnote_inserate,
                          produse_dispensate   => produse_dispensate,
                          refuza_bani          => refuza_bani,
                          insuficienti_bani    => insuficienti_bani,
                          rest                 => rest );

  stimulus: process
  begin
  
    -- Put initialisation code here

    Reset <= '1';
    wait for 5 ns;
    Reset <= '0';
    wait for 5 ns;

    -- stimulus
        bancnote_inserate <= "0100";
        wait for 10 ns;
        
        bancnote_inserate <= "0000";
        wait for 10 ns;
        
        doreste_produs <= '1';
        wait for 10 ns;
        
        produse_alese <= "010";
        wait for 10 ns;
        
        produse_alese <= "000";
        wait for 10ns;
        
        continua_cumparaturi <= '0';
        wait for 10 ns;
        
        
        
        
        
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      Clock <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;

configuration cfg_Vending_tb of Vending_tb is
  for bench
    for uut: Vending
      -- Default configuration
    end for;
  end for;
end cfg_Vending_tb;

configuration cfg_Vending_tb_behaviour of Vending_tb is
  for bench
    for uut: Vending
      use entity work.Vending(behaviour);
    end for;
  end for;
end cfg_Vending_tb_behaviour;