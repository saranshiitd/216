----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.02.2018 14:13:29
-- Design Name: 
-- Module Name: proc_mem_path - Behavioral
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

entity proc_mem_path is
  Port ( 
   proc_inp:in std_logic_vector(31 downto 0);
   mem_out:out std_logic_vector(31 downto 0);
   h: in std_logic;
   b: in std_logic;
   b_sel: in std_logic_vector(1 downto 0);
   h_sel: in std_logic
  );
end proc_mem_path;

architecture Behavioral of proc_mem_path is
signal x: std_logic_vector(1 downto 0) :="00";
signal proc_inp_byte : std_logic_vector(31 downto 0);
signal proc_inp_half : std_logic_vector(31 downto 0);
signal proc_b_sel : std_logic_vector(7 downto 0) := (others => '0');
signal proc_h_sel : std_logic_vector(15 downto 0) := (others => '0');
begin
x<= h & b;
proc_inp_half <= proc_h_sel & proc_h_sel;
proc_inp_byte <= proc_b_sel & proc_b_sel &  proc_b_sel & proc_b_sel;
with h_sel select proc_h_sel <=
    proc_inp(31 downto 16) when '1' ,
    proc_inp(15 downto 0) when '0';
with b_sel select proc_b_sel <=
        proc_inp(31 downto 24) when "11" ,
        proc_inp(23 downto 16) when "10",
        proc_inp(15 downto 8) when "01",
        proc_inp(7 downto 0) when "00"; 
with x select mem_out <=
     proc_inp_byte when "01", 
     proc_inp_half when "10",
     proc_inp when "00";
end Behavioral;
