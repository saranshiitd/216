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

entity datapath_tb is
-- Port ( );
end datapath_tb;

architecture Behavioral of datapath_tb is
    COMPONENT datapath
    PORT(
            clk : in std_logic ;
            PW : in std_logic ;
            IorD : in std_logic_vector(1 downto 0) ;
            MR : in std_logic ;
            MW : in std_logic ;
            IW : in std_logic ; 
            DW : in std_logic ;
            M2R : in std_logic ;
            R1src: in std_logic_vector(1 downto 0);
            Wsrc: in std_logic;
            R2src : in std_logic ;
            RW : in std_logic ;
            AW : in std_logic ;
            BW : in std_logic ;
            CW : in std_logic ;
            Asrc1 : in std_logic_vector(1 downto 0) ;
            Asrc2 : in std_logic_vector(2 downto 0) ;
            Fset : in std_logic ;
            ReW : in std_logic ;
            op : in std_logic_vector(3 downto 0) ;
            Flags : out std_logic_vector(3 downto 0) ;
            Reset_register_file : in std_logic; 
            reg_read1: out std_logic_vector(31 downto 0);
            reg_read2: out std_logic_vector(31 downto 0);
            alu_out:out std_logic_vector(31 downto 0);
            a_out: out std_logic_vector(31 downto 0);
            b_out: out std_logic_vector(31 downto 0);
            c_out: out std_logic_vector(31 downto 0);
            ir_out : out std_logic_vector(31 downto 0);
            dr_out: out std_logic_vector(31 downto 0);
            res_out: out std_logic_vector(31 downto 0);
            mem_out: out std_logic_vector(31 downto 0);
            PW_temp: in std_logic; --signal to temporarily store alu output in register before writing it in PC
            shift_amt_src: in std_logic --source of shift amount, '1' indicates constant, '0' indicates register
            

    );
    END COMPONENT;
    -- signal clk : std_logic := '0'; --remove later
    --Inputs
   signal  clk :  std_logic := '0' ;
   signal  PW :  std_logic := '0';
   signal  IorD :  std_logic_vector(1 downto 0) := "00";
   signal  MR :  std_logic := '0';
   signal  MW :  std_logic := '0';
   signal  IW :  std_logic := '0'; 
   signal  DW :  std_logic := '0';
   signal  M2R :  std_logic := '0';
   signal  R1src:  std_logic_vector(1 downto 0) := "00";
   signal  Wsrc:  std_logic := '0';
   signal  Rsrc :  std_logic := '0' ;
   signal  RW :  std_logic := '0' ;
   signal  AW :  std_logic := '0';
   signal  BW :  std_logic := '0';
   signal  CW : std_logic:= '0';
   signal  Asrc1 :  std_logic_vector(1 downto 0) := "00";
   signal  Asrc2 :  std_logic_vector(2 downto 0) := "000" ;
   signal  Fset :  std_logic := '0';
   signal  ReW :  std_logic := '0';
   signal  op :  std_logic_vector(3 downto 0) := "0000";
   signal  Flags :  std_logic_vector(3 downto 0) := "0000";
   signal  Reset_register_file :  std_logic := '0';
   signal  PW_temp : std_logic ;
   signal  shift_amt_src : std_logic ;
   
    -- Outputs
    signal reg_read1:  std_logic_vector(31 downto 0);
    signal reg_read2:  std_logic_vector(31 downto 0);
    signal alu_out: std_logic_vector(31 downto 0);
    signal a_out:  std_logic_vector(31 downto 0);
    signal b_out:  std_logic_vector(31 downto 0);
    signal c_out:  std_logic_vector(31 downto 0);
    signal ir_out :  std_logic_vector(31 downto 0);
    signal dr_out:  std_logic_vector(31 downto 0);
    signal res_out:  std_logic_vector(31 downto 0);
    signal mem_out: std_logic_vector(31 downto 0);

    -- Clock period definitions
     constant clk_period : time := 100 ns ;
     constant four_periods : time := 400ns ;
     signal err_cnt_signal : integer := 1;
     --clk_process

    begin
           
    clk_process: process
        begin
            clk<='0';
            wait for clk_period/2;
            clk<='1';
            wait for clk_period/2;
        end process;
       
   
    -- Instantiate the Unit Under Test (UUT)
     uut: datapath PORT MAP (
                clk => clk ,
                 PW => PW ,
                 IorD => IorD ,
                 MR => MR ,
                 MW => MW ,
                 IW => IW , 
                 DW => DW ,
                 M2R => M2R ,
                 R1src => R1src,
                 Wsrc => Wsrc,
                 R2src => Rsrc ,
                 RW => RW ,
                 AW => AW ,
                 BW => BW ,
                 CW => CW,
                 Asrc1 => Asrc1 ,
                 Asrc2 => Asrc2 ,
                 Fset => Fset ,
                 ReW => ReW ,
                 op => op ,
                 Flags => Flags ,
                 Reset_register_file => Reset_register_file, 
                 reg_read1 => reg_read1,
                 reg_read2 => reg_read2,
                 alu_out => alu_out,
                 a_out => c_out,
                 b_out => c_out,
                 c_out => c_out,
                 ir_out => ir_out,
                 dr_out => dr_out,
                 res_out => res_out,
                 mem_out => mem_out,
                 PW_temp => PW_temp , --signal to temporarily store alu output in register before writing it in PC
                 shift_amt_src => shift_amt_src --source of shift amount, '1' indicates constant, '0' indicates register
                
        );

     -- Stimulus process
   stim_proc: process
		variable err_cnt : INTEGER := 0;
   begin		
     
		------------------------------------------------------------
      --------------------- pre-case 0 ---------------------------
		------------------------------------------------------------
		
		-- Set inputs
--	  clk<= '0'	
--	   PW<='1';
--	   IorD<="00";
--	   IW<='1';
--	   Asrc1<='0';
--	   Asrc2<="001";
--	   op<="0100";
	   
	   IorD<= "00";
       IW<= '1';
       Asrc1<= "11";
       Asrc2<="001";
       op<= "0100";
       PW_temp<='1';
       wait for four_periods ;
	   PW<='1';
	   
		 
		--check 
      		-------------------------------------------------------------
		---------------------  case 0 -------------------------------
		-------------------------------------------------------------

  		-------------------------add more test cases---------------------------------------------
		
      -- end of tb 
		wait for clk_period*100;

      wait;
   end process;


--END;

end Behavioral;
