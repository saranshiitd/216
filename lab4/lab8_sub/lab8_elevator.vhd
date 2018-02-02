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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.all;




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

    --here the entites are instantiated (2 lift_controllers, request_handler and status_diplay_block ) and interconnected according to 
    --block diagram in given image 
    internal_reqhandler_up<='0'& (up_request(2 downto 0) and not(internal_up_requests_pending(2 downto 0) or internal_lift1_up(2 downto 0) or internal_lift2_up(2 downto 0)));
    internal_reqhandler_down<=( down_request(3 downto 1) and not(internal_down_requests_pending(3 downto 1) or internal_lift1_down(3 downto 1) or internal_lift2_down(3 downto 1))) & '0';
        
    lift1_inst : entity work.lift_controller port map(
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
    
    
    lift2_inst : entity work.lift_controller port map(
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
        
        req_handler :entity work.request_handler port map(
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
        
        ssd : entity work.status_display_block port map(
            lift1_status=>internal_lift1_status,
            lift2_status=>internal_lift2_status,
            anode=>anode,
            cathode=>cathode,
            clk=>clk
            
        
        
        
        );
            up_request_indicator<=internal_up_requests_pending or internal_lift1_up or internal_lift2_up;
            down_request_indicator<=internal_down_requests_pending or internal_lift1_down or internal_lift2_down;

end Behavioral;