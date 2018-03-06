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

entity mem_proc_path is
  Port ( 
   mem_inp:in std_logic_vector(31 downto 0);
   proc_out:out std_logic_vector(31 downto 0);
   h: in std_logic;
   b: in std_logic;
   b_sel: in std_logic_vector(1 downto 0);
   h_sel: in std_logic;
   s: in std_logic
  );
end mem_proc_path;

architecture Behavioral of mem_proc_path is
signal x: std_logic_vector(1 downto 0) :="00";
signal mem_inp_byte : std_logic_vector(31 downto 0);
signal mem_inp_half : std_logic_vector(31 downto 0);
signal mem_b_sel : std_logic_vector(7 downto 0) := (others => '0');
signal mem_h_sel : std_logic_vector(15 downto 0) := (others => '0');
begin
x<= h & b;
with s select mem_inp_half <=
    (15 downto 0 => mem_h_sel(15)) & mem_h_sel when '1',
    (15 downto 0 => '0') & mem_h_sel when others; -- '0'
with s select mem_inp_byte <=
        (23 downto 0 => mem_b_sel(7)) & mem_b_sel when '1',
        (23 downto 0 => '0') & mem_b_sel when others; --'0'
with h_sel select mem_h_sel <=
    mem_inp(31 downto 16) when '1' ,
    mem_inp(15 downto 0) when others; --'0'
with b_sel select mem_b_sel <=
        mem_inp(31 downto 24) when "11" ,
        mem_inp(23 downto 16) when "10",
        mem_inp(15 downto 8) when "01",
        mem_inp(7 downto 0) when others; --'00'
with x select proc_out <=
     mem_inp_byte when "01", 
     mem_inp_half when "10",
     mem_inp when others; --'00'
end Behavioral;
