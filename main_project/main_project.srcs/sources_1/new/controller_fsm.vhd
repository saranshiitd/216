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
    Asrc1 : out std_logic ;
    Asrc2 : out std_logic_vector(2 downto 0) ;
    Fset : out std_logic ;
    ReW : out std_logic ;
    op : out std_logic_vector(3 downto 0) ;
    Flags : in std_logic_vector(3 downto 0) ;
    Reset_register_file : out std_logic  ;
    Instruction : in std_logic_vector(31 downto 0 )    
);
end controller_fsm;

architecture Behavioral of controller_fsm is

type statetype is (FETCH , RDAB , RDBC , RDC , WRITERES ) ; 
type instruction_type_type is (arithDP , mulDP , testDP ) ; 

signal state: statetype :=FETCH; 
signal count: natural range 10 downto 0 :=0;  


signal Immediate : std_logic ;
signal arithRd : std_logic_vector(3 downto 0) ; 
signal arithRn : std_logic_vector(3 downto 0) ; 
signal arithRm : std_logic_vector(3 downto 0) ; 
signal arithRs : std_logic_vector(3 downto 0) ;
signal instruction_type : instruction_type_type ;
signal arithRegNoShift : std_logic ;
signal arithRegShiftCons : std_logic ; 
signal arithRegShiftReg : std_logic ;


begin

    process(clk)
       begin
       --Controller FSM
       if rising_edge(clk) then
            if(state=FETCH ) then
                if (count<3) then --wait for 3 cycles to account for BRAM latency
                    IorD<= "00";
                    IW<= '1';
                    Asrc1<= '0';
                    Asrc2<="001";
                    count<= count+1;
                    PW<='0';
                elsif(count=3) then 
                    PW<='1';
                    count<=0;
                    state<= RDAB;
                end if;
            elsif (state=RDAB) then
                AW<='1';
                BW<='1';
                if(instruction_type=mulDP) then
                    r1src<="01";
                    r2src<='0';
                else 
                    r1src<="00";
                    r2src<='0';
                end if;
                
                
           end if;        
      end if;
    end process;
end Behavioral;
