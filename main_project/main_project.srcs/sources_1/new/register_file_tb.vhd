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

ENTITY reg_file_tb IS
END reg_file_tb;
ARCHITECTURE behavioral OF reg_file_tb IS

	component Register_File is
	  Port ( 
	    input_data : in std_logic_vector(31 downto 0);
	    read_addr_1 : in std_logic_vector(3 downto 0);
	    read_addr_2 : in std_logic_vector(3 downto 0);
	    write_addr : in std_logic_vector(3 downto 0);
	    clk : in std_logic ;
	    reset : in std_logic ;
	    write_enable : in std_logic ; 
	    output_1 : out std_logic_vector(31 downto 0);
	    output_2 : out std_logic_vector(31 downto 0);
	    pc_output : out std_logic_vector(31 downto 0);
	    pc_input : in std_logic_vector(31 downto 0) ;
	    write_enable_pc : in std_logic 
	  );
	end component;

	signal input_data :  std_logic_vector(31 downto 0) := (others => '0') ;
	signal read_addr_1 :  std_logic_vector(3 downto 0) := (others => '0') ;
	signal read_addr_2 :  std_logic_vector(3 downto 0) := (others => '0') ;
	signal write_addr :  std_logic_vector(3 downto 0) := (others => '0') ;
	signal clk :  std_logic := '0' ;
	signal reset :  std_logic := '0';
	signal write_enable :  std_logic := '0' ; 
	signal output_1 :  std_logic_vector(31 downto 0) := (others => '0') ;
	signal output_2 :  std_logic_vector(31 downto 0) := (others => '0') ;
	signal pc_output : std_logic_vector(31 downto 0) := (others => '0') ;
	signal pc_input :  std_logic_vector(31 downto 0) := (others => '0') ;
	signal write_enable_pc :  std_logic ;
    signal err_cnt_signal : integer ;
--    signal clock : std_logic := '0' ;
    constant clk_period : time := 10 ns ;
    constant wait_time : time := 50 ns ;
BEGIN

  rf_inst: register_file PORT MAP(
    input_data => input_data ,
    read_addr_1 => read_addr_1,
    read_addr_2 => read_addr_2,
    write_addr => write_addr,
    clk => clk ,
    reset => reset ,
    write_enable => write_enable , 
    output_1 => output_1,
    output_2 => output_2,
    pc_output => pc_output ,
    pc_input => pc_input ,
    write_enable_pc => write_enable_pc
);

   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
-- *** Test Bench - User Defined Section ***
   tb : PROCESS
	variable err_cnt : integer := 0;
	variable s : line;
    constant write_addr1_tc1 : std_logic_vector(3 downto 0 ):= "0000" ;
    constant write_addr2_tc1 : std_logic_vector(3 downto 0 ):= "0001" ;
    constant read_addr1_tc1 : std_logic_vector(3 downto 0) := "0000" ;
    constant read_addr2_tc1 : std_logic_vector(3 downto 0) := "0001" ;
    constant input_data1_tc1 : std_logic_vector(31 downto 0) := "00000000000011000000110100011101" ;
    constant input_data2_tc1 : std_logic_vector(31 downto 0) := "11000000000011000000110100011101" ;
    constant pc_input_tc3 : std_logic_vector(31 downto 0) := "00000000000010111110001000101010" ;
    constant zero : std_logic_vector(31 downto 0) := (others => '0') ;
    
   BEGIN

		wait for 10 ns;
		
		input_data <= input_data1_tc1 ;
		write_addr <= write_addr1_tc1 ; 
		read_addr_1 <= read_addr1_tc1 ; 
		read_addr_2 <= read_addr2_tc1 ; 
		write_enable <= '1' ;
		
		wait for wait_time ;
		
		input_data <= input_data2_tc1 ;
        write_addr <= write_addr2_tc1 ; 
        read_addr_1 <= read_addr1_tc1 ; 
        read_addr_2 <= read_addr2_tc1 ; 
        write_enable <= '1' ;
        
   		wait for wait_time ;

		
		assert (output_1 = input_data1_tc1) report "reg_file_error Failed writing or reading addr1";
        if (output_1 /= input_data1_tc1) then
            err_cnt := err_cnt + 1;
        end if;
        wait for 5 ns ;
		assert (output_2 = input_data2_tc1) report "reg_file_error Failed writing or reading addr2";
        if (output_2 /= input_data2_tc1) then
            err_cnt := err_cnt + 1;
        end if;
        wait for 5 ns ;		
	       
	    input_data <= input_data2_tc1 ;
        write_addr <= write_addr1_tc1 ; 
        read_addr_1 <= read_addr1_tc1 ; 
        read_addr_2 <= read_addr2_tc1 ; 
        write_enable <= '0' ;
		wait for wait_time ;
		
		assert (output_1 /= input_data2_tc1) report "reg_file_error writing in write_disabled";
        if (output_1 = input_data2_tc1) then
            err_cnt := err_cnt + 1;
        end if;
        wait for 5 ns ;    		
        
        pc_input <= pc_input_tc3 ; 
        write_enable_pc <= '1' ;
        
        wait for wait_time ; 
        
        assert(pc_output = pc_input_tc3) report "reg_file_error pc not written properly" ; 
        if (pc_output /= pc_input_tc3) then
            err_cnt := err_cnt + 1;
        end if;
        wait for 5 ns ;            
        
        write_enable_pc <= '0' ; 
        pc_input <= input_data2_tc1 ;
        
	    wait for wait_time ;
		
        assert(pc_output = pc_input_tc3) report "reg_file_error pc written when write_pc disabled" ; 
        if (pc_output /= pc_input_tc3) then
            err_cnt := err_cnt + 1;
        end if;
        wait for 5 ns ;            
		
		
		reset <= '1' ; 
		wait for wait_time ;
		
		assert (pc_output = zero) report "reg_file_error reset not working";
        if (pc_output /= zero) then
            err_cnt := err_cnt + 1;
        end if;
        wait for 5 ns ;            
		
--        mode <= GND;  
--        wr_addr <= reg0;
--        rd_addr1 <= reg0;
--        rd_addr2 <= reg0;
--        wr_data <= "0101";
--        write_enable <= SUPPLY;
   
   
   
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
--        assert (rd_data1 = "0101") report "Error :an't read 0b0101 from reg0 on port0";
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
        report "reg_file works fine"
        severity note;
   else
        assert false
        report "reg_file_error Something wrong, try again"
        severity error;
   end if;

 WAIT; -- will wait forever
END PROCESS;
-- *** End Test Bench - User Defined Section ***


END;


