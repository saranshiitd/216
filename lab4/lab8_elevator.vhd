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




----------------------------------------------------------------------------------
-- Sushant Rathi, Saransh Verma 
-- 
-- Create Date: 29.09.2017 18:50:21
-- Design Name: 
-- Module Name: lab8_elevator - Behavioral
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

---

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity lift1_controller is
Port(
    lift_floor : in std_logic_vector(3 downto 0); -- requests from inside the lift
    lift_status: out std_logic_vector(6 downto 0); --status is (current/previous floor, request_state, lift_state) where request_state is reqUp/reqDown/Idle 
                                                    -- and lift_state can be moving up/ moving down/ halted with door open/ halted with door closed
    req_handler_floors: in std_logic_vector(3 downto 0); --destination floors communicated by request handler
    door_open: in std_logic;
    door_closed: in std_logic;
    req_indicator:out std_logic_vector(3 downto 0);
    lift_floor_indicator: out std_logic_vector(3 downto 0);
    reset: in std_logic;
    clk: in std_logic
);
end lift1_controller;

architecture Behavioral of lift1_controller is


signal requests: std_logic_vector(3 downto 0):="0000";--union of lift1_floor &  req_handler_floors
signal req_handler_requests: std_logic_vector(3 downto 0):="0000";--requests from req_handler
signal floor_requests: std_logic_vector(3 downto 0):="0000";--requests from inside the lift
signal curr_floor: std_logic_vector(1 downto 0):="00";-- current/previous floor 
signal req_state: std_logic_vector(1 downto 0):="00";--goUp/goDown/Idle
signal lift_state: std_logic_vector(2 downto 0):="000";-- moving up/ moving down/  door opening/ door closing/waiting
signal counter: std_logic_vector(30 downto 0):=(others=>'0');--for time delay
signal change_state: std_logic :='0';--to decide whether lift_state needs to be changed or not (set after counter has reached its max value)
signal door_open_signal: std_logic := '0';
signal door_close_signal: std_logic := '0';
begin
req_indicator<=req_handler_requests;
lift_floor_indicator<=floor_requests;
lift_status<=curr_floor & req_state & lift_state;
main:process(clk) begin
  --if counter is 0, change lift_state 
  --req_state and curr_floor might also have to be change based on certain conditions
  --floor will be change if previous lift_state was going up /going down (as a new floor has been reached)       
  --req_state must be changed whenever the previous lift_state was 'halted with door closed'
  --new req_state is decided based on previous req_state, lift_state and current pending requests 
  --requests signal is updated according to request completed
  
  
  
  if(rising_edge(clk)) then
  
    --requests<= (requests or lift1_floor) or req_handler_floors;
     -- floor_requests<= floor_requests or lift1_floor;
      --req_handler_requests<= req_handler_requests or req_handler_floors;
      if(lift_floor(0)='1' or req_handler_floors(0)='1') then
        requests(0)<='1';
      elsif(lift_floor(1)='1' or req_handler_floors(1)='1') then
                requests(1)<='1';
      elsif(lift_floor(2)='1' or req_handler_floors(2)='1') then
                        requests(2)<='1';
      elsif(lift_floor(3)='1' or req_handler_floors(3)='1') then
                                requests(3)<='1';
      end if;
      
      if(lift_floor(0)='1') then
            floor_requests(0)<='1';
      elsif(lift_floor(1)='1') then
            floor_requests(1)<='1';
      elsif(lift_floor(2)='1') then
            floor_requests(2)<='1';
      elsif(lift_floor(3)='1') then
                 floor_requests(3)<='1';
      end if;                          
      
      if(req_handler_floors(0)='1') then
            req_handler_requests(0)<='1';
      elsif(req_handler_floors(1)='1') then
                        req_handler_requests(1)<='1';
      elsif(req_handler_floors(2)='1') then
                        req_handler_requests(2)<='1';
      elsif(req_handler_floors(3)='1') then
                        req_handler_requests(3)<='1';
      end if;                                                                                          
                                                       
      if(door_open='1') then 
        if(lift_state="001") then --if lift is in closing state
            door_open_signal<='1';
        end if;
      end if;
      if(door_closed='1') then 
        if(lift_state="000") then  --if lift is in waiting state
            door_close_signal<='1';
        end if;
      end if;
  
  
  
    if(change_state='1') then
        --lift_state transition
        if(lift_state="011") then 
            lift_state<="000";  --door open to waiting transition
            --update requests
        elsif (lift_state="000") then  --if waiting finished
            if(requests/="0000") then --and requests are remaining
                        lift_state<="001";  --transition to door closing
                        if(req_state="01" ) then
                            if (not  ((curr_floor="00" and (requests(1)='1' or requests(2)='1' or requests(3)='1')) or 
                            (curr_floor="01" and (requests(2)='1' or requests(3)='1')) or 
                                (curr_floor="10" and requests(3)='1') )  )  then  --check if there is request from any of the above floors 
                                req_state<="11";  --if not, change req_state to going down
                            end if;
                        elsif(req_state="11") then
                            if (not  ((curr_floor="01" and (requests(0)='1')) or 
                                (curr_floor="10" and (requests(1)='1' or requests(0)='1')) or 
                               (curr_floor="11" and (requests(0)='1' or requests(1)='1' or requests(2)='1') ) )  )  then  --check if there is request from any of the below floors 
                                    req_state<="01";  --if not, change req_state to going up
                           end if;
                        else --if idle
                            if ((curr_floor="00" and (requests(1)='1' or requests(2)='1' or requests(3)='1')) or 
                                     (curr_floor="01" and (requests(2)='1' or requests(3)='1')) or 
                                  (curr_floor="10" and requests(3)='1') )    then  --check if there is request from any of the above floors 
                                       req_state<="01";  --if there is, change req_state to going up
                            elsif ((curr_floor="01" and (requests(0)='1')) or 
                                    (curr_floor="10" and (requests(1)='1' or requests(0)='1')) or 
                                 (curr_floor="11" and (requests(0)='1' or requests(1)='1' or requests(2)='1') ) ) then --check for requests from below floor
                              req_state<="11"; --else change it to going down
                            else
                              requests(to_integer(unsigned(curr_floor)))<='0';
                              if(req_handler_requests(to_integer(unsigned(curr_floor)))='1') then --if outside request, update it to update the 
                                  req_handler_requests(to_integer(unsigned(curr_floor)))<='0'; --indicator signal on output.
                               end if;
                               if(floor_requests(to_integer(unsigned(curr_floor)))='1') then --if floor request, update it to update the 
                                  floor_requests(to_integer(unsigned(curr_floor)))<='0'; --floor request indicator signal on output.
                               end if;
                               lift_state<="000";
                              req_state<="00"; --else remain idle
                            end if;
                        end if;    
                        else
                            req_state<="00"; --change it to idle state   
                        end if;
                        
        elsif(lift_state="001") then 
            --door is closed, now go up/down
            if(req_state="01") then --serving up request
                lift_state<="100"; --go up
            elsif(req_state="11") then
                lift_state<="101"; --else go down
            end if;
        elsif(lift_state="101") then --going down finished
            curr_floor<= std_logic_vector(to_unsigned(to_integer(unsigned(curr_floor))-1,2));--change lift floor
            if(requests(to_integer(unsigned(curr_floor))-1)='1') then --if floor is in requests, stop!
                lift_state<="011"; --transition to door opening state
                requests(to_integer(unsigned(curr_floor))-1)<='0';
                if(req_handler_requests(to_integer(unsigned(curr_floor))-1)='1') then --if outside request, update it to update the 
                    req_handler_requests(to_integer(unsigned(curr_floor))-1)<='0'; --indicator signal on output.
                end if;
                if(floor_requests(to_integer(unsigned(curr_floor))-1)='1') then --if floor request, update it to update the 
                    floor_requests(to_integer(unsigned(curr_floor))-1)<='0'; --floor request indicator signal on output.
                end if;
            end if;
        elsif(lift_state="100") then --going up finished
              curr_floor<= std_logic_vector(to_unsigned(to_integer(unsigned(curr_floor))+1,2));--change lift floor
              if(requests(to_integer(unsigned(curr_floor))+1)='1') then --if floor is in requests, stop!
                 lift_state<="011"; --transition to door opening state
                 requests(to_integer(unsigned(curr_floor))+1)<='0';
                 if(req_handler_requests(to_integer(unsigned(curr_floor))+1)='1') then --if outside request, update it to update the 
                    req_handler_requests(to_integer(unsigned(curr_floor))+1)<='0'; --indicator signal on output.
                 end if;
                 if(floor_requests(to_integer(unsigned(curr_floor))+1)='1') then --if floor request, update it to update the 
                    floor_requests(to_integer(unsigned(curr_floor))+1)<='0'; --floor request indicator signal on output.
                 end if;
                 
            end if;
        
        end if;            
            --else continue 
        change_state<='0';
        
   else
  --increment counter and based on lift_state check if counter has reached its max value
  --once max value has been reached, reset counter to 0 to indicate to main process to change lift_state
  --door_open and door_closed can reset counter to 0
     --if((lift_state="000" and counter(4)='1') or (lift_state="100" and counter(5)='1') or (lift_state="101" and counter(5)='1') or (lift_state="011" and counter(3)='1') or (lift_state="001" and counter(3)='1')) then
        
      if((lift_state="000" and counter(27)='1') or (lift_state="100" and counter(28)='1') or (lift_state="101" and counter(28)='1') or (lift_state="011" and counter(27)='1') or (lift_state="001" and counter(27)='1')) then
         counter<=(others=>'0');
         change_state<='1';
         --door_open_signal<='0';
         --door_close_signal<='0';
      elsif door_open_signal='1' then
         counter<=(others=>'0'); 
         lift_state<="011";--change to door opening state
         door_open_signal<='0';
      elsif door_close_signal='1' then
         counter<=(others=>'0');
         change_state<='1';
         --lift_state<="001";--change to door closing state
         door_close_signal<='0';
      else
         counter<=std_logic_vector(to_unsigned(to_integer(unsigned(counter))+1,31));
            
      end if;
    end if;
  end if;
  if(reset='1') then
    change_state<='0';
    counter<=(others=>'0');
    curr_floor<="00";
    lift_state<="000";
    req_state<="00";
    requests<="0000";
    req_handler_requests<="0000";
    floor_requests<="0000";
  end if;
  end process;

