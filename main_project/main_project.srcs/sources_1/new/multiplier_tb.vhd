-- Vhdl test bench created from schematic /home/asobti/Xilinx_projects/lab3_reg_file/lab3_reg_file.sch - Fri Jul 21 15:05:17 2017
--
-- Notes:
-- 1) This testbench template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the unit under test.
-- Xilinx recommends that these types always be used for the top-level
-- I/O of a design in order to guarantee that the testbench will bind
-- correctly to the timing (post-route) simulation model.
-- 2) To use this template as your testbench, change the filename to any
-- name of your choice with the extension .vhd, and use the "Source->Add"
-- menu in Project Navigator to import the testbench. Then
-- edit the user defined section below, adding code to generate the
-- stimulus for your design.
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
library std;
use std.textio.all;

ENTITY multiplier_tb IS
END multiplier_tb;
ARCHITECTURE behavioral OF multiplier_tb IS

  COMPONENT multiplier is  Port (
    op1 : in std_logic_vector(31 downto 0); 
    op2 : in std_logic_vector(31 downto 0);
    output : out std_logic_vector(31 downto 0)
 	);
   END COMPONENT;

	signal op1 :  std_logic_vector(31 downto 0) := (others => '0') ; 
   	signal op2 :  std_logic_vector(31 downto 0) := (others => '0');
   	signal output : std_logic_vector(31 downto 0) := (others => '0')  ;

	
BEGIN

  multiplier_inst: multiplier PORT MAP(
    op1 => op1 ,  
    op2 => op2 ,
    output =>  output
); 
-- *** Test Bench - User Defined Section ***
   tb : PROCESS
	variable err_cnt : integer := 0;
	variable s : line;
--	constant GND : STD_LOGIC := '0';
--	constant SUPPLY : STD_LOGIC := '1';
--	constant reg0 : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000001001110"; -- 78
--	constant reg1 : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000001010010"; --82
--	constant reg2 : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000001100011111100"; -- 6396
--	constant reg3 : STD_LOGIC_VECTOR(31 downto 0) := "11111111111111111111110010001011"; --885
--	constant reg4 : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000001110011111"; --927
--	constant reg5 : STD_LOGIC_VECTOR(31 downto 0) := "11111111111100110111101101010101";  -- -885 * 927
--	constant reg6 : STD_LOGIC_VECTOR(31 downto 0) := "11111111111111111111111110100111";  -- -89
--	constant reg7 : STD_LOGIC_VECTOR(31 downto 0) := "11111111111111111111111101110001"; -- -143
--	constant reg8 : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000011000110110111"; -- -89 * -143
--	variable test_addr : INTEGER := 0;
	constant op1_tc1 : integer := 78 ;
	constant op2_tc1 : integer := 82 ;
	constant result_tc1 : integer := 6396 ;
    constant op1_tc2 : integer := -885 ;
    constant op2_tc2 : integer := 927 ;
    constant result_tc2 : integer := -820395 ;
    constant op1_tc3 : integer := -89 ;
    constant op2_tc3 : integer := -143 ;
    constant result_tc3 : integer := 12727 ;
    
    
   BEGIN

		
		
		-- pre-case 0 (Write 5 to r0)
		wait for 10 ns;
--        mode <= GND;
--        wr_addr <= reg0;
--        rd_addr1 <= reg0;
--        rd_addr2 <= reg0;
--        wr_data <= "0101";
--        write_enable <= SUPPLY;
        
        op1 <= std_logic_vector(to_signed(op1_tc1,32));
        op2 <= std_logic_vector(to_signed(op2_tc1,32));      
        wait for 5 ns;
        assert (output = std_logic_vector(to_signed(result_tc1,32))) report "Failed tc1";
        if (output /= std_logic_vector(to_signed(result_tc1,32))) then
            err_cnt := err_cnt + 1;
        end if;         
        wait for 5 ns ;
        
        op1 <= std_logic_vector(to_signed(op1_tc2,32));
        op2 <= std_logic_vector(to_signed(op2_tc2,32));      
        wait for 5 ns;
        assert (output = std_logic_vector(to_signed(result_tc2,32))) report "Failed tc2"; 
        if (output /= std_logic_vector(to_signed(result_tc2,32))) then
            err_cnt := err_cnt + 1;
        end if;
        wait for 5 ns ;

        op1 <= std_logic_vector(to_signed(op1_tc3,32));
        op2 <= std_logic_vector(to_signed(op2_tc3,32));      
        wait for 5 ns;
        assert (output = std_logic_vector(to_signed(result_tc3,32))) report "Failed tc3"; 
        if (output /= std_logic_vector(to_signed(result_tc3,32))) then
            err_cnt := err_cnt + 1;
        end if;
        wait for 5 ns ;
        
       -- clock <= GND;
       -- wait for 5 ns;
       -- clock <= SUPPLY;
       -- wait for 5 ns;
       -- clock <= GND;
       -- wait for 5 ns;
        
		-- case 0 (Read r0 to both read ports)
