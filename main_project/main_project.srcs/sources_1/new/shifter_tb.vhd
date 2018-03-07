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

ENTITY shifter_tb IS
END shifter_tb;
ARCHITECTURE behavioral OF shifter_tb IS

  COMPONENT shifter is port(

    input : in std_logic_vector(31 downto 0)  ;
    shift_amount : in std_logic_vector(4 downto 0) ;
    shift_type : in std_logic_vector(1 downto 0) ;
    output : out std_logic_vector(31 downto 0) 
     );
   END COMPONENT;

	signal input :  std_logic_vector(31 downto 0) := (others => '0') ;
	signal shift_amount :  std_logic_vector(4 downto 0) := (others => '0');
	signal shift_type :  std_logic_vector(1 downto 0) := (others => '0');
	signal output :  std_logic_vector(31 downto 0) := (others => '0');

	
BEGIN

 

	shifter_inst: shifter PORT MAP(
	input => input ,
	shift_amount => shift_amount ,
	shift_type => shift_type ,
	output => output 
	
);
-- *** Test Bench - User Defined Section ***
   tb : PROCESS
	variable err_cnt : integer := 0;
--	variable s : line;
--	constant GND : STD_LOGIC := '0';
--	constant SUPPLY : STD_LOGIC := '1';
--	constant reg0 : STD_LOGIC_VECTOR(2 downto 0) := "000";
--	constant reg1 : STD_LOGIC_VECTOR(2 downto 0) := "001";
--	constant reg2 : STD_LOGIC_VECTOR(2 downto 0) := "010";
--	constant reg3 : STD_LOGIC_VECTOR(2 downto 0) := "011";
--	constant reg4 : STD_LOGIC_VECTOR(2 downto 0) := "100";
--	constant reg5 : STD_LOGIC_VECTOR(2 downto 0) := "101";
--	constant reg6 : STD_LOGIC_VECTOR(2 downto 0) := "110";
--	constant reg7 : STD_LOGIC_VECTOR(2 downto 0) := "111";
--	variable test_addr : INTEGER := 0;

    constant tc_lsl4 : std_logic_vector(31 downto 0) := "00000100101101010110010010100101";
    constant result_lsl4 : std_logic_vector(31 downto 0) := "01001011010101100100101001010000";
    constant tc_lsr6 : std_logic_vector(31 downto 0) := "00000100101101010110010010100101";
    constant result_lsr6 : std_logic_vector(31 downto 0) := "00000000000100101101010110010010";
    constant tc_ror3 : std_logic_vector(31 downto 0) := "10101100101101010110010010100101" ; 
    constant result_ror3 : std_logic_vector(31 downto 0) := "10110101100101101010110010010100" ;
    constant tc_asrp4 : std_logic_vector(31 downto 0) := "01111100101101010110010010100101" ;
    constant result_asrp4 : std_logic_vector(31 downto 0) :=  "00000111110010110101011001001010" ; 
    constant tc_asrn4 : std_logic_vector(31 downto 0) := "11111100101101010110010010100101" ;
    constant result_asrn4 : std_logic_vector(31 downto 0) :=  "11111111110010110101011001001010" ; 
    
   BEGIN

		
		wait for 10 ns;
--        mode <= GND;
--        wr_addr <= reg0;
--        rd_addr1 <= reg0;
--        rd_addr2 <= reg0;
--        wr_data <= "0101";
--        write_enable <= SUPPLY;

    
    input <= tc_lsl4 ; 
    shift_amount <= std_logic_vector(to_unsigned(4,5)) ; 
    shift_type <= "01" ;
    wait for 5 ns ;
    assert (output = result_lsl4) report "Failed lsl";
    if (output /= result_lsl4) then
       err_cnt := err_cnt + 1;
    end if;
    wait for 5 ns ;
    
    input <= tc_lsr6 ; 
    shift_amount <= std_logic_vector(to_unsigned(6,5)) ; 
    shift_type <= "00" ;
    wait for 5 ns ;
    assert (output = result_lsr6) report "Failed lsr";
    if (output /= result_lsr6) then
       err_cnt := err_cnt + 1;
    end if;
    wait for 5 ns ;
    
    input <= tc_ror3 ; 
    shift_amount <= std_logic_vector(to_unsigned(3,5)) ; 
    shift_type <= "11" ;
    wait for 5 ns ;
    assert (output = result_ror3) report "Failed ror";
    if (output /= result_ror3) then
       err_cnt := err_cnt + 1;
    end if;
    wait for 5 ns ;
    
    input <= tc_asrp4 ; 
    shift_amount <= std_logic_vector(to_unsigned(4,5)) ; 
    shift_type <= "10" ;
    wait for 5 ns ;
    assert (output = result_asrp4) report "Failed asrp";
    if (output /= result_asrp4) then
       err_cnt := err_cnt + 1;
    end if;
    wait for 5 ns ;

    input <= tc_asrn4 ; 
    shift_amount <= std_logic_vector(to_unsigned(4,5)) ; 
    shift_type <= "10" ;
    wait for 5 ns ;
    assert (output = result_asrn4) report "Failed asrn";
    if (output /= result_asrn4) then
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
--        write_enable <= GND;
--        rd_addr1 <= reg0;
--        rd_addr2 <= reg0;
   
