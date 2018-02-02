----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.10.2017 16:37:55
-- Design Name: 
-- Module Name: lift_controller - Behavioral
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


entity lift_controller is
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
end lift_controller;

architecture Behavioral of lift_controller is


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
  --when counter reaches max value, change lift_state 
  --floor will be change if previous lift_state was going up /going down (as a new floor has been reached)       
  --req_state must be changed whenever the previous lift_state was waiting
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
        
      if((lift_state="000" and counter(27)='1' and counter(26)='1') or (lift_state="100" and counter(28)='1') or (lift_state="101" and counter(28)='1') or (lift_state="011" and counter(27)='1') or (lift_state="001" and counter(27)='1')) then
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
         lift_state<="000";--change to waiting state, and change it in next clock cycle
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

