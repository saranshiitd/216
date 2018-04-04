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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_fsm is
Port(    clk : in std_logic ;
    P_temp: out std_logic;
    PW : out std_logic ;
    IorD : out std_logic_vector(1 downto 0) ;
    MR : out std_logic ;
    MW : out std_logic ;
    IW : out std_logic ; 
    DW : out std_logic ;
    M2R : out std_logic ;
    R1src: out std_logic_vector(1 downto 0);
    Wsrc: out std_logic;
    R2src : out std_logic ;
    RW : out std_logic ;
    AW : out std_logic ;
    BW : out std_logic ;
    CW : out std_logic ;
    Asrc1 : out std_logic_vector(1 downto 0) ;
    Asrc2 : out std_logic_vector(2 downto 0) ;
    Fset : out std_logic ;
    ReW : out std_logic ;
    op : out std_logic_vector(3 downto 0) ;

    shift_amt_src: out std_logic;
    PW_temp: out std_logic;
    
    Flags : in std_logic_vector(3 downto 0) ;
    Reset_register_file : out std_logic  ;
    Instruction : in std_logic_vector(31 downto 0 );
    setflag: in std_logic;    
    immed: in std_logic;
    preindex: in std_logic;
    writeback: in std_logic
);
end controller_fsm;

architecture Behavioral of controller_fsm is

type statetype is (FETCH , RDAB , RDBC , RDCSTR , WRITERES , REGSHIFTDP, MULDP, TESTDP,LOADFINISH,LOADSTOREDT, BRANCHST) ; 
type instruction_type_type is (DP, DT, Branch) ;
type dpsubclass_type is (mul,arith,tst); 
type dpvariant_type is (imm , reg_imm ,reg_shift_const, reg_shift_reg);
type multype_type is (mul,mla);
type dttype_type is(ldr,str);

signal state: statetype :=FETCH; 
signal instruction_type : instruction_type_type ;
signal dpsubclass: dpsubclass_type;
signal dpvariant: dpvariant_type;
signal multype: multype_type;
signal dttype: dttype_type;
signal count: natural range 10 downto 0 :=0;  

signal op_reg: std_logic_vector(3 downto 0):="0100";


signal Immediate : std_logic ;
signal arithRd : std_logic_vector(3 downto 0) ; 
signal arithRn : std_logic_vector(3 downto 0) ; 
signal arithRm : std_logic_vector(3 downto 0) ; 
signal arithRs : std_logic_vector(3 downto 0) ;
signal arithRegNoShift : std_logic ;
signal arithRegShiftCons : std_logic ; 
signal arithRegShiftReg : std_logic ;


begin
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
                if(multype=mul) then
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
                    if(dttype=ldr) then
                        state<=LOADFINISH; 
                    else 
                        state<=FETCH; 
                    end if;  
                end if;              
          elsif(state=RDCSTR) then
                if(dttype=str) then
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
                if(dttype=ldr) then
                    DW<='1';
                    MW<='0';
                    --mem_proc_path inputs
                 elsif(dttype=str) then
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
                if(dttype=ldr) then
                    Wsrc<='1';
                    M2R<='1';
                    RW<='1';
                 end if;
                 state<=FETCH;
           end if;        
        end if;
 end process;
end Behavioral;

                              
                  
          
                    

                                
                                
          