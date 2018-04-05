----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.03.2018 14:23:38
-- Design Name: 
-- Module Name: controller_fsm - Behavioral
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
use work.typePackage.all ;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_fsm is
Port(    
    clk : in std_logic 
--    P_temp: out std_logic;
--    PW : out std_logic ;
--    IorD : out std_logic_vector(1 downto 0) ;
--    MR : out std_logic ;
--    MW : out std_logic ;
--    IW : out std_logic ; 
--    DW : out std_logic ;
--    M2R : out std_logic ;
--    R1src: out std_logic_vector(1 downto 0);
--    Wsrc: out std_logic;
--    R2src : out std_logic ;
--    RW : out std_logic ;
--    AW : out std_logic ;
--    BW : out std_logic ;
--    CW : out std_logic ;
--    Asrc1 : out std_logic_vector(1 downto 0) ;
--    Asrc2 : out std_logic_vector(2 downto 0) ;
--    Fset : out std_logic ;
--    ReW : out std_logic ;
--    op : out std_logic_vector(3 downto 0) ;

--    shift_amt_src: out std_logic;
--    PW_temp: out std_logic;
    
--    Reset_register_file : out std_logic  ;
--    Instruction : in std_logic_vector(31 downto 0 ) 
    
);


end controller_fsm;

architecture Behavioral of controller_fsm is


signal P_temp:  std_logic;
signal PW :  std_logic ;
signal IorD :  std_logic_vector(1 downto 0) ;
signal MR :  std_logic ;
signal MW :  std_logic ;
signal IW :  std_logic ; 
signal DW :  std_logic ;
signal M2R :  std_logic ;
signal R1src:  std_logic_vector(1 downto 0);
signal Wsrc:  std_logic;
signal R2src :  std_logic ;
signal RW :  std_logic ;
signal AW :  std_logic ;
signal BW :  std_logic ;
signal CW :  std_logic ;
signal Asrc1 :  std_logic_vector(1 downto 0) ;
signal Asrc2 :  std_logic_vector(2 downto 0) ;
signal Fset :  std_logic ;
signal ReW :  std_logic ;
signal op :  std_logic_vector(3 downto 0) ;
signal reg_read1: std_logic_vector(31 downto 0);
signal reg_read2:  std_logic_vector(31 downto 0);
signal alu_out: std_logic_vector(31 downto 0);
signal a_out:  std_logic_vector(31 downto 0);
signal b_out:  std_logic_vector(31 downto 0);
signal c_out:  std_logic_vector(31 downto 0);
signal ir_out :  std_logic_vector(31 downto 0);
signal dr_out:  std_logic_vector(31 downto 0);
signal res_out:  std_logic_vector(31 downto 0);
signal mem_out:  std_logic_vector(31 downto 0);

signal shift_amt_src:  std_logic;
signal PW_temp:  std_logic;

signal Reset_register_file :  std_logic  ;
signal Instruction :  std_logic_vector(31 downto 0 ) ;

--type instruction_type_type is (DP, DT, Branch) ;
--type dpsubclass_type is (mul,arith,tst); 
--type dpvariant_type is (imm , reg_imm ,reg_shift_const, reg_shift_reg);
--type multype_type is (mul,mla);
--type dttype_type is(ldr,str);

signal state: statetype := FETCH; 
signal instruction_type : instruction_type_type ;
signal dpsubclass: dpsubclass_type;
signal dpvariant: dpvariant_type;
signal multype: multiply_type;
signal dttype: dtLoadOrStoreType;
signal count: natural range 10 downto 0 :=0;  
signal dtSubType : dtsubclass_type ; 
signal Flags : std_logic_vector(3 downto 0) ;

signal op_reg: std_logic_vector(3 downto 0):="0100";
signal opcodeActrl : std_logic_vector(3 downto 0) ;     
signal setflag:  std_logic;    
signal immed:  std_logic;
signal preindex:  std_logic;
signal writeback: std_logic ; 
signal updown : std_logic ;

--signal Immediate : std_logic ;
signal arithRd : std_logic_vector(3 downto 0) ; 
signal arithRn : std_logic_vector(3 downto 0) ; 
signal arithRm : std_logic_vector(3 downto 0) ; 
signal arithRs : std_logic_vector(3 downto 0) ;
signal arithRegNoShift : std_logic ;
signal arithRegShiftCons : std_logic ; 
signal arithRegShiftReg : std_logic ;
signal predicate : std_logic ; 
signal dp_clk :  std_logic ;
signal dp_PW :  std_logic ;
signal dp_IorD : std_logic_vector(1 downto 0) ;
signal dp_MR :  std_logic ;
signal dp_MW :  std_logic ;
signal dp_IW :  std_logic ; 
signal dp_DW :  std_logic ;
signal dp_M2R :  std_logic ;
signal dp_R1src:  std_logic_vector(1 downto 0);
signal dp_Wsrc:  std_logic;
signal dp_R2src :  std_logic ;
signal dp_RW :  std_logic ;
signal dp_AW :  std_logic ;
signal dp_BW :  std_logic ;
signal dp_CW :  std_logic ;
signal dp_Asrc1 :  std_logic_vector(1 downto 0) ;
signal dp_Asrc2 :  std_logic_vector(2 downto 0) ;
signal dp_Fset :  std_logic ;
signal dp_ReW :  std_logic ;
signal dp_op :  std_logic_vector(3 downto 0) ;
signal dp_Flags :  std_logic_vector(3 downto 0) ;
signal dp_Reset_register_file :  std_logic; 
signal dp_reg_read1:  std_logic_vector(31 downto 0);
signal dp_reg_read2:  std_logic_vector(31 downto 0);
signal dp_alu_out: std_logic_vector(31 downto 0);
signal dp_a_out:  std_logic_vector(31 downto 0);
signal dp_b_out:  std_logic_vector(31 downto 0);
signal dp_c_out:  std_logic_vector(31 downto 0);
signal dp_ir_out :  std_logic_vector(31 downto 0);
signal dp_dr_out:  std_logic_vector(31 downto 0);
signal dp_res_out:  std_logic_vector(31 downto 0);
signal dp_mem_out:  std_logic_vector(31 downto 0);
    --Further additions
