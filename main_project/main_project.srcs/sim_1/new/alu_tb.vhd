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
-- Port ( );
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
--    signal clk : std_logic := '0'; --remove later
    --Inputs
    signal a: std_logic_vector(31 downto 0) := (others => '0');
    signal b: std_logic_vector(31 downto 0) := (others => '0');
    signal carry: std_logic := '0' ;
    signal opcode: std_logic_vector(3 downto 0) := (others => '0');
    -- Outputs
    signal c: std_logic_vector(31 downto 0) := (others => '0');
    signal flags: std_logic_vector(3 downto 0);
     -- Clock period definitions
     constant clk_period : time := 10 ns;
     signal err_cnt_signal : integer := 1;
    begin
    -- Instantiate the Unit Under Test (UUT)
     uut: alu PORT MAP (
          a => a,
          b => b,
          carry => carry ,
          opcode => opcode,
          c => c,
          flags => flags
        );

     -- Stimulus process
   stim_proc: process
		variable err_cnt : INTEGER := 0;
   begin		
     
		------------------------------------------------------------
      --------------------- pre-case 0 ---------------------------
		------------------------------------------------------------
		
		-- Set inputs
		a <= std_logic_vector(to_signed(12, 32));
		b <= std_logic_vector(to_signed(-7, 32));
		carry <= '0';
		opcode <= "0100"; --add
		wait for clk_period;
		
      		-------------------------------------------------------------
		---------------------  case 0 -------------------------------
		-------------------------------------------------------------
		
		
		assert (c = std_logic_vector(to_signed(5, 32))) report "Error: case 0 c (add) incorrect";
        
        ------------------------------------------------------------
      --------------------- pre-case 1 ---------------------------
		------------------------------------------------------------
		
		-- Set inputs
		a <= std_logic_vector(to_signed(12, 32));
		b <= std_logic_vector(to_signed(-7, 32));
		carry <= '0';
		opcode <= "0010"; --sub
		wait for clk_period;
		
      		-------------------------------------------------------------
		---------------------  case 1 -------------------------------
		-------------------------------------------------------------
		
		
		assert (c = std_logic_vector(to_signed(19, 32))) report "Error: case 1 c (sub) incorrect";

        ------------------------------------------------------------
      --------------------- pre-case 2 ---------------------------
		------------------------------------------------------------
		
		-- Set inputs
		a <= std_logic_vector(to_signed(12, 32));
		b <= std_logic_vector(to_signed(-13, 32));
		carry <= '1';
		opcode <= "0101"; --add with carry (adc)
		wait for clk_period;
		
      		-------------------------------------------------------------
		---------------------  case 2 -------------------------------
		-------------------------------------------------------------
		
		
		assert (c = std_logic_vector(to_signed(0, 32))) report "Error: case 2 c (adc) incorrect";
        assert(flags(3 downto 2)="10") report "case 2 flag(Z) incorrect";

        ------------------------------------------------------------
      --------------------- pre-case 3 ---------------------------
		------------------------------------------------------------
		
		-- Set inputs
--		a <= std_logic_vector(to_signed(12, 32));
--		b <= std_logic_vector(to_signed(7, 32));
        a <= "11111111111111111111111111111111";
        b <= "00000000000000000000000000000001";
		carry <= '0';
		opcode <= "0100"; --add
		wait for clk_period;
		
      		-------------------------------------------------------------
		---------------------  case 3 -------------------------------
		-------------------------------------------------------------
		
--		assert (c = std_logic_vector(to_signed(19, 32))) report "Error: case 3 c incorrect";
        assert(flags(1)='1') report "case 3 flag(C) incorrect";

        ------------------------------------------------------------
      --------------------- pre-case 4 ---------------------------
		------------------------------------------------------------
		
		-- Set inputs
		a <= std_logic_vector(to_signed(2**30 + 2, 32));
		b <= std_logic_vector(to_signed(-(2**30), 32));
		carry <= '0';
		opcode <= "0010"; --sub
		wait for clk_period;
		
      		-------------------------------------------------------------
		---------------------  case 4 -------------------------------
		-------------------------------------------------------------
		
		
--		assert (c = std_logic_vector(to_signed(19, 32))) report "Error: case 4 c incorrect";
        assert(flags(1)='0') report "case 4 flag(C) incorrect";
        assert(flags(0)='1') report "case 4 flag(V) incorrect";


  		-------------------------add more test cases---------------------------------------------
		
      -- end of tb 
		wait for clk_period*100;

      wait;
   end process;


--END;

end Behavioral;
