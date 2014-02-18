--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:11:33 02/19/2014
-- Design Name:   
-- Module Name:   E:/EEE491/Lab2/LAB2/src/TestBench.vhd
-- Project Name:  LAB2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Main
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

ENTITY TestBench IS
END TestBench;
 
ARCHITECTURE behavior OF TestBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Main
    PORT(
         CLK : IN  std_logic;
         MULT_OUT : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';

 	--Outputs
   signal MULT_OUT : std_logic_vector(7 downto 0);
	SIGNAL MULT_OUT_INT : INTEGER RANGE -128 TO 127;
   
	-- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Main PORT MAP (
          CLK => CLK,
          MULT_OUT => MULT_OUT
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

	MULT_OUT_INT <= TO_INTEGER(SIGNED(MULT_OUT));
	
	MEMORYWRITE : PROCESS(clk)
		FILE RESULT_FILE: text OPEN WRITE_MODE IS "out.txt"; 
		VARIABLE outline : LINE; 	
		VARIABLE COUNT : INTEGER := 0;
		
	begin  
	IF COUNT < 128 THEN
		IF RISING_EDGE(CLK) THEN
				write(outline, MULT_OUT_INT); 
				writeLine(RESULT_FILE, outline);   
				COUNT := COUNT + 1;
		END IF;
	END IF;	
	end process; 

END;
