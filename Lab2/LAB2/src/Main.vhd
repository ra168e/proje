----------------------------------------------------------------------------------
-- Company: 
<<<<<<< HEAD
-- Engineer: gurcan-kosansu-unal
=======
-- Engineer: 
>>>>>>> b6658e94f5b3ae6abea9c9d90df188e4240260c6
-- 
-- Create Date:    00:04:37 02/09/2014 
-- Design Name: 
-- Module Name:    Main - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
--use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;



entity Main is
    Port ( CLK 		: in  STD_LOGIC;
           MULT_OUT 	: out  STD_LOGIC_VECTOR (7 downto 0));
end Main;

architecture Behavioral of Main is

	TYPE MDATA IS ARRAY (0 TO 127) OF INTEGER RANGE -128 TO 127;
	CONSTANT S1 : MDATA := (104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40);
	CONSTANT S2 : MDATA := (64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64);
	

	COMPONENT Block_RAM
	  PORT (
		 clka 	: IN STD_LOGIC;
		 wea 		: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addra 	: IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		 dina 	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 douta 	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;
	
	COMPONENT MUL
	  PORT (
		 a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 b : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 p : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;

	SIGNAL MULT_RESULT : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL MULT_IN_A 	: STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL MULT_IN_B 	: STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
<<<<<<< HEAD
	SIGNAL ROW			: INTEGER RANGE 0 TO 127 := 0;
	SIGNAL ADDRESS		: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL RAM_WRITE	: STD_LOGIC_VECTOR(0 DOWNTO 0) := "1";		--ILGINCLIKLER...
	SIGNAL RAM_DATA   : STD_LOGIC_VECTOR(7 DOWNTO 0);
=======
	SIGNAL ROW			: INTEGER RANGE 0 TO 128 := 0;
	SIGNAL ADDRESS		: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL RAM_WRITE	: STD_LOGIC := '1';
>>>>>>> b6658e94f5b3ae6abea9c9d90df188e4240260c6
	SIGNAL STATE		: STD_LOGIC_VECTOR(1 DOWNTO 0) := "00"; 	--00 MULT, 01 FFT
	
	
begin

	MULT_OUT <= MULT_RESULT;
	MULT_IN_A(7 DOWNTO 0) <= STD_LOGIC_VECTOR(TO_SIGNED(S1(ROW),8));
	MULT_IN_B(7 DOWNTO 0) <= STD_LOGIC_VECTOR(TO_SIGNED(S2(ROW),8));
	ADDRESS <= STD_LOGIC_VECTOR(TO_UNSIGNED(ROW,7));
	
	Output_RAM : Block_RAM
	  PORT MAP (
		 clka 	=> CLK,
<<<<<<< HEAD
		 wea 		=> RAM_WRITE,
		 addra 	=> ADDRESS,
		 dina 	=> MULT_RESULT,
		 douta 	=> RAM_DATA
=======
		 wea 	=> "1",
		 addra 	=> ADDRESS,
		 dina 	=> MULT_RESULT,
		 douta 	=> OPEN
>>>>>>> b6658e94f5b3ae6abea9c9d90df188e4240260c6
	  );
	
	MIXER : MUL
	  PORT MAP (
      P => MULT_RESULT,
      A => MULT_IN_A,
      B => MULT_IN_B
  );
	
	PROCESS (CLK)
	variable foo : integer := 0;
	BEGIN
	IF STATE = "00" THEN
<<<<<<< HEAD
		IF RISING_EDGE(CLK) THEN	
			IF foo = 127 THEN
				RAM_WRITE <= "0";
				foo := 0;
				ROW <= 0;
				STATE <= "01";
			ELSE
				foo := foo + 1;
				ROW <= ROW + 1;	
			END IF;
=======
		IF foo < 129 THEN
			IF RISING_EDGE(CLK) THEN	
				ROW <= ROW + 1;	
				foo := foo + 1; 
			END IF;
		ELSE
			RAM_WRITE <= '0';
			STATE <= "01";
			foo := 0;
>>>>>>> b6658e94f5b3ae6abea9c9d90df188e4240260c6
		END IF;
	ELSIF STATE = "01" THEN
		--FFT STUFF	
	END IF;
	END PROCESS;
		

end Behavioral;