--        wait for 1 ns;
--        assert (rd_data1 = "0101") report "Error : Can't read 0b0101 from reg0 on port0";
--        assert (rd_data2 = "0101") report "Error : Can't read 0b0101 from reg0 on port1";
--        assert (rd_data1_xor_data2 = "0000") report "Error : Incorrect XOR output on rd_data1_xor_data2";
   
--        if (rd_data1/="0101" or rd_data2/="0101" or rd_data1_xor_data2/="0000") then
--             err_cnt := err_cnt + 1;
--        end if;
   
   -- pre-case 1 (Write 5 to r0)
--        wait for 10 ns;
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
--        write_enable <= GND;
--        rd_addr1 <= reg0;
--        rd_addr2 <= reg5;
   
--        wait for 1 ns;
--        assert (rd_data1 = "0101") report "Error : Can't read 0b0101 from reg0 on port0";
--        assert (rd_data2 = "0001") report "Error : Can't read 0b0001 from reg5 on port1";
--        assert (rd_data1_xor_data2 = "0100") report "Error : Incorrect XOR output on rd_data1_xor_data2";
   
--        if (rd_data1/="0101" or rd_data2/="0001" or rd_data1_xor_data2/="0100") then
--             err_cnt := err_cnt + 1;
--        end if;
--        wait for 10 ns;

   -- pre-case 2 (Write 5 to r0)
--        wait for 10 ns;
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
--          write_enable <= GND;
--        rd_addr1 <= reg3;
--        rd_addr2 <= reg5;
   
--        wait for 1 ns;
--           assert (rd_data1 = "0100") report "Error : Can't read 0b0100 from reg3 on port0";
--        assert (rd_data2 = "0001") report "Error : Can't read 0b0001 from reg0 on port1";
--        assert (rd_data1_xor_data2 = "0101") report "Error : Incorrect XOR output on rd_data1_xor_data2";
   
--        if (rd_data1/="0100" or rd_data2/="0001" or rd_data1_xor_data2/="0101") then
--             err_cnt := err_cnt + 1;
--        end if;
--        wait for 10 ns;

   -- pre-case 3 (Write 0s to all regs)
--          mode <= GND;
--        write_enable <= SUPPLY;
   
--        for test_addr in 0 to 7 loop
--          wr_data <= std_logic_vector(to_unsigned(test_addr, wr_data'length ));
--          wr_addr <= std_logic_vector(to_unsigned(test_addr, wr_addr'length ));
     
--          clock <= GND;
--        wait for 5 ns;
--        clock <= SUPPLY;
--        wait for 5 ns;
--        clock <= GND;
--        wait for 5 ns;
   
--        end loop;
   
   --case 3
--        for test_addr in 0 to 7 loop
       
--          rd_addr1 <= std_logic_vector(to_unsigned(test_addr, rd_addr1'length ));
--          rd_addr2 <= std_logic_vector(to_unsigned(7-test_addr,rd_addr2'length));
   
--          wait for 1 ns;
      
--          assert (rd_data1 = ("0" & rd_addr1)) report "Error : Invalid value in loop read on port1";
--        assert (rd_data2 = ("0" & rd_addr2)) report "Error : Invalid value in loop read on port2";
--        assert (rd_data1_xor_data2 = ("0" & (rd_addr1 xor rd_addr2))) report "Error : Incorrect XOR output on rd_data1_xor_data2 in case 3";
   
--            if (rd_data1/=("0" & rd_addr1) or rd_data2/=("0" & rd_addr2) or rd_data1_xor_data2/= ("0" & (rd_addr1 xor rd_addr2))) then
--                 err_cnt := err_cnt + 1;
--            end if;
       
   wait for 1 ns;

--        end loop;
   
   
   wait for 10 ns;
   
   -- summary of all the tests
   if (err_cnt=0) then
        assert false
        report "shifter works fine"
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


