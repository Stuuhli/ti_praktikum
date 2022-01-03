library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity akkumulator is

	port (
      d  : in std_logic_vector(3 downto 0); -- Daten-Eingang
      ld : in std_logic; -- MUX Steuereingang: 0 (gedrückt) = Ergebnis durchschalten, 1 (nicht gedrückt) = Dateneingang durchschalten
      
      sub : in std_logic; -- 0 = +, 1 = -
      e   : in std_logic; -- enable Auffangregister 0 (gedrückt) = enabled
      
      clk : in std_logic; -- Takt
      
      c : out std_logic; -- LEDG(4) carry out
      q : out std_logic_vector(3 downto 0); -- LEDG(3..1) Daten-Ausgang
      
      
      z_out : out std_logic_vector(4 downto 0) -- LEDR(4..0), z4 = carry
      
      );
end entity akkumulator;
 
architecture akkumulator_arch of akkumulator is
signal c_int : std_logic;
signal q_int : signed(3 downto 0);
signal z_int : signed(4 downto 0);
begin
	alu : process (q_int, d, sub)
	begin
		if (sub = '0') then
			z_int <= ('0' & q_int) + ('0' & signed(d));
		elsif (sub = '1') then
			z_int <= ('0' & q_int) - ('0' & signed(d));
		end if;
	end process alu;

	z_out <= std_logic_vector(z_int);
	
	reg : process (clk)
	begin
		if (clk'event and clk = '1') then
			if (e = '0') then
				if (ld = '0') then
					c_int <= z_int(4);
					q_int <= z_int(3 downto 0);
				elsif (ld = '1') then
					c_int <= '0';
					q_int <= signed(d);
				end if;
			end if;
		end if;
	end process reg;
	
	c <= c_int;
	q <= std_logic_vector(q_int);
		
end akkumulator_arch;