signal dp_PW_temp:  std_logic; --signal to temporarily store alu output in register before writing it in PC
signal dp_shift_amt_src:  std_logic ;  --source of shift amount, '1' indicates constant, '0' indicates register

begin

    Decoder_Instantion : entity work.Decoder port map (
    
        Instruction => Instruction , 
        out_instruction_type => instruction_type , 
        out_dpInstructionSubtype => dpsubclass ,  
        out_dtInstructionSubtype =>  dtSubType , 
        out_mulType => multype ,  
        out_loadOrStore => dttype ,  
        out_dpvariant => dpvariant ,  
        out_setFlag =>  setflag ,
        out_immediate => immed , 
        out_preIndex => preindex ,  
        out_writeBack => writeback ,  
        out_upDown => updown 
    ) ;
    
    ActrlInst : entity work.Actrl port map (
    
        Instruction => Instruction ,
        op => opcodeActrl ,
        updown => updown , 
        state => state ,
        instruction_type => instruction_type 
    
    ); 
    
    FlagCheckInst : entity work.FlagCheckUnit port map ( 
        
        Predicate => predicate , 
        Flags => Flags ,
        Condition => Instruction(31 downto 28 )
    
    ) ;
    
    dp_clk <= clk ;
    dp_PW <= PW ; 
    dp_IorD <= IorD ; 
    dp_MR <= MR ; 
    dp_MW <= MW ;
    dp_IW <= IW ; 
    dp_DW <= DW ;
    dp_M2R <= M2R ;
    dp_R1src <= R1src ;
    dp_Wsrc <= Wsrc ; 
    dp_R2src <= R2src ; 
    dp_RW <= RW ; 
    dp_AW <= AW ; 
    dp_BW <= BW ;
    dp_CW <= CW ; 
    dp_Asrc1 <= Asrc1 ;
    dp_Asrc2 <= Asrc2 ; 
    dp_Fset <= Fset ; 
    dp_ReW <= ReW ; 
    dp_op <= op ;
    dp_Flags <= Flags ;
    dp_Reset_register_file <= Reset_register_file ;
    dp_reg_read1 <= reg_read1 ;
    dp_reg_read2 <= reg_read2 ;
    dp_alu_out <= alu_out ; 
    dp_a_out <= a_out ; 
    dp_b_out <= b_out ; 
    dp_c_out <= c_out ; 
    dp_ir_out <= ir_out ; 
    dp_dr_out <= dr_out ; 
    dp_res_out <= res_out ; 
    dp_mem_out <= mem_out ;
    dp_PW_temp <= PW_temp ; 
    dp_shift_amt_src <= shift_amt_src ; 

    dataPathInst : entity work.datapath port map (
    
        clk => dp_clk ,
        PW  => dp_PW ,
        IorD => dp_IorD ,
        MR => dp_MR ,
        MW => dp_MW ,
        IW => dp_IW , 
        DW => dp_DW ,
        M2R => dp_M2R ,
        R1src => dp_R1src ,
        Wsrc => dp_Wsrc ,
        R2src => dp_R2src ,
        RW => dp_Rw ,
        AW => dp_AW ,
        BW => dp_Bw ,
        CW => dp_Cw ,
        Asrc1 => dp_Asrc1 ,
        Asrc2 => dp_Asrc2 ,
        Fset => dp_Fset ,
        ReW  => dp_Rew ,
        op => dp_op ,
        Flags => dp_Flags ,
        Reset_register_file => dp_Reset_register_file , 
        reg_read1 => dp_reg_read1 ,
        reg_read2 => dp_reg_read2 ,
        alu_out => dp_alu_out ,
        a_out => dp_a_out ,
        b_out => dp_b_out ,
        c_out => dp_c_out ,
        ir_out => dp_ir_out ,
        dr_out => dp_dr_out ,
        res_out => dp_res_out  ,
        mem_out => dp_mem_out ,
        PW_temp => dp_PW_temp,  
        shift_amt_src => dp_shift_amt_src  
    
    
    );     

    
    
    
    op<=op_reg;

    process(clk)
       begin
       --Controller FSM
       if rising_edge(clk) then
            if(state=FETCH ) then
                if (count<3) then --wait for 3 cycles to account for BRAM latency
                    IorD<= "00";
                    IW<= '1';
                    Asrc1<= "11";
                    Asrc2<="001";
                    op_reg<="0100"; --add
                    count<= count+1;
                    PW<='0';
                elsif(count=3) then
                    IW<='0'; 
                    PW_temp<='1';
                    count<=count+1;
                elsif(count=4) then
                    PW_temp<='0';
                    PW<='1';
                    count<=0;
                    if(instruction_type=branch) then
                        state<= BRANCHST;
                    else 
                        state<= RDAB;
                    end if;
                end if;
            elsif(state<=BRANCHST) then
                if(count<1) then
                    Asrc2<="011";
                    Asrc1<="01";
                    op_reg<="0100"; --add
                    PW_temp<='1';
                    count<= count+1;
                else
                    PW<='1';
                    count<=0;
                    state<=FETCH;
                end if;            
            elsif (state=RDAB) then
                AW<='1'; 
                BW<='1';
                if(instruction_type= DP and dpsubclass=mul) then
                        r1src<="01";
                        r2src<='0';
                else 
                        r1src<="00";
                        r2src<='0';
                end if;
                if(instruction_type=DP) then
                        op_reg<=Instruction(24 downto 21);
                        if (dpsubclass=mul or dpsubclass=tst) then
                            state<=RdBC;
                        elsif (dpsubclass=arith) then
                            if(dpvariant=imm) then
                                Asrc2<= "010";
                                Asrc1<="00";
                                ReW<='1';
                                if (setFlag= '1') then
                                    Fset<='1';
                                else
                                    Fset<= '0';
                                end if;
                                state<= WRITERES;
                            elsif (dpvariant=reg_imm) then
                                Asrc2<= "000";
                                Asrc1<="00";
                                ReW<='1';
                                if (setFlag= '1') then
                                    Fset<='1';
                                else
                                    Fset<= '0';
                                end if;
                                state<= WRITERES;
                            elsif(dpvariant=reg_shift_const) then
                                Asrc2<= "101";
                                Asrc1<="00";
                                shift_amt_src<='1';
                                ReW<='1';
                                state<=WriteRes;
                            elsif(dpvariant=reg_shift_reg) then
                                state<= RdBC;
                            end if;
                      end if;
               elsif (instruction_type=DT) then
                      state <= RDCSTR;--DT  
                             
               end if;
           elsif(state=RDBC) then
                BW<='1';
                CW<='1';
                r1src<="11";
                r2src<='0';
                if(dpsubclass= arith) then
                    state<= REGSHIFTDP;
                elsif (dpsubclass=mul) then
                    state<= MULDP;
                elsif (dpsubclass=tst) then
                    state<=TESTDP;
                end if;
           elsif(state = TESTDP) then
                op_reg<=Instruction(24 downto 21);
                Asrc1<="01";
                Asrc2<="000";
                Fset<='1';
                state<=FETCH;
           elsif(state=MULDP) then
                op_reg<="0100"; --add
                if(multype=mult) then
                    Asrc1<="00";
                    Asrc2<="110";
                elsif(multype=mla) then
                    Asrc2<="010";
                    Asrc1<="10";
                end if;
                state<= WRITERES;
          elsif(state=WRITERES) then
                if(instruction_type=DP) then
                    M2R<='0';
                    if(dpsubclass=mul) then
                        Wsrc<='0';
                    else Wsrc<='1';
                    end if;
                    RW<='1';
                    state<= FETCH;
                elsif(instruction_type=DT) then
                    Wsrc<='0';
                    M2R<='0';
                    RW<='1';
                    if(dttype=load) then
                        state<=LOADFINISH; 
                    else 
                        state<=FETCH; 
                    end if;  
                end if;              
          elsif(state=RDCSTR) then
                if(dttype=store) then
                    r1src<="01";
                    CW<='1';
                    AW<='0';
                    BW<='0';
                end if;
                state<=LOADSTOREDT;
                count<=0;
          elsif(state=LOADSTOREDT) then
                op_reg<="0100"; --add
                if(immed='1')then
                    Asrc2<="010";
                else 
                    Asrc2<="101";
                    shift_amt_src<='1';
                end if;
                if(preindex='1') then
                    IorD<="10";
                else
                    IorD<="01";
                end if;
                if(dttype=load) then
                    DW<='1';
                    MW<='0';
                    --mem_proc_path inputs
                 elsif(dttype=store) then
                    MW<='1';
                    --proc_mem_path inputs
                 end if;
                 if(count>3) then
                     count<=0;
                     if(writeback='1') then
                        state<=WRITERES;
                     else 
                        state<=LOADFINISH;
                     end if;
                 end if;
                 count <= count+1;   
          
          elsif(state=LOADFINISH) then
                if(dttype=load) then
                    Wsrc<='1';
                    M2R<='1';
                    RW<='1';
                 end if;
                 state<=FETCH;
           end if;        
        end if;
 end process;
end Behavioral;

                              
                  
          
                    

                                
                                
          