----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2018 14:25:33
-- Design Name: 
-- Module Name: typePackgae - Behavioral
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

--Declarations may typically be any of the following: type, subtype, constant, file, alias, component, attribute, function, procedure

package typePackage is
    type state is (fetch , RdAB , RdBC , RdC , WriteRes ) ; 
--type instruction_type_type is (arith , mul , test , halfwordTranfer) ; 
    type instruction_type_type is (DP, DT, Branch) ;
    type dpsubclass_type is (mul,arith,tst, NotDP);
    type dtsubclass_type is ( wordTransfer , byteTransfer , halfwordTranfer , NotDT ) ;
    type multiply_type is ( mult , mla , notMul ) ;
    type dtLoadOrStoreType is (load , store , none ) ;
    type dpvariant_type is (imm , reg_imm ,reg_shift_const, reg_shift_reg);

end typePackage ;
