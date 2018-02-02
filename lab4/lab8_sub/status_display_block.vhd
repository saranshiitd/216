----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.10.2017 16:48:58
-- Design Name: 
-- Module Name: status_display_block - Behavioral
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


--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bit_to_cathodes is
    Port ( cathode : out  STD_LOGIC_VECTOR (6 downto 0);
           bin : in  STD_LOGIC_VECTOR (3 downto 0));
end bit_to_cathodes;

architecture Behavioral of bit_to_cathodes is
begin
	with bin select
		cathode<="1000000" when "0000",
					"1111001" when "0001",
					"0100100" when "0010",
					"0110000" when "0011",
					"0011001" when "0100",
					"0100011" when "0101", -- mapping it to o
					"1100011" when "0110", -- mapping it to u 
					"0100111" when "0111", -- mapping it to c
					"0000000" when "1000",
					"0010000" when "1001",
					"0001000" when "1010",
					"0000011" when "1011",
					"1000110" when "1100",
					"0100001" when "1101",
					"0000110" when "1110",
					"0111111" when others;
--	case bin is 
--		when "0000" => cathode<= "0111111";
--		when "0001" => cathode<= "0000110";
--		when "0010" => cathode<= "1011011";
--		when "0011" => cathode<= "1001111";
--		when "0100" => cathode<= "1100110";
--		when "0101" => cathode<= "1101101";
--		when "0110" => cathode<= "1111101";
--		when "0111" => cathode<= "0000111";
--		when "1000" => cathode<= "1111111";
--		when "1001" => cathode<= "1101111";
--		when "1010" => cathode<= "1110111";
--		when "1011" => cathode<= "1111100";
--		when "1100" => cathode<= "1111001";
--		when "1101" => cathode<= "1011110";
--		when "1110" => cathode<= "1111001";
--		when "1111" => cathode<= "1110001";
--	end case;


end Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity slow_clock is
	Port ( clk: in std_logic;
			 slow_clk : out std_logic);
end slow_clock;

architecture clk_behaviour of slow_clock is
	signal scaler :STD_LOGIC_VECTOR(16 downto 0) :="11111111111111110";
	signal counter :STD_LOGIC_VECTOR(16 downto 0) :=(others =>'0');
	signal newClock : std_logic :='0';
	
begin 
	slow_clk<=newClock;
	
	countClock:process(clk,newClock)
	begin
		if rising_edge(clk) then 
			counter<=counter + 1 ;
			if(counter>scaler) then 
				newClock<=not newClock;
				
				counter<=(others =>'0');
			end if;
		end if;
	end process ; 
end clk_behaviour;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clocking is
	Port( clk: in std_logic;
			pushbutton: in std_logic;
			output_clk: out std_logic
			);
end clocking;

architecture out_clock of clocking is
component slow_clock is
 port(
		clk : in std_logic;
		slow_clk : out std_logic
		);
	end component;
	signal tempClk : std_logic;

begin
slowing : slow_clock port map
		(clk=>clk,
		slow_clk=>tempClk
		);
	 
		with pushbutton select
			output_clk<=clk when '1',
						tempClk when others;
	
end out_clock;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity select_anode is
	Port(
		clk: in std_logic;
		anode: out STD_LOGIC_VECTOR(3 downto 0)
		);
end select_anode;

architecture selecting of select_anode is
	TYPE State_type is (D,B,C,A);
	signal y_present : State_type;
	signal y_next : State_type :=A;
begin 
	process(y_present)
	Begin
		case y_present is
			when A =>
				y_next<=B;
				anode<="1110";
			when B =>
				y_next<=C;
				anode<="1101";
			when C =>
				y_next<=D;
				anode<="1011";
				
			when D =>
				y_next<=A;
				anode<="0111";
		end case;
	end process;
	process(clk)
	Begin
		if rising_edge(clk) then 
			y_present<=y_next ;
		end if;
	end process;
end selecting;
	
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity selector is
	Port(
		number: in STD_LOGIC_VECTOR(15 downto 0);
		anode: in STD_LOGIC_VECTOR(3 downto 0);
		bin: out STD_LOGIC_VECTOR(3 downto 0)
		);
end selector;

architecture getBin of selector is
begin
	with anode select
	bin<=number(15 downto 12) when "0111",
		 number(11 downto 8) when "1011",
	     number(7 downto 4) when "1101",
	     number(3 downto 0) when others;
end getBin;	
	
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lab4_seven_segment_display is
	Port(
		clk: in std_logic;
		b : in STD_LOGIC_VECTOR(15 downto 0);
		pushbutton: in std_logic;
		anode : out STD_LOGIC_VECTOR(3 downto 0);
		cathode : out STD_LOGIC_VECTOR(6 downto 0)
		);
