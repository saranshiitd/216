----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2018 23:26:08
-- Design Name: 
-- Module Name: Actrl - Behavioral
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
use work.typepackage.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Actrl is
  Port (
   Instruction: in std_logic_vector(31 downto 0);
   op: out std_logic_vector(3 downto 0);
   updown: in std_logic ; 
   signal state: in statetype;  
   signal instruction_type: in instruction_type_type
   );
end Actrl;


architecture Behavioral of Actrl is


begin
    process(state)
    begin
        if(state=RDAB) then
             if(instruction_type = DP) then
                 op<=Instruction(24 downto 21);
             else 
                op<="0100";
             end if;
            
        elsif(state=TESTDP) then
            op<=Instruction(24 downto 21);
        elsif(state=LOADSTOREDT) then
            if(updown='1') then op<="0100";
            else op<="0010";
            end if;
        else 
            op<="0100";
        end if;
   end process;        


end Behavioral;
