----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.10.2017 16:43:36
-- Design Name: 
-- Module Name: req_handler - Behavioral
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


--update curr_up_requests/curr_down_requests whenever a NEW request comes in
  
  --for each request, classify it as UpReqUp, UpReqDown, DownReqUp or DownReqDown for each lift
  --based on current floor  of each of the lifts. Following the strategy described in the lab8 document,
  --we will assign requests to each of the lift based on lift1_status and lift2_status signals
  --(communicated via the lift1_requests and the lift2_requests signal
  --once the assignment is done, we will reset the corresponding request in curr_up_requests/curr_down_requests signal
  
  --for idle state lift request will be assigned based on given priority order     
  
  --whenever a lift completes a request(can be identified by lift_status, we
  --will update up_requests_remaining and down_requests_remaining 
  

architecture Behavioral of request_handler is
signal curr_up_requests: std_logic_vector(3 downto 0):="0000";-- all up requests pending for assignment
signal curr_down_requests: std_logic_vector(3 downto 0):="0000"; -- all down requests pending for assignment
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

lift1_up<=lift1_up_signal;
lift2_up<=lift2_up_signal;
lift1_down<=lift1_down_signal;
lift2_down<=lift2_down_signal;
up_requests_pending<=curr_up_requests;
down_requests_pending<=curr_down_requests;
main:process(clk) begin
    
    
	if rising_edge(clk) then
	
	if(state='0') then
           lift1_requests<="0000";
           lift2_requests<="0000";
           
                      
           state<='1';
        if(reset='1') then --reset everything
               curr_up_requests<="0000";
               curr_down_requests<="0000";
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
  
  end process;

end Behavioral;



--