end Behavioral;

---


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity request_handler is
Port(
    up_request : in std_logic_vector(3 downto 0); -- up requests
    down_request: in std_logic_vector(3 downto 0);--down requests 
    reset: in std_logic; --reset to predefined state
    lift1_status: in std_logic_vector(6 downto 0);
    lift2_status:in std_logic_vector(6 downto 0);
    lift1_requests: out std_logic_vector(3 downto 0);--destination floors for lift1
    lift2_requests: out std_logic_vector(3 downto 0);--destination floors for lift 2
    up_requests_pending: out std_logic_vector(3 downto 0);--all requests not yet completed 
    down_requests_pending: out std_logic_vector(3 downto 0);
    clk: in std_logic;
    lift1_up : out std_logic_vector(3 downto 0);
    lift2_up : out std_logic_vector(3 downto 0);
    lift2_down : out std_logic_vector(3 downto 0);
    lift1_down : out std_logic_vector(3 downto 0)
    
    
);
end request_handler;

architecture Behavioral of request_handler is
signal curr_up_requests: std_logic_vector(3 downto 0):="0000";-- all up requests pending for assignment
signal curr_down_requests: std_logic_vector(3 downto 0):="0000"; -- all down requests pending for assignment
signal up_requests_remaining: std_logic_vector(3 downto 0):="0000";-- all up requests pending for completion
signal down_requests_remaining: std_logic_vector(3 downto 0):="0000";-- all down requests pending for completion
signal UpReqUpL1 : std_logic_vector(3 downto 0):="0000" ;
signal DownReqUpL1 : std_logic_vector(3 downto 0):="0000" ;
signal UpReqDownL1 : std_logic_vector(3 downto 0):="0000" ;
signal DownReqDownL1 : std_logic_vector(3 downto 0):="0000" ;
signal UpReqUpL2 : std_logic_vector(3 downto 0):="0000" ;
signal DownReqUpL2 : std_logic_vector(3 downto 0):="0000" ;
signal UpReqDownL2 : std_logic_vector(3 downto 0):="0000" ;
signal DownReqDownL2 : std_logic_vector(3 downto 0):="0000" ;
signal lift1_up_signal: std_logic_vector(3 downto 0):="0000";
signal lift2_up_signal: std_logic_vector(3 downto 0):="0000";
signal lift1_down_signal: std_logic_vector(3 downto 0):="0000";
signal lift2_down_signal: std_logic_vector(3 downto 0):="0000";
signal state : std_logic := '0';
begin

