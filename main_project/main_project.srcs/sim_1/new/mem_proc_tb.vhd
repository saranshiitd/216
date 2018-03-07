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

entity mem_proc_tb is
-- Port ( );
end mem_proc_tb;

architecture Behavioral of mem_proc_tb is
    COMPONENT mem_proc_path
    PORT(
            mem_inp:in std_logic_vector(31 downto 0);
            proc_out:out std_logic_vector(31 downto 0);
            h: in std_logic;
            b: in std_logic;
            b_sel: in std_logic_vector(1 downto 0);
            h_sel: in std_logic;
            s: in std_logic
        );
    END COMPONENT;
--    signal clk : std_logic := '0'; --remove later
    --Inputs
    signal mem_inp: std_logic_vector(31 downto 0) := (others => '0');
    signal h: std_logic := '0';
    signal h_sel: std_logic := '0';
    signal s: std_logic := '0';
    signal b: std_logic := '0' ;
    signal b_sel: std_logic_vector(1 downto 0) := (others => '0');
    -- Outputs
    signal proc_out: std_logic_vector(31 downto 0) := (others => '0');
     -- Clock period definitions
     constant clk_period : time := 10 ns;
     signal err_cnt_signal : integer := 1;
    begin
    -- Instantiate the Unit Under Test (UUT)
     uut: mem_proc_path PORT MAP (
          mem_inp => mem_inp,
          proc_out => proc_out,
          h => h ,
          b => b,
          b_sel => b_sel,
          h_sel => h_sel,
          s => s
        );

     -- Stimulus process
   stim_proc: process
         constant mem_inp1: std_logic_vector(31 downto 0) := "00000000111111110101010100001111";
       constant mem_inp2: std_logic_vector(31 downto 0) := "11111111000000001111000010101010";
      
		variable err_cnt : INTEGER := 0;
   begin		
     
		------------------------------------------------------------
        --------------------- pre-case 0 ---------------------------
		------------------------------------------------------------
		
		-- Set inputs
		mem_inp <= mem_inp1;
		h <= '0';
		h_sel <= '0';
		s <= '1';
		b <= '1';
		b_sel <= "01";
		wait for clk_period;
		
      	-------------------------------------------------------------
		---------------------  case 0 -------------------------------
		-------------------------------------------------------------
		
		
		assert (proc_out = "00000000000000000000000001010101" ) report "Error: case 0 proc_out incorrect";
        
        ------------------------------------------------------------
        --------------------- pre-case 1 ---------------------------
        ------------------------------------------------------------
        
        -- Set inputs
        mem_inp <= mem_inp2;
        h <= '1';
        h_sel <= '0';
        s <= '1';
        b <= '0';
        b_sel <= "00";
        wait for clk_period;
        
        -------------------------------------------------------------
        ---------------------  case 1 -------------------------------
        -------------------------------------------------------------
        
        
        assert (proc_out = "11111111111111111111000010101010" ) report "Error: case 1 proc_out incorrect";

        ------------------------------------------------------------
        --------------------- pre-case 2 ---------------------------
        ------------------------------------------------------------
        
        -- Set inputs
        mem_inp <= mem_inp2;
        h <= '1';
        h_sel <= '0';
        s <= '0';
        b <= '0';
        b_sel <= "00";
        wait for clk_period;
        
        -------------------------------------------------------------
        ---------------------  case 2 -------------------------------
        -------------------------------------------------------------
        
        
        assert (proc_out = "00000000000000001111000010101010" ) report "Error: case 2 proc_out incorrect";


        
        
  		-------------------------add more test cases---------------------------------------------
		
      -- end of tb 
		wait for clk_period*100;

      wait;
   end process;


--END;

end Behavioral;
