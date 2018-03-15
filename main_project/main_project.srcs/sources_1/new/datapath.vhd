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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath is
 Port ( 
    clk : in std_logic ;
    PW : in std_logic ;
    IorD : in std_logic_vector("1 downto 0") ;
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
    Reset_register_file : in std_logic 
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
signal pmp_mem_out: std_logic_vector(31 downto 0);
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
signal alu_carry:  std_logic ;
signal alu_opcode:  std_logic_vector(3 downto 0);
signal alu_c:  std_logic_vector(31 downto 0);
signal alu_flags: std_logic_vector(3 downto 0) ;
signal reg_a : std_logic_vector(31 downto 0) ;
signal reg_b : std_logic_vector(31 downto 0) ;
signal reg_c : std_logic_vector(31 downto 0) ;
signal Instruction : std_logic_vector(31 downto 0) ;
signal Data : std_logic_vector(31 downto 0) ;
signal Result : std_logic_vector(31 downto 0) ;
signal memory_read_enable : std_logic ;
signal extended_ins_11_0 : std_logic_vector(31 downto 0) ;
signal extended_ins_23_0 : std_logic_vector(31 downto 0) ;
signal signal_flags : std_logic_vector(3 downto 0) ;
signal shift_amt_sig: std_logic_vector(4 downto 0);
signal shift_type_sig: std_logic_vector(1 downto 0);
signal shifter_output: std_logic_vector(31 downto 0);
signal bram_we: std_logic_vector(3 downto 0);
signal zeros32: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
begin

    extended_ins_23_0 <= std_logic_vector(resize(signed(Instruction(23 downto 0)), extended_ins_23_0'length));
    extended_ins_11_0 <= std_logic_vector(resize(signed(Instruction(11 downto 0)), extended_ins_11_0'length));
    
    alu_opcode <= op ;
    alu_carry <=  alu_flags(1) ;
    bram_we <= "1111" when memory_write_enable='1' else  "0000";
    
    memory_instantiation : entity work.BRAM2_wrapper port map (
        
        BRAM_PORTA_addr => memory_address ,
        BRAM_PORTA_we => bram_we ,
        BRAM_PORTA_din => selected_memory_input ,
        BRAM_PORTA_dout => memory_output ,
        BRAM_PORTA_clk => clk ,
        BRAM_PORTA_en => '1',
        BRAM_PORTA_rst => '0'
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
        op1 => reg_b ,
        op2 => reg_c ,
        output => multiplier_output
    
    );
    
    shifter_instantiation : entity work.shifter port map ( 
            input => reg_b ,
            shift_amount => shift_amt_sig ,
            shift_type => shift_type_sig,
            output => shifter_output
        
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
   
--   register_file_read_addr1 <= Instruction(19 downto 16) ;
--   register_file_write_addr <= Instruction(15 downto 12) ;
   shift_type_sig<= Instruction(6 downto 5);
   
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
            reg_a <= register_output1 ;
         end if ;
         
         if(BW = '1') then 
            reg_b <= register_output2 ;
         end if ;
         
         if(CW = '1') then 
            reg_c <= register_output1 ;
         end if ;
                  
         if(ReW = '1') then
            Result <= alu_c ;
         end if ;
         
         if(IorD = "00") then 
            pmp_proc_inp <= rf_pc_output ;
         elsif (IorD ="01") then 
            pmp_proc_inp <= Result ;
         else   
            pmp_proc_inp <= reg_a ;
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
        
        if(Rsrc = '1') then 
            register_file_read_addr2 <= Instruction(15 downto 12) ;
        else 
            register_file_read_addr2 <= Instruction(3 downto 0) ;
        end if ;
        
        if(R1src = "00") then 
              register_file_read_addr1 <= Instruction(19 downto 16) ;
           elsif (R1src="01") then
                register_file_read_addr1 <= Instruction(15 downto 12) ;
           else
                register_file_read_addr1 <= Instruction(11 downto 8) ;
         end if ;
        
        if(Wsrc = '1') then 
              register_file_write_addr <= Instruction(15 downto 12) ;
        else 
              register_file_write_addr <= Instruction(19 downto 16) ;
        end if ;
                 
        
        if(M2R = '1') then 
            register_file_input <= Data ;
        else 
            register_file_input <= Result ;
        end if ;
        
        if(Asrc1 = '1') then 
            alu_a <= reg_a ; 
        else 
            alu_a <= rf_pc_output ;
        end if;
        
        if(Asrc2 = "000") then 
            alu_b <= reg_b ;
        elsif (Asrc2 = "001") then 
            alu_b <= "00000000000000000000000000000100" ;
        elsif(Asrc2 = "010") then
            alu_b <= extended_ins_11_0 ;
        elsif(Asrc2 = "011") then
            alu_b <= extended_ins_23_0 ;
        elsif(Asrc2 = "100") then
            alu_b <= multiplier_output ;
        elsif(Asrc2 = "101") then
            alu_b <= shifter_output ;
        else
            alu_b<= zeros32;    
        end if;
        
        if (Fset = '1') then 
            signal_Flags <= alu_flags ;
        end if ;
        
        if(RW = '1') then
            register_file_write_enable <= '1' ;
        else 
            register_file_write_enable <= '0' ;
        end if ;
        
        if (Reset_register_file = '1') then
            register_file_reset <= '1' ;
        else 
            register_file_reset <= '0' ;
        end if ;
        
        
        
        
   end if ;
   
   end process ;
   
   
end Behavioral;