end lab4_seven_segment_display;

architecture display of lab4_seven_segment_display is
component selector is
	Port(
		number: in STD_LOGIC_VECTOR(15 downto 0);
		anode: in STD_LOGIC_VECTOR(3 downto 0);
		bin: out STD_LOGIC_VECTOR(3 downto 0)
		
		);
		end component;
component clocking is
	Port( clk: in std_logic;
			pushbutton: in std_logic;
			output_clk: out std_logic
			);
	end component;
component bit_to_cathodes is
    Port ( cathode : out  STD_LOGIC_VECTOR (6 downto 0);
           bin : in  STD_LOGIC_VECTOR (3 downto 0));
	end component;
component select_anode is
	Port(
		clk: in std_logic;
		anode: out STD_LOGIC_VECTOR(3 downto 0)
		);
end component;
signal tempClock : std_logic;
signal tempBin : STD_LOGIC_VECTOR(3 downto 0);
signal tempAnode : STD_LOGIC_VECTOR(3 downto 0);
begin 
	clocker: clocking port map
	(
	clk=>clk,
	pushbutton=>pushbutton,
	output_clk=>tempClock
	);
	anode_selector: select_anode port map
	(
	clk=>tempCLock,
	anode=>tempAnode
	);
	select_nos: selector port map
	(
	number=>b,
	anode=>tempAnode,
	bin=>tempBin
	);
	getCathodes: bit_to_cathodes port map
	(
	cathode=>cathode,
	bin=>tempBin
	);
	anode<=tempAnode;
	
end display;






--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity status_display_block is Port(

	lift1_status :in std_logic_vector(6 downto 0);
	lift2_status :in std_logic_vector(6 downto 0);
	anode: out std_logic_vector(3 downto 0);
	cathode: out std_logic_vector(6 downto 0);
	clk : in std_logic
--	b: out std_logic_vector(15 downto 0);
--	up_request_output:out std_logic_vector(3 downto 0);
--	down_request_output: out std_logic_vector(3 downto 0)
	
);

end status_display_block;

architecture Behavioral of status_display_block is

component lab4_seven_segment_display is
	port(
		clk: in std_logic;
		b : in STD_LOGIC_VECTOR(15 downto 0);
		pushbutton: in std_logic;
		anode : out STD_LOGIC_VECTOR(3 downto 0);
		cathode : out STD_LOGIC_VECTOR(6 downto 0)
		);
end component;
signal b: std_logic_vector(15 downto 0);
--	"0100011" when "0101", -- mapping it to o
--					"1100011" when "0110", -- mapping it to u 
--					"0100111" when "0111", -- mapping it to c
begin
	b(15 downto 12)<="1101" when lift1_status(2 downto 0) = "101" else -- because 13 is d in hexa
						  "0101" when lift1_status(2 downto 0) = "000" else  -- o 
                              "0111" when lift1_status(2 downto 0) = "011" else  -- c
                              "0110" when lift1_status(2 downto 0) = "100" else  -- u
                              "0111" when lift1_status(2 downto 0) = "001"; --c
	b(7 downto 4)<="1101" when lift2_status(2 downto 0) = "101" else -- because 13 is d in hexa
						  "0101" when lift2_status(2 downto 0) = "000" else  -- o 
						  "0111" when lift2_status(2 downto 0) = "011" else  -- c
						  "0110" when lift2_status(2 downto 0) = "100" else  -- u
						  "0111" when lift2_status(2 downto 0) = "001"; --c
	
        
	b(11 downto 8)  <="0000" when lift1_status(6 downto 5) ="00" else
						  "0001" when lift1_status(6 downto 5) = "01" else
						  "0010" when lift1_status(6 downto 5) = "10" else 
						  "0011" when lift1_status(6 downto 5)="11";
	b(3 downto 0)  <="0000" when lift2_status(6 downto 5) ="00" else
						  "0001" when lift2_status(6 downto 5) = "01" else
						  "0010" when lift2_status(6 downto 5) = "10" else 
						  "0011" when lift2_status(6 downto 5)="11";						
	display: lab4_seven_segment_display port map
				(
					b=>b,
					cathode=>cathode,
					anode=>anode,
					clk=>clk,
					pushbutton=>'0'
				
				
				);
						
--b (input to ssd) is found by parsing lift1_status and lift2_status appropriately

--up_requests and down_requests (obtained from request_controller) can be directly mapped
-- to up_request_output and down_request_output



end Behavioral;


---
