----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2018 10:30:18 PM
-- Design Name: 
-- Module Name: datapath_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_datapath is
  Port ( 
    MultiPlexerInp : in std_logic_vector(2 downto 0) ;
    LED_outputs : out std_logic_vector(15 downto 0) ;
    generate_pulse : in std_logic  ;
    clk : in std_logic 
  );
end test_datapath;
    
architecture Behavioral of test_datapath is
component datapath is
    port(
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
        Rsrc : in std_logic ;
        RW : in std_logic ;
        AW : in std_logic ;
        BW : in std_logic ;
        CW : in std_logic ;
        Asrc1 : in std_logic ;
        Asrc2 : in std_logic_vector(2 downto 0) ;
        Fset : in std_logic ;
        ReW : in std_logic ;
        op : in std_logic_vector(3 downto 0) ;
        Flags : in std_logic_vector(3 downto 0) ;
        Reset_register_file : in std_logic ;
        reg_read1: out std_logic_vector(31 downto 0);
        reg_read2: out std_logic_vector(31 downto 0);
        alu_out:out std_logic_vector(31 downto 0);
        a_out: out std_logic_vector(31 downto 0);
        b_out: out std_logic_vector(31 downto 0);
        c_out: out std_logic_vector(31 downto 0);
        ir_out : out std_logic_vector(31 downto 0);
        dr_out: out std_logic_vector(31 downto 0);
        res_out: out std_logic_vector(31 downto 0)
    );
end component datapath ;
signal pulse : std_logic := '0' ; 
signal state : std_logic_vector(1 downto 0) := "00" ; 
signal dp_clk :   std_logic ;
signal dp_PW :  std_logic ;
signal dp_IorD :  std_logic_vector(1 downto 0) ;
signal dp_MR :  std_logic ;
signal dp_MW :  std_logic ;
signal dp_IW :  std_logic ; 
signal dp_DW :  std_logic ;
signal dp_M2R :  std_logic ;
signal dp_R1src:  std_logic_vector(1 downto 0);
signal dp_Wsrc:  std_logic;
signal dp_Rsrc :  std_logic ;
signal dp_RW :  std_logic ;
signal dp_AW :  std_logic ;
signal dp_BW :  std_logic ;
signal dp_CW :  std_logic ;
signal dp_Asrc1 :  std_logic ;
signal dp_Asrc2 :  std_logic_vector(2 downto 0) ;
signal dp_Fset :  std_logic ;
signal dp_ReW :  std_logic ;
signal dp_op :  std_logic_vector(3 downto 0) ;
signal dp_Flags :  std_logic_vector(3 downto 0) ;
signal dp_Reset_register_file :  std_logic ;  
signal dp_register1 : std_logic_vector(31 downto 0) := (others => '0'); 
signal dp_register2 : std_logic_vector(31 downto 0) := (others => '0');
signal dp_alu_output : std_logic_vector(31 downto 0) := (others => '0'); 
signal dp_instruction : std_logic_vector(31 downto 0) := (others => '0'); 
signal dp_memory_data : std_logic_vector(31 downto 0) := (others => '0');
signal dp_A : std_logic_vector(31 downto 0) := (others => '0');   
signal dp_B : std_logic_vector(31 downto 0) := (others => '0');   
signal dp_C : std_logic_vector(31 downto 0) := (others => '0');  
signal dp_Res : std_logic_vector(31 downto 0) := (others => '0') ; 
signal output_signal : std_logic_vector(31 downto 0) ; 
begin
    datapath_i : component datapath
        port map(
            clk => dp_clk, 
            PW  => dp_PW,
            IorD  => dp_IorD,
            MR => dp_MR,
            MW => dp_MW,
            IW => dp_IW,
            DW => dp_DW,
            M2R => dp_M2R,
            R1src => dp_R1src,
            Wsrc => dp_Wsrc,
            Rsrc => dp_Rsrc ,
            RW => dp_RW,
            AW => dp_AW,
            BW => dp_BW,
            CW => dp_CW,
            Asrc1 => dp_Asrc1,
            Asrc2 => dp_Asrc2,
            Fset => dp_Fset,
            ReW => dp_ReW,
            op => dp_op,
            Flags => dp_Flags,
            Reset_register_file => dp_Reset_register_file , 
            reg_read1 => dp_register1,
            reg_read2 => dp_register2,
            alu_out=>dp_alu_output ,
            a_out => dp_A,
            b_out => dp_B,
            c_out => dp_C,
            ir_out => dp_instruction ,
            dr_out => dp_memory_data,
            res_out => dp_Res
        );
    process(clk) 
    begin 
    
        if(rising_edge(clk)) then 
            if(generate_pulse = '1' and state = "00") then
                state <= "01" ; 
                pulse <= '1' ; 
            elsif(generate_pulse = '1' and state = "01") then 
                state <= "10" ; 
                pulse <= '0' ;
            elsif(generate_pulse = '0' ) then 
                state <= "00" ; 
                pulse <= '0' ;
            end if ;
       
        end if ;
    
    end process ;
    
    -- instruction hardcoding here  
        
    

    output_signal <= dp_register1 when MultiPlexerInp = "0000" else
                     dp_register2 when MultiPlexerInp = "0001" else 
                     dp_alu_output when MultiPlexerInp = "0010" else 
                     dp_instruction when MultiPlexerInp = "0011" else 
                     dp_memory_data when MultiPlexerInp = "0100" else 
                     dp_A when MultiPlexerInp = "0101" else 
                     dp_B when MultiPlexerInp = "0110" else 
                     dp_C when  MultiPlexerInp = "0111" else 
                     dp_Res ;     
end Behavioral;