up_requests_pending<=up_requests_remaining;
down_requests_pending<=down_requests_remaining;
lift1_up<=lift1_up_signal;
lift2_up<=lift2_up_signal;
lift1_down<=lift1_down_signal;
lift2_down<=lift2_down_signal;
main:process(clk) begin
    
    
	if rising_edge(clk) then
	
	if(state='0') then
           lift1_requests<="0000";
           lift2_requests<="0000";
           --UpReqUpL1<="0000";
           --DownReqUpL1<="0000";
           --UpReqDownL1<="0000";
           --DownReqDownL1<="0000";
           
           --UpReqUpL2<="0000";
           --DownReqUpL2<="0000";
           --UpReqDownL2<="0000";
           --DownReqDownL2<="0000";
                      
           state<='1';
        if(reset='1') then --reset everything
               curr_up_requests<="0000";
               curr_down_requests<="0000";
               up_requests_remaining<="0000";
               down_requests_remaining<="0000";
               lift1_up_signal<="0000";
               lift1_down_signal<="0000";
               lift2_up_signal<="0000";
               lift2_down_signal<="0000";
                          
            end if;
    else
	if lift1_status(6 downto 5) = "00" then
            lift1_up_signal(0)<='0';
            lift1_down_signal(0)<='0';
        elsif lift1_status(6 downto 5) = "01" then
            lift1_up_signal(1)<='0';
            lift1_down_signal(1)<='0';
        elsif lift1_status(6 downto 5) = "10" then
            lift1_up_signal(2)<='0';
            lift1_down_signal(2)<='0';
        elsif lift1_status(6 downto 5) ="11" then
            lift1_up_signal(3)<='0';
            lift1_down_signal(3)<='0';
        end if;
                if lift2_status(6 downto 5) = "00" then
                    lift2_up_signal(0)<='0';
                    lift2_down_signal(0)<='0';
                elsif lift2_status(6 downto 5) = "01" then
                    lift2_up_signal(1)<='0';
                    lift2_down_signal(1)<='0';
                elsif lift2_status(6 downto 5) = "10" then
                    lift2_up_signal(2)<='0';
                    lift2_down_signal(2)<='0';
                elsif lift2_status(6 downto 5) ="11" then
                    lift2_up_signal(3)<='0';
                    lift2_down_signal(3)<='0';
                end if;
	
	
    --if state ='1' then
        state<='0';
		curr_up_requests<= curr_up_requests or up_request;
		curr_down_requests<=curr_down_requests or down_request;
    --classify each of the up and down requests as upRequp, upReqdown,downRequp or downReqdown for both lifts
	if curr_down_requests(0) ='1' then 
		if lift1_status(6 downto 5) < "00" then
			UpReqDownL1(0)<='1';
			DownReqDownL1(0)<='0';
		else
		    UpReqDownL1(0)<='0'; 
			DownReqDownL1(0)<='1';
		end if;
		if lift2_status(6 downto 5) < "00" then
			UpReqDownL2(0)<='1';
			DownReqDownL2(0)<='0';
		else 
			DownReqDownL2(0)<='1';
			UpReqDownL2(0)<='0';
		end if;
	else 
		UpReqDownL1(0)<='0';
		UpReqDownL2(0)<='0';
		DownReqDownL2(0)<='0';
		DownReqDownL1(0)<='0';
	end if;
	if curr_down_requests(1) ='1' then 
		if lift1_status(6 downto 5) < "01" then
			UpReqDownL1(1)<='1';
			DownReqDownL1(1)<='0';
		else 
			DownReqDownL1(1)<='1';
			UpReqDownL1(1)<='0';
		end if;
		if lift2_status(6 downto 5) < "01" then
			UpReqDownL2(1)<='1';
			DownReqDownL2(1)<='0';
		else 
			DownReqDownL2(1)<='1';
			UpReqDownL2(1)<='0';
		end if;
	else 
		UpReqDownL1(1)<='0';
		UpReqDownL2(1)<='0';
		DownReqDownL2(1)<='0';
		DownReqDownL1(1)<='0';
	end if;
	if curr_down_requests(2) ='1' then 
		if lift1_status(6 downto 5) < "10" then
			UpReqDownL1(2)<='1';
			DownReqDownL1(2)<='0';
		else 
			DownReqDownL1(2)<='1';
		    UpReqDownL1(2)<='0';
		end if;
		if lift2_status(6 downto 5) < "10" then
			UpReqDownL2(2)<='1';
			DownReqDownL2(2)<='0';
		else
		    UpReqDownL2(2)<='0'; 
			DownReqDownL2(2)<='1';
		end if;
	else 
		UpReqDownL1(2)<='0';
		UpReqDownL2(2)<='0';
		DownReqDownL2(2)<='0';
		DownReqDownL1(2)<='0';
	end if;
	if curr_down_requests(3) ='1' then 
		if lift1_status(6 downto 5) < "11" then
			UpReqDownL1(3)<='1';
			DownReqDownL1(3)<='0';
		else
		    UpReqDownL1(3)<='0'; 
			DownReqDownL1(3)<='1';
		end if;
		if lift2_status(6 downto 5) < "11" then
			UpReqDownL2(3)<='1';
			DownReqDownL2(3)<='0';
		else
		    UpReqDownL2(3)<='0'; 
			DownReqDownL2(3)<='1';
		end if;
	else 
		UpReqDownL1(3)<='0';
		UpReqDownL2(3)<='0';
		DownReqDownL2(3)<='0';
		DownReqDownL1(3)<='0';
	end if;
	if curr_up_requests(0) ='1' then 
		if lift1_status(6 downto 5) < "00" then
			UpReqUpL1(0)<='1';
			DownReqUpL1(0)<='0';
		else
		    UpReqUpL1(0)<='0'; 
			DownReqUpL1(0)<='1';
		end if;
		if lift2_status(6 downto 5) < "00" then
			UpReqUpL2(0)<='1';
			DownReqUpL2(0)<='0';
		else
		    UpReqUpL2(0)<='0'; 
			DownReqUpL2(0)<='1';
		end if;
	else 
		UpReqUpL1(0)<='0';
		UpReqUpL2(0)<='0';
		DownReqUpL2(0)<='0';
		DownReqUpL1(0)<='0';
	end if;
	if curr_up_requests(1) ='1' then 
		if lift1_status(6 downto 5) < "01" then
			UpReqUpL1(1)<='1';
			DownReqUpL1(1)<='0';
		else
		    UpReqUpL1(1)<='0'; 
			DownReqUpL1(1)<='1';
		end if;
		if lift2_status(6 downto 5) < "01" then
			UpReqUpL2(1)<='1';
			DownReqUpL2(1)<='0';
		else
		    UpReqUpL2(1)<='0'; 
			DownReqUpL2(1)<='1';
		end if;
	else 
		UpReqUpL1(1)<='0';
		UpReqUpL2(1)<='0';
		DownReqUpL2(1)<='0';
		DownReqUpL1(1)<='0';
	end if;
	if curr_up_requests(2) ='1' then 
		if lift1_status(6 downto 5) < "10" then
			UpReqUpL1(2)<='1';
			DownReqUpL1(2)<='0';
		else 
		    UpReqUpL1(2)<='0';
			DownReqUpL1(2)<='1';
		end if;
		if lift2_status(6 downto 5) < "10" then
			UpReqUpL2(2)<='1';
			DownReqUpL2(2)<='0';
		else
		    UpReqUpL2(2)<='0'; 
			DownReqUpL2(2)<='1';
		end if;
	else 
		UpReqUpL1(2)<='0';
		UpReqUpL2(2)<='0';
		DownReqUpL2(2)<='0';
		DownReqUpL1(2)<='0';
	end if;
	if curr_up_requests(3) ='1' then 
		if lift1_status(6 downto 5) < "11" then
			UpReqUpL1(3)<='1';
			DownReqUpL1(3)<='0';
		else
		    UpReqUpL1(3)<='0';  
			DownReqUpL1(3)<='1';
		end if;
		if lift2_status(6 downto 5) < "11" then
			UpReqUpL2(3)<='1';
			DownReqUpL2(3)<='0';
		else
		    UpReqUpL2(3)<='0'; 
			DownReqUpL2(3)<='1';
		end if;
	else 
		UpReqUpL1(3)<='0';
		UpReqUpL2(3)<='0';
		DownReqUpL2(3)<='0';
		DownReqUpL1(3)<='0';
	end if;
	
	--classification complete
	
	if UpReqUpL1(0) = '1' and lift1_status(4 downto 3) = "01" then
			lift1_up_signal(0)<='1';
			lift1_requests(0)<='1';
			UpReqUpL1(0)<='0';
			DownReqUpL1(0)<='0';
			UpReqUpL2(0)<='0';
			DownReqUpL2(0)<='0';
			curr_up_requests(0)<='0';
	elsif UpReqUpL2(0) = '1' and lift2_status(4 downto 3) = "01" then
	        lift2_up_signal(0)<='1';
			lift2_requests(0)<='1';
			UpReqUpL1(0)<='0';
			DownReqUpL1(0)<='0';
			UpReqUpL2(0)<='0';
			DownReqUpL2(0)<='0';
			curr_up_requests(0)<='0';
	--end if;
	
	elsif UpReqUpL1(3) = '1' and lift1_status(4 downto 3) = "01" then
	       lift1_up_signal(3)<='1';
			lift1_requests(3)<='1';
			UpReqUpL1(3)<='0';
			DownReqUpL1(3)<='0';
			UpReqUpL2(3)<='0';
			DownReqUpL2(3)<='0';
			curr_up_requests(3)<='0';
	elsif UpReqUpL2(3) = '1' and lift2_status(4 downto 3) = "01" then
            lift2_up_signal(3)<='1';
			lift2_requests(3)<='1';
			UpReqUpL1(3)<='0';
			DownReqUpL1(3)<='0';
			UpReqUpL2(3)<='0';
			DownReqUpL2(3)<='0';
			curr_up_requests(3)<='0';
	--end if;
	
	elsif UpReqUpL1(1) = '1' and lift1_status(4 downto 3) = "01" then
			lift1_up_signal(1)<='1';
			lift1_requests(1)<='1';
			UpReqUpL1(1)<='0';
			DownReqUpL1(1)<='0';
			UpReqUpL2(1)<='0';
			DownReqUpL2(1)<='0';
			curr_up_requests(1)<='0';
	elsif UpReqUpL2(1) = '1' and lift2_status(4 downto 3) = "01" then
			lift2_up_signal(1)<='1';
			lift2_requests(1)<='1';
			UpReqUpL1(1)<='0';
			DownReqUpL1(1)<='0';
			UpReqUpL2(1)<='0';
			DownReqUpL2(1)<='0';
			curr_up_requests(1)<='0';
	--end if;
	
	elsif UpReqUpL1(2) = '1' and lift1_status(4 downto 3) = "01" then
	        lift1_up_signal(2)<='1';
			lift1_requests(2)<='1';
			UpReqUpL1(2)<='0';
			DownReqUpL1(2)<='0';
			UpReqUpL2(2)<='0';
			DownReqUpL2(2)<='0';
			curr_up_requests(2)<='0';
	elsif UpReqUpL2(2) = '1' and lift2_status(4 downto 3) = "01" then
			lift2_up_signal(2)<='1';
			lift2_requests(2)<='1';
			UpReqUpL1(2)<='0';
			DownReqUpL1(2)<='0';
			UpReqUpL2(2)<='0';
			DownReqUpL2(2)<='0';
			curr_up_requests(2)<='0';
	--end if;
	
	elsif DownReqDownL1(0) = '1' and lift1_status(4 downto 3) = "11" then
	        lift1_down_signal(0)<='1';
			lift1_requests(0)<='1';
			UpReqDownL1(0)<='0';
			DownReqDownL1(0)<='0';
			UpReqDownL2(0)<='0';
			DownReqDownL2(0)<='0';
			curr_down_requests(0)<='0';
	elsif DownReqDownL2(0) = '1' and lift2_status(4 downto 3) = "11" then
	        lift2_down_signal(0)<='1';
			lift2_requests(0)<='1';
			UpReqDownL1(0)<='0';
			DownReqDownL1(0)<='0';
			UpReqDownL2(0)<='0';
			DownReqDownL2(0)<='0';
			curr_down_requests(0)<='0';
	--end if;
	
	elsif DownReqDownL1(1) = '1' and lift1_status(4 downto 3) = "11" then
			lift1_down_signal(1)<='1';
			lift1_requests(1)<='1';
			UpReqDownL1(1)<='0';
			DownReqDownL1(1)<='0';
			UpReqDownL2(1)<='0';
			DownReqDownL2(1)<='0';
			curr_down_requests(1)<='0';
	elsif DownReqDownL2(1) = '1' and lift2_status(4 downto 3) = "11" then
	       lift2_down_signal(1)<='1';
			lift2_requests(1)<='1';
			UpReqDownL1(1)<='0';
			DownReqDownL1(1)<='0';
			UpReqDownL2(1)<='0';
			DownReqDownL2(1)<='0';
			curr_down_requests(1)<='0';
	--end if;
	
	elsif DownReqDownL1(2) = '1' and lift1_status(4 downto 3) = "11" then
	        lift1_down_signal(2)<='1';
			lift1_requests(2)<='1';
			UpReqDownL1(2)<='0';
			DownReqDownL1(2)<='0';
			UpReqDownL2(2)<='0';
			DownReqDownL2(2)<='0';
			curr_down_requests(2)<='0';
	elsif DownReqDownL2(2) = '1' and lift2_status(4 downto 3) = "11" then
	        lift2_down_signal(2)<='1';
			lift2_requests(2)<='1';
			UpReqDownL1(2)<='0';
			DownReqDownL1(2)<='0';
			UpReqDownL2(2)<='0';
			DownReqDownL2(2)<='0';
			curr_down_requests(2)<='0';
	--end if;
	elsif DownReqDownL1(3) = '1' and lift1_status(4 downto 3) = "11" then
			lift1_down_signal(3)<='1';
			lift1_requests(3)<='1';
			UpReqDownL1(3)<='0';
			DownReqDownL1(3)<='0';
			UpReqDownL2(3)<='0';
			DownReqDownL2(3)<='0';
			curr_down_requests(3)<='0';
	elsif DownReqDownL2(3) = '1' and lift2_status(4 downto 3) = "11" then
	        lift2_down_signal(3)<='1';
			lift2_requests(3)<='1';
			UpReqDownL1(3)<='0';
			DownReqDownL1(3)<='0';
			UpReqDownL2(3)<='0';
			DownReqDownL2(3)<='0';
			curr_down_requests(3)<='0';
	--end if;
	
	else
	if lift1_status(4 downto 3) = "00" then
		if UpReqUpL1(0)='1' then
		    lift1_up_signal(0)<='1'; 
			lift1_requests(0)<='1';
			UpReqDownL1(0)<='0';
			DownReqDownL1(0)<='0';
			UpReqDownL2(0)<='0';
			DownReqDownL2(0)<='0';
			curr_up_requests(0)<='0';
		elsif UpReqUpL1(1)='1' then
		    lift1_up_signal(1)<='1';
			lift1_requests(1)<='1';
			UpReqDownL1(1)<='0';
			DownReqDownL1(1)<='0';
			UpReqDownL2(1)<='0';
			DownReqDownL2(1)<='0';
		    curr_up_requests(1)<='0';
		elsif UpReqUpL1(2)='1' then
		    lift1_up_signal(2)<='1';
			lift1_requests(2)<='1';
			UpReqDownL1(2)<='0';
			DownReqDownL1(2)<='0';
			UpReqDownL2(2)<='0';
			DownReqDownL2(2)<='0';
			curr_up_requests(2)<='0';
		elsif UpReqUpL1(3) ='1' then
		    lift1_up_signal(3)<='1';
			lift1_requests(3)<='1';
			UpReqDownL1(3)<='0';
			DownReqDownL1(3)<='0';
			UpReqDownL2(3)<='0';
			DownReqDownL2(3)<='0';
			curr_up_requests(3)<='0';
		elsif UpReqDownL1(0)='1' then
		    lift1_down_signal(0)<='1';  
			lift1_requests(0)<='1';
			UpReqDownL1(0)<='0';
			DownReqDownL1(0)<='0';
			UpReqDownL2(0)<='0';
			DownReqDownL2(0)<='0';
			curr_down_requests(0)<='0';
		elsif UpReqDownL1(1)='1' then
		    lift1_down_signal(1)<='1';  
			lift1_requests(1)<='1';
			UpReqDownL1(1)<='0';
			DownReqDownL1(1)<='0';
			UpReqDownL2(1)<='0';
			DownReqDownL2(1)<='0';
			curr_down_requests(1)<='0';
		elsif UpReqDownL1(2)='1' then
			lift1_down_signal(2)<='1';
			lift1_requests(2)<='1';
			UpReqDownL1(2)<='0';
			DownReqDownL1(2)<='0';
			UpReqDownL2(2)<='0';
			DownReqDownL2(2)<='0';
			curr_down_requests(2)<='0';
		elsif UpReqDownL1(3) ='1' then
		    lift1_down_signal(3)<='1';
			lift1_requests(3)<='1';
			UpReqDownL1(3)<='0';
			DownReqDownL1(3)<='0';
			UpReqDownL2(3)<='0';
			DownReqDownL2(3)<='0';
			curr_down_requests(3)<='0';
		elsif DownReqUpL1(0)='1' then
		    lift1_up_signal(0)<='1'; 
			lift1_requests(0)<='1';
			UpReqDownL1(0)<='0';
			DownReqDownL1(0)<='0';
			UpReqDownL2(0)<='0';
			DownReqDownL2(0)<='0';
			curr_up_requests(0)<='0';
		elsif DownReqUpL1(1)='1' then
			lift1_up_signal(1)<='1';
			lift1_requests(1)<='1';
			UpReqDownL1(1)<='0';
			DownReqDownL1(1)<='0';
			UpReqDownL2(1)<='0';
			DownReqDownL2(1)<='0';
			curr_up_requests(1)<='0';
		elsif DownReqUpL1(2)='1' then
			lift1_up_signal(2)<='1';
			lift1_requests(2)<='1';
			UpReqDownL1(2)<='0';
			DownReqDownL1(2)<='0';
			UpReqDownL2(2)<='0';
			DownReqDownL2(2)<='0';
			curr_up_requests(2)<='0';
		elsif DownReqUpL1(3) ='1' then
			lift1_up_signal(3)<='1';
			lift1_requests(3)<='1';
			UpReqDownL1(3)<='0';
			DownReqDownL1(3)<='0';
			UpReqDownL2(3)<='0';
			DownReqDownL2(3)<='0';
			curr_up_requests(3)<='0';
		elsif DownReqDownL1(0)='1' then 
			lift1_down_signal(0)<='1';
			lift1_requests(0)<='1';
			UpReqDownL1(0)<='0';
			DownReqDownL1(0)<='0';
			UpReqDownL2(0)<='0';
			DownReqDownL2(0)<='0';
			curr_down_requests(0)<='0';
		elsif DownReqDownL1(1)='1' then
			lift1_down_signal(1)<='1';
			lift1_requests(1)<='1';
			UpReqDownL1(1)<='0';
			DownReqDownL1(1)<='0';
			UpReqDownL2(1)<='0';
			DownReqDownL2(1)<='0';
			curr_down_requests(1)<='0';
		elsif DownReqDownL1(2)='1' then
			lift1_down_signal(2)<='1';
			lift1_requests(2)<='1';
			UpReqDownL1(2)<='0';
			DownReqDownL1(2)<='0';
			UpReqDownL2(2)<='0';
			DownReqDownL2(2)<='0';
			curr_down_requests(2)<='0';
		elsif DownReqDownL1(3) ='1' then
			lift1_down_signal(3)<='1';
			lift1_requests(3)<='1';
			UpReqDownL1(3)<='0';
			DownReqDownL1(3)<='0';
			UpReqDownL2(3)<='0';
			DownReqDownL2(3)<='0';
			curr_down_requests(3)<='0';
		end if;
	elsif lift2_status(4 downto 3) = "00" then
		if UpReqUpL2(0)='1' then 
		    lift2_up_signal(0)<='1';
			lift2_requests(0)<='1';
			UpReqDownL1(0)<='0';
			DownReqDownL1(0)<='0';
			UpReqDownL2(0)<='0';
			DownReqDownL2(0)<='0';
			curr_up_requests(0)<='0';
		elsif UpReqUpL2(1)='1' then
		    lift2_up_signal(1)<='1';
			lift2_requests(1)<='1';
			UpReqDownL1(1)<='0';
			DownReqDownL1(1)<='0';
			UpReqDownL2(1)<='0';
			DownReqDownL2(1)<='0';
			curr_up_requests(1)<='0';
		elsif UpReqUpL2(2)='1' then
		    lift2_up_signal(2)<='1';
			lift2_requests(2)<='1';
			UpReqDownL1(2)<='0';
			DownReqDownL1(2)<='0';
			UpReqDownL2(2)<='0';
			DownReqDownL2(2)<='0';
			curr_up_requests(2)<='0';
		elsif UpReqUpL2(3) ='1' then
		    lift2_up_signal(3)<='1';
			lift2_requests(3)<='1';
			UpReqDownL1(3)<='0';
			DownReqDownL1(3)<='0';
			UpReqDownL2(3)<='0';
			DownReqDownL2(3)<='0';
			curr_up_requests(3)<='0';
		elsif UpReqDownL2(0)='1' then
		    lift2_down_signal(0)<='1'; 
			lift2_requests(0)<='1';
			UpReqDownL1(0)<='0';
			DownReqDownL1(0)<='0';
			UpReqDownL2(0)<='0';
			DownReqDownL2(0)<='0';
			curr_down_requests(0)<='0';
		elsif UpReqDownL2(1)='1' then
		    lift2_down_signal(1)<='1';
			lift2_requests(1)<='1';
			UpReqDownL1(1)<='0';
			DownReqDownL1(1)<='0';
			UpReqDownL2(1)<='0';
			DownReqDownL2(1)<='0';
			curr_down_requests(1)<='0';
		elsif UpReqDownL2(2)='1' then
		    lift2_down_signal(2)<='1';
			lift2_requests(2)<='1';
			UpReqDownL1(2)<='0';
			DownReqDownL1(2)<='0';
			UpReqDownL2(2)<='0';
			DownReqDownL2(2)<='0';
			curr_down_requests(2)<='0';
		elsif UpReqDownL2(3) ='1' then
		    lift2_down_signal(3)<='1';
			lift2_requests(3)<='1';
			UpReqDownL1(3)<='0';
			DownReqDownL1(3)<='0';
			UpReqDownL2(3)<='0';
			DownReqDownL2(3)<='0';
			curr_down_requests(3)<='0';
		elsif DownReqUpL2(0)='1' then
		    lift2_up_signal(0)<='1'; 
			lift2_requests(0)<='1';
			UpReqDownL1(0)<='0';
			DownReqDownL1(0)<='0';
			UpReqDownL2(0)<='0';
			DownReqDownL2(0)<='0';
			curr_up_requests(0)<='0';
		elsif DownReqUpL2(1)='1' then
		    lift2_up_signal(1)<='1';
			lift2_requests(1)<='1';
			UpReqDownL1(1)<='0';
			DownReqDownL1(1)<='0';
			UpReqDownL2(1)<='0';
			DownReqDownL2(1)<='0';
			curr_up_requests(1)<='0';
		elsif DownReqUpL2(2)='1' then
		    lift2_up_signal(2)<='1';
			lift2_requests(2)<='1';
			UpReqDownL1(2)<='0';
			DownReqDownL1(2)<='0';
			UpReqDownL2(2)<='0';
			DownReqDownL2(2)<='0';
			curr_up_requests(2)<='0';
		elsif DownReqUpL2(3) ='1' then
		    lift2_up_signal(3)<='1';
			lift2_requests(3)<='1';
			UpReqDownL1(3)<='0';
			DownReqDownL1(3)<='0';
			UpReqDownL2(3)<='0';
			DownReqDownL2(3)<='0';
			curr_up_requests(3)<='0';
		elsif DownReqDownL2(0)='1' then
		    lift2_down_signal(0)<='1'; 
			lift2_requests(0)<='1';
			UpReqDownL1(0)<='0';
			DownReqDownL1(0)<='0';
			UpReqDownL2(0)<='0';
			DownReqDownL2(0)<='0';
			curr_down_requests(0)<='0';
		elsif DownReqDownL2(1)='1' then
		    lift2_down_signal(1)<='1';
			lift2_requests(1)<='1';
			UpReqDownL1(1)<='0';
			DownReqDownL1(1)<='0';
			UpReqDownL2(1)<='0';
			DownReqDownL2(1)<='0';
			curr_down_requests(1)<='0';
		elsif DownReqDownL2(2)='1' then
		    lift2_down_signal(2)<='1';
			lift2_requests(2)<='1';
			UpReqDownL1(2)<='0';
			DownReqDownL1(2)<='0';
			UpReqDownL2(2)<='0';
			DownReqDownL2(2)<='0';
			curr_down_requests(2)<='0';
		elsif DownReqDownL2(3) ='1' then
		    lift2_down_signal(3)<='1';
			lift2_requests(3)<='1';
			UpReqDownL1(3)<='0';
			DownReqDownL1(3)<='0';
			UpReqDownL2(3)<='0';
			DownReqDownL2(3)<='0';
			curr_down_requests(3)<='0';
		end if;
	end if;
	end if;


	end if;
	end if;
  --update curr_up_requests/curr_down_requests and up_requests_remaining/down_requests_remaining whenever a NEW request comes in
  
  --for each request, classify it as UpReqUp, UpReqDown, DownReqUp or DownReqDown for each lift
  --based on current floor  of each of the lifts. Following the strategy described in the lab8 document,
  --we will assign requests to each of the lift based on lift1_status and lift2_status signals
  --(communicated via the lift1_requests and the lift2_requests signal
  --once the assignment is done, we will reset the corresponding request in curr_up_requests/curr_down_requests signal
  
  --for idle state lift request will be assigned based on given priority order     
  
  --whenever a lift completes a request(can be identified by lift_status, we
  --will update up_requests_remaining and down_requests_remaining 
  end process;

end Behavioral;



--

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
						  "0101" when lift2_status(2 downto 0) = "000" else  -- o 
                              "0111" when lift2_status(2 downto 0) = "011" else  -- c
                              "0110" when lift2_status(2 downto 0) = "100" else  -- u
                              "0111" when lift2_status(2 downto 0) = "001"; --c
	b(7 downto 4)<="1101" when lift2_status(2 downto 0) = "101" else -- because 13 is d in hexa
						  "0101" when lift2_status(2 downto 0) = "000" else  -- o 
						  "0111" when lift2_status(2 downto 0) = "011" else  -- c
						  "0110" when lift2_status(2 downto 0) = "100" else  -- u
						  "0111" when lift2_status(2 downto 0) = "001"; --c
	
	--b(15 downto 12)<="1101" when lift1_status(2 downto 0) = "101" else -- because 13 is d in hexa
	--					  "1111" when lift1_status(2 downto 0) = "000" else  -- w
	--					  "0101" when lift1_status(2 downto 0) = "011" else  -- o
	--					  "0110" when lift1_status(2 downto 0) = "100" else  -- u
	--					  "0111" when lift1_status(2 downto 0) = "001"; --c
	--b(7 downto 4)<="1101" when lift2_status(2 downto 0) = "101" else -- because 13 is d in hexa
	--					  "1111" when lift2_status(2 downto 0) = "000" else  -- w 
	--					  "0101" when lift2_status(2 downto 0) = "011" else  -- o
	--					  "0110" when lift2_status(2 downto 0) = "100" else  -- u
	--					  "0111" when lift2_status(2 downto 0) = "001"; --c
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;





entity lab8_elevator_control is port(

	up_request : in std_logic_vector(3 downto 0);
	down_request : in std_logic_vector(3 downto 0);
	up_request_indicator : out std_logic_vector(3 downto 0);
	down_request_indicator : out std_logic_vector(3 downto 0);
	reset : in std_logic;
	cathode : out std_logic_vector(6 downto 0);
	anode : out std_logic_vector(3 downto 0);
	door_open : in std_logic_vector(1 downto 0);
	door_close : in std_logic_vector(1 downto 0);
	clk : in std_logic;
	lift1_floor : in std_logic_vector(3 downto 0);
	lift2_floor : in std_logic_vector(3 downto 0);
	lift1_floor_indicator : out std_logic_vector(3 downto 0);
	lift2_floor_indicator : out std_logic_vector(3 downto 0);
	sim_mode : in std_logic

	
);

end lab8_elevator_control;

architecture Behavioral of lab8_elevator_control is
component lift1_controller is
Port(
    lift_floor : in std_logic_vector(3 downto 0); -- requests from inside the lift
    lift_status: out std_logic_vector(6 downto 0); --status is (current/previous floor, request_state, lift_state) where request_state is reqUp/reqDown/Idle 
                                                    -- and lift_state can be moving up/ moving down/ halted with door open/ halted with door closed
    req_handler_floors: in std_logic_vector(3 downto 0); --destination floors communicated by request handler
    door_open: in std_logic;
    door_closed: in std_logic;
    req_indicator:out std_logic_vector(3 downto 0);
    lift_floor_indicator: out std_logic_vector(3 downto 0);
    reset: in std_logic;
    clk: in std_logic
);
end component;

component lift_controller is
Port(
    lift_floor : in std_logic_vector(3 downto 0); -- requests from inside the lift
    lift_status: out std_logic_vector(6 downto 0); --status is (current/previous floor, request_state, lift_state) where request_state is reqUp/reqDown/Idle 
                                                    -- and lift_state can be moving up/ moving down/ halted with door open/ halted with door closed
    req_handler_floors: in std_logic_vector(3 downto 0); --destination floors communicated by request handler
    door_open: in std_logic;
    door_closed: in std_logic;
    req_indicator:out std_logic_vector(3 downto 0);
    lift_floor_indicator: out std_logic_vector(3 downto 0);
    reset: in std_logic;
    clk: in std_logic
);
end component;
component status_display_block is Port(

	lift1_status :in std_logic_vector(6 downto 0);
	lift2_status :in std_logic_vector(6 downto 0);
	anode: out std_logic_vector(3 downto 0);
	cathode: out std_logic_vector(6 downto 0);
	clk : in std_logic
--	b: out std_logic_vector(15 downto 0);
--	up_request_output:out std_logic_vector(3 downto 0);
--	down_request_output: out std_logic_vector(3 downto 0)
	
);

end component;

component request_handler is
Port(
    up_request : in std_logic_vector(3 downto 0); -- up requests
    down_request: in std_logic_vector(3 downto 0);--down requests 
    reset: in std_logic; --reset to predefined state
    lift1_status: in std_logic_vector(6 downto 0);
    lift2_status:in std_logic_vector(6 downto 0);
    lift1_requests: out std_logic_vector(3 downto 0);--destination floors for lift1
    lift2_requests: out std_logic_vector(3 downto 0);--destination floors for lift 2
    up_requests_pending: out std_logic_vector(3 downto 0);--all requests not yet completed 
    down_requests_pending: out std_logic_vector(3 downto 0);
    clk: in std_logic;
    lift1_up : out std_logic_vector(3 downto 0);
    lift2_up : out std_logic_vector(3 downto 0);
    lift2_down : out std_logic_vector(3 downto 0);
    lift1_down : out std_logic_vector(3 downto 0)
    
);
end component;

    signal internal_lift1_status:  std_logic_vector(6 downto 0);
    signal internal_lift2_status: std_logic_vector(6 downto 0);
    signal internal_lift1_requests:  std_logic_vector(3 downto 0);--destination floors for lift1
    signal internal_lift2_requests:  std_logic_vector(3 downto 0);--destination floors for lift 2
    signal internal_up_requests_pending: std_logic_vector(3 downto 0);--all requests not yet completed 
    signal internal_down_requests_pending:  std_logic_vector(3 downto 0);
    signal internal_req_indicator_1:std_logic_vector(3 downto 0);
    signal internal_req_indicator_2:std_logic_vector(3 downto 0);
    signal internal_lift1_up : std_logic_vector(3 downto 0);
    signal internal_lift2_up :  std_logic_vector(3 downto 0);
    signal internal_lift2_down :  std_logic_vector(3 downto 0);
    signal internal_lift1_down :  std_logic_vector(3 downto 0);
    signal internal_reqhandler_up: std_logic_vector(3 downto 0);
    signal internal_reqhandler_down: std_logic_vector(3 downto 0);

begin
    internal_reqhandler_up<='0'& (up_request(2 downto 0) and not(internal_up_requests_pending(2 downto 0) or internal_lift1_up(2 downto 0) or internal_lift2_up(2 downto 0)));
    internal_reqhandler_down<=( down_request(3 downto 1) and not(internal_down_requests_pending(3 downto 1) or internal_lift1_down(3 downto 1) or internal_lift2_down(3 downto 1))) & '0';
        
    lift1_inst : lift_controller port map(
        lift_floor=>lift1_floor,
        lift_status=>internal_lift1_status,
        req_handler_floors=>internal_lift1_requests,
        req_indicator=>internal_req_indicator_1,
        door_open=>door_open(0),
        door_closed=>door_close(0),
        lift_floor_indicator=>lift1_floor_indicator,
        reset=>reset,
        clk=>clk
        
        
    
    
    );
    
    
    lift2_inst : lift_controller port map(
            lift_floor=>lift2_floor,
            lift_status=>internal_lift2_status,
            req_handler_floors=>internal_lift2_requests,
            req_indicator=>internal_req_indicator_2,
            door_open=>door_open(1),
            door_closed=>door_close(1),
            lift_floor_indicator=>lift2_floor_indicator,
            reset=>reset,
            clk=>clk
            
            
        
        
        );
        
        req_handler : request_handler port map(
            up_request=>internal_reqhandler_up,
            down_request=>internal_reqhandler_down,
            reset=>reset,
            lift1_status=>internal_lift1_status,
            lift2_status=>internal_lift2_status,
            lift1_requests=>internal_lift1_requests,
            lift2_requests=>internal_lift2_requests,
            up_requests_pending=>internal_up_requests_pending,
            down_requests_pending=>internal_down_requests_pending,
            clk=>clk,
            lift1_up=>internal_lift1_up,
            lift2_up=>internal_lift2_up,
            lift2_down=>internal_lift2_down,
            lift1_down=>internal_lift1_down
            
            
        
        );
        
        ssd : status_display_block port map(
            lift1_status=>internal_lift1_status,
            lift2_status=>internal_lift2_status,
            anode=>anode,
            cathode=>cathode,
            clk=>clk
            
        
        
        
        );
        --main:process(clk) begin
            up_request_indicator<=internal_up_requests_pending or internal_lift1_up or internal_lift2_up;
            down_request_indicator<=internal_down_requests_pending or internal_lift1_down or internal_lift2_down;
            --if(reset='1')
                --up_request_indicator
--here the four entites are instantiated and interconnected according to 
--block diagram in given image 
-- lab4_seven_segment_display is instantiated for ssd display
end Behavioral;