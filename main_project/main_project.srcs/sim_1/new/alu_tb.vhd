----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2018 23:07:51
-- Design Name: 
-- Module Name: alu_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu_tb is
--  Port ( );
end alu_tb;

architecture Behavioral of alu_tb is
    COMPONENT alu
    PORT(
            a: in std_logic_vector(31 downto 0);
            b: in std_logic_vector(31 downto 0);
             carry: in std_logic ;
             opcode: in std_logic_vector(3 downto 0);
             c: out std_logic_vector(31 downto 0);
             flags: out std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    signal clk : std_logic := '0'; --remove later
    --Inputs
    signal a: in std_logic_vector(31 downto 0) := (others => '0');
    signal b: in std_logic_vector(31 downto 0) := (others => '0');
    signal carry: in std_logic := '0' ;
    signal opcode: in std_logic_vector(3 downto 0) := (others => '0');
    -- Outputs
    signal c: out std_logic_vector(31 downto 0) := (others => '0');
    signal flags: out std_logic
     -- Clock period definitions
     constant clk_period : time := 10 ns;
     signal err_cnt_signal : integer := 1;
    begin
    -- Instantiate the Unit Under Test (UUT)
     uut: alu PORT MAP (
          a => a,
          b => b,
          carry => carry ;
          opcode => opcode;
          c => c;
          flags => flags
        );

     -- Stimulus process
   stim_proc: process
		variable err_cnt : INTEGER := 0;
   begin		
     
		------------------------------------------------------------
      --------------------- pre-case 0 ---------------------------
		------------------------------------------------------------
		
		-- Set clock to be fast, initialize in1=01,in2=23 and initiate multiplication
		display_button <= '1';
		-- Set inputs
		a <= std_logic_vector(to_unsigned(12, 32));
		b <= std_logic_vector(to_unsigned(7, 32));
		carry <= '0';
		opcode <= "0100"; --add
		wait for clk_period;
		
      		-------------------------------------------------------------
		---------------------  case 0 -------------------------------
		-------------------------------------------------------------
		
		
		assert (c = std_logic_vector(to_unsigned(19, 32));) report "Error: case 0 c incorrect";


  		-------------------------add more test cases---------------------------------------------
		
		err_cnt_signal <= err_cnt;		
		-- summary of all the tests
		if (err_cnt=0) then
			 assert false
			 report "Testbench of ALU completed successfully!"
			 severity note;
		else
			 assert false
			 report "Something wrong, try again"
			 severity error;
		end if;

      -- end of tb 
		wait for clk_period*100;

      wait;
   end process;


END;

end Behavioral;