--		write_enable <= GND;
--        rd_addr1 <= reg0;
--        rd_addr2 <= reg0;
        
--		wait for 1 ns;
--		assert (rd_data1 = "0101") report "Error : Can't read 0b0101 from reg0 on port0";
--        assert (rd_data2 = "0101") report "Error : Can't read 0b0101 from reg0 on port1";
--        assert (rd_data1_xor_data2 = "0000") report "Error : Incorrect XOR output on rd_data1_xor_data2";
		
--		if (rd_data1/="0101" or rd_data2/="0101" or rd_data1_xor_data2/="0000") then
--			 err_cnt := err_cnt + 1;
--		end if;
		
		-- pre-case 1 (Write 5 to r0)
--		wait for 10 ns;
--        mode <= GND;
--        wr_addr <= reg5;
--        rd_addr1 <= reg0;
--        rd_addr2 <= reg0;
--        wr_data <= "0001";
--        write_enable <= SUPPLY;
        
--        clock <= GND;
--        wait for 5 ns;
--        clock <= SUPPLY;
--        wait for 5 ns;
--        clock <= GND;
--        wait for 5 ns;

        
		-- case 1 (Read r0 -> port1, r5 -> port2)
--		write_enable <= GND;
--        rd_addr1 <= reg0;
--        rd_addr2 <= reg5;
        
--		wait for 1 ns;
--		assert (rd_data1 = "0101") report "Error : Can't read 0b0101 from reg0 on port0";
--        assert (rd_data2 = "0001") report "Error : Can't read 0b0001 from reg5 on port1";
--        assert (rd_data1_xor_data2 = "0100") report "Error : Incorrect XOR output on rd_data1_xor_data2";
		
--		if (rd_data1/="0101" or rd_data2/="0001" or rd_data1_xor_data2/="0100") then
--			 err_cnt := err_cnt + 1;
--		end if;
--		wait for 10 ns;

		-- pre-case 2 (Write 5 to r0)
--		wait for 10 ns;
--        mode <= SUPPLY;
--        wr_addr <= reg3;
--        rd_addr1 <= reg0;
--        rd_addr2 <= reg5;
--        wr_data <= "1111";
--        write_enable <= SUPPLY;
        
--        clock <= GND;
--       wait for 5 ns;
--      clock <= SUPPLY;
--        wait for 5 ns;
--        clock <= GND;
--        wait for 5 ns;

        
		-- case 2 (Read r3 -> port1)
--		  write_enable <= GND;
--        rd_addr1 <= reg3;
--        rd_addr2 <= reg5;
        
--		wait for 1 ns;
-- 		  assert (rd_data1 = "0100") report "Error : Can't read 0b0100 from reg3 on port0";
--        assert (rd_data2 = "0001") report "Error : Can't read 0b0001 from reg0 on port1";
--        assert (rd_data1_xor_data2 = "0101") report "Error : Incorrect XOR output on rd_data1_xor_data2";
		
--		if (rd_data1/="0100" or rd_data2/="0001" or rd_data1_xor_data2/="0101") then
--			 err_cnt := err_cnt + 1;
--		end if;
--		wait for 10 ns;

		-- pre-case 3 (Write 0s to all regs)
--		  mode <= GND;
--        write_enable <= SUPPLY;
        
--		for test_addr in 0 to 7 loop
--		  wr_data <= std_logic_vector(to_unsigned(test_addr, wr_data'length ));
--		  wr_addr <= std_logic_vector(to_unsigned(test_addr, wr_addr'length ));
		  
--		  clock <= GND;
--        wait for 5 ns;
--        clock <= SUPPLY;
--        wait for 5 ns;
--        clock <= GND;
--        wait for 5 ns;
		
--		end loop;
		
		--case 3
--		for test_addr in 0 to 7 loop
			
--		  rd_addr1 <= std_logic_vector(to_unsigned(test_addr, rd_addr1'length ));
--		  rd_addr2 <= std_logic_vector(to_unsigned(7-test_addr,rd_addr2'length));
		
--		  wait for 1 ns;
 		  
--		  assert (rd_data1 = ("0" & rd_addr1)) report "Error : Invalid value in loop read on port1";
--        assert (rd_data2 = ("0" & rd_addr2)) report "Error : Invalid value in loop read on port2";
--        assert (rd_data1_xor_data2 = ("0" & (rd_addr1 xor rd_addr2))) report "Error : Incorrect XOR output on rd_data1_xor_data2 in case 3";
		
--			if (rd_data1/=("0" & rd_addr1) or rd_data2/=("0" & rd_addr2) or rd_data1_xor_data2/= ("0" & (rd_addr1 xor rd_addr2))) then
--				 err_cnt := err_cnt + 1;
--			end if;
			
		wait for 1 ns;

--		end loop;
		
		
		wait for 10 ns;
        
		-- summary of all the tests
		if (err_cnt=0) then
			 assert false
			 report "Multiplier works fine"
			 severity note;
		else
			 assert false
			 report "Something wrong, try again"
			 severity error;
		end if;

      WAIT; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***


END;


