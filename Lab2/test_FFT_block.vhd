LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use STD.textio.all;
use IEEE.numeric_std.ALL;
 

ENTITY test_FFT_block IS
END test_FFT_block;
 
ARCHITECTURE behavior OF test_FFT_block IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FFT_block
    PORT(
         clk : IN  std_logic;
         valid : OUT  std_logic;
         abs_fft_out : OUT  std_logic_vector(23 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';

 	--Outputs
   signal abs_fft_out : OUT  std_logic_vector(23 downto 0);
	signal valid : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
	
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: 	FFT_block PORT MAP (
          clk => clk,
          abs_fft_out => abs_fft_out,
          valid => valid
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

	process(clk) 	-- process for writing the outputs to the "*.txt" file
	file result_file: text open write_mode is "fft_output.txt";
	variable outline:line;
	variable tmp_fft:integer;
	begin
		if(clk'event and clk='1') then
				if valid='1' then
					tmp_fft  :=to_integer(signed(abs_fft_out));
					write(outline,tmp_fft);
					writeline(result_file,outline);
				end if;
		end if;
	end process;
 
END;
