----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.02.2018 22:40:43
-- Design Name: 
-- Module Name: datapath - Behavioral
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
use work.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath is
 Port ( 
    clk : in std_logic ;
    PW : in std_logic ;
    IorD : in std_logic ;
    MR : in std_logic ;
    MW : in std_logic ;
    IW : in std_logic ; 
    DW : in std_logic ;
    M2R : in std_logic ;
    Rsrc : in std_logic ;
    RW : in std_logic ;
    AW : in std_logic ;
    BW : in std_logic ;
    Asrc1 : in std_logic ;
    Asrc2 : in std_logic_vector ;
    Fset : in std_logic ;
    ReW : in std_logic ;
    op : in std_logic_vector(3 downto 0) 
 );
end datapath;

architecture Behavioral of datapath is

signal selected_memory_input : std_logic_vector(31 downto 0) ; 
signal selected_alu_first_operand : std_logic_vector(31 downto 0) ;
signal selected_alu_second_operand : std_logic_vector(31 downto 0) ;
signal selected_register_number : std_logic_vector(3 downto 0) ;
signal memory_address : std_logic_vector(3 downto 0) ;
signal memory_write_enable : std_logic ;
signal memory_output : std_logic_vector(31 downto 0) ;
signal register_file_input : std_logic_vector(31 downto 0) ;
signal register_file_read_addr1 : std_logic_vector(3 downto 0) ;
signal register_file_read_addr2 : std_logic_vector(3 downto 0) ;
signal register_file_write_enable : std_logic ;
signal register_file_write_addr : std_logic_vector(3 downto 0) ;
signal register_file_reset : std_logic ;
signal register_output1 : std_logic_vector(31 downto 0) ;
signal register_output2 : std_logic_vector(31 downto 0) ;
signal rf_pc_output : std_logic_vector(31 downto 0);
signal rf_pc_write_enable : std_logic ; 
signal rf_pc_input : std_logic_vector(31 downto 0) ;
signal multiplier_op1 : std_logic_vector(31 downto 0) ;
signal multiplier_op2 : std_logic_vector(31 downto 0) ;
signal multiplier_output : std_logic_vector(31 downto 0) ;
signal pmp_proc_inp: std_logic_vector(31 downto 0);
signal   pmp_mem_out: std_logic_vector(31 downto 0);
signal pmp_h:  std_logic;
signal pmp_b:  std_logic;
signal pmp_b_sel:  std_logic_vector(1 downto 0);
signal pmp_h_sel: std_logic ;
signal mpp_mem_inp: std_logic_vector(31 downto 0);
signal mpp_proc_out: std_logic_vector(31 downto 0);
signal mpp_h:  std_logic;
signal mpp_b:  std_logic;
signal mpp_b_sel:  std_logic_vector(1 downto 0);
signal mpp_h_sel:  std_logic;
signal mpp_s:  std_logic ;
signal alu_a:  std_logic_vector(31 downto 0);
signal alu_b:  std_logic_vector(31 downto 0);
signal alu_carry:  std_logic_vector(0 downto 0);
signal alu_opcode:  std_logic_vector(3 downto 0);
signal alu_c:  std_logic_vector(31 downto 0);
signal alu_flags: std_logic_vector(3 downto 0) ;
signal Reg_a : std_logic_vector(31 downto 0) ;
signal Reg_b : std_logic_vector(31 downto 0) ;
signal Instruction : std_logic_vector(31 downto 0) ;
signal Data : std_logic_vector(31 downto 0) ;
signal Result : std_logic_vector(31 downto 0) ;
signal memory_read_enable : std_logic ;
begin
    
    
    
    memory_instantiation : entity work.Memory port map (
        
        address => memory_address ,
        write_enable => memory_write_enable ,
        memory_input => selected_memory_input ,
        memory_output => memory_output ,
        clk => clk ,
        read_enable => memory_read_enable 
        
        
        
    
    );
    
    register_file_instantiation : entity work.Register_File port map (
        
        clk => clk ,
        input_data => register_file_input ,
        read_addr_1 => register_file_read_addr1 ,
        read_addr_2 => register_file_read_addr2 ,
        write_addr => register_file_write_addr ,
        reset => register_file_reset ,
        write_enable => register_file_write_enable ,
        output_1 => register_output1,
        output_2 => register_output2 ,
        pc_output => rf_pc_output , 
        pc_input => rf_pc_input , 
        write_enable_pc => rf_pc_write_enable 
        
    );
    
    multiplier_instantiation : entity work.multiplier port map ( 
        op1 => multiplier_op1 ,
        op2 => multiplier_op2 ,
        output => multiplier_output
    
    ); 
    
    proc_mem_path_instantiation : entity work.proc_mem_path port map (
        
        proc_inp => pmp_proc_inp ,
       mem_out => pmp_mem_out ,
       h => pmp_h ,
       b => pmp_b ,
       b_sel => pmp_b_sel ,
       h_sel => pmp_h_sel 
        
    );
    
   mem_proc_path : entity work.mem_proc_path port map (
    
      mem_inp => mpp_mem_inp ,
      proc_out => mpp_proc_out ,
      h => mpp_h ,
      b => mpp_b ,
      b_sel => mpp_b_sel ,
      h_sel => mpp_h_sel ,
      s => mpp_s
   
   );
   
   alu_instantiation : entity work.alu port map (
   
      a => alu_a ,
      b => alu_b ,
      carry => alu_carry ,
      opcode => alu_opcode ,
      c => alu_c ,
      flags =>  alu_flags    
    
   );
   
   process(clk)
   begin
   
   if rising_edge(clk) then
        
        if(IW = '1' ) then 
            Instruction <= mpp_proc_out ;
        end if ; 
        
        if(DW = '1') then 
            Data <= mpp_proc_out ;
        end if ;
         
        if(AW = '1') then 
            Reg_a <= register_output1 ;
         end if ;
         
         if(BW = '1') then 
            Reg_b <= register_output2 ;
         end if ;
         
         if(ReW = '1') then
            Result <= alu_c ;
         end if ;
         
         if(IorD = '1') then 
            pmp_proc_inp <= rf_pc_output ;
         else 
            pmp_proc_inp <= Result ;
         end if ;
         
         if(PW = '1') then
            rf_pc_input <= alu_c ; 
            rf_pc_write_enable <= '1' ;
         else 
            rf_pc_write_enable<= '0' ;
         end if ;
         if(MW = '1') then 
            memory_write_enable <= '1' ;
         else 
            memory_write_enable <= '0' ;    
         end if ;
        
        if (MR = '1') then 
            memory_read_enable <= '1' ;
        else 
            memory_read_enable <= '0' ;
        end if ;
         
        
        
        
   end if ;
   
   end process ;
   
   
end Behavioral;
