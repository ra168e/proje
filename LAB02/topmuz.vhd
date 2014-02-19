----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:46:17 02/18/2014 
-- Design Name: 
-- Module Name:    topmuz - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity topmuz is
    Port ( clk : in  STD_LOGIC;
           mult_out : out  STD_LOGIC_VECTOR (7 downto 0);
           fft_out : out  STD_LOGIC_VECTOR (23 downto 0);
           fft_data_ready : out  STD_LOGIC);
end topmuz;

architecture Behavioral of topmuz is

	TYPE MDATA IS ARRAY (0 TO 127) OF INTEGER RANGE -128 TO 127;
	CONSTANT S1 : MDATA := (104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40,104,127,104,40,-40,-104,-128,-104,-40,40);
	CONSTANT S2 : MDATA := (64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64,-128,-64,64,127,64,-64);
--	SIGNAL OUTARR : MDATA := (OTHERS => 0);
	
	COMPONENT Block_RAM
	PORT (
		clka		: IN STD_LOGIC;
		wea 		: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		addra		: IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		dina		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		douta		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT fft_core
	PORT (
		clk : in STD_LOGIC := 'X'; 
		start : in STD_LOGIC := 'X'; 
		fwd_inv : in STD_LOGIC := 'X'; 
		fwd_inv_we : in STD_LOGIC := 'X'; 
		rfd : out STD_LOGIC; 
		busy : out STD_LOGIC; 
		edone : out STD_LOGIC; 
		done : out STD_LOGIC; 
		dv : out STD_LOGIC; 
		xn_re : in STD_LOGIC_VECTOR ( 7 downto 0 ); 
		xn_im : in STD_LOGIC_VECTOR ( 7 downto 0 ); 
		xn_index : out STD_LOGIC_VECTOR ( 6 downto 0 ); 
		xk_index : out STD_LOGIC_VECTOR ( 6 downto 0 ); 
		xk_re : out STD_LOGIC_VECTOR ( 15 downto 0 ); 
		xk_im : out STD_LOGIC_VECTOR ( 15 downto 0 ) 
	);
	END COMPONENT;
	
	COMPONENT MUL
	PORT (
		a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		b : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		p : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT SQRT
	  PORT (
		 x_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 y_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 x_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		 clk : IN STD_LOGIC
	  );
	END COMPONENT;
	
	SIGNAL MULT_RESULT	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL MULT_IN_A 		: STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL MULT_IN_B 		: STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ROW				: INTEGER RANGE 0 TO 128 := 0;
	SIGNAL ADDRESS			: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL FFT_IN 			: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL RAM_END			: STD_LOGIC := '0';
	SIGNAL READY			: STD_LOGIC;
	SIGNAL DATA_READY		: STD_LOGIC;
	SIGNAL REAL_OUT		: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL IMAG_OUT		: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ABS_IN_X		: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ABS_IN_Y		: STD_LOGIC_VECTOR(15 DOWNTO 0);

begin

	MULT_OUT <= MULT_RESULT;
	MULT_IN_A(7 DOWNTO 0) <= STD_LOGIC_VECTOR(TO_SIGNED(S1(ROW),8));
	MULT_IN_B(7 DOWNTO 0) <= STD_LOGIC_VECTOR(TO_SIGNED(S2(ROW),8));
	ADDRESS <= STD_LOGIC_VECTOR(TO_UNSIGNED(ROW,7));
	
	DO_FFT : FFT_CORE
	PORT MAP(
		CLK			=> CLK,
		START			=> '1',		--COULD BE RAM_END
		FWD_INV		=> '1',
		FWD_INV_WE	=> '0',
		RFD			=>	READY,
		BUSY			=> OPEN,
		EDONE			=> OPEN,
		DONE			=> OPEN,
		DV				=> DATA_READY,
		XN_RE			=> FFT_IN,	
		XN_IM			=> OPEN,
		XN_INDEX		=> OPEN,	--WORK IN PROGRESS
		XK_INDEX		=> OPEN,	--WORK IN PROGRESS
		XK_RE			=> REAL_OUT,
		XK_IM			=> IMAG_OUT
	);
	
	Output_RAM : Block_RAM
	PORT MAP (
		clka 	=> CLK,
		wea 		=> "1",
		addra 	=> ADDRESS,
		dina 	=> MULT_RESULT,
		douta 	=> FFT_IN
	);
	
	MIXER : MUL
	PORT MAP (
		a => MULT_IN_A,
		b => MULT_IN_B,
		P => MULT_RESULT
	);
  
	ABSOLUTE : SQRT
	PORT MAP (
		x_in => ABS_IN_X,
		y_in => ABS_IN_Y,
		x_out => FFT_OUT,
		clk => CLK
	);
	
	PROCESS (CLK)
	VARIABLE COUNT : INTEGER := 0;
--	VARIABLE ABSOL	: STD_LOGIC_VECTOR(23 DOWNTO 0);
	VARIABLE FOO : INTEGER := 0;
	BEGIN
	IF COUNT < 128 THEN
		IF RISING_EDGE(CLK) THEN
			ROW <= ROW + 1;
			COUNT := COUNT + 1;
		END IF;
	ELSE
		RAM_END <= '1';
	END IF;
	IF DATA_READY == '1' THEN
		ABS_IN_X <= REAL_OUT;
		ABS_IN_Y <= IMAG_OUT;
	END IF;
	END PROCESS;

end Behavioral;

