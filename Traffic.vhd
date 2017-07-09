----------------------------------------------------------------------------------
-- Company: NTU School of Electrical and Electronic Engineering
-- Engineer: David Orlando Kurniawan and Samuel Frederick Hutapea
-- 
-- Create Date: 10/19/2016 06:22:21 PM
-- Design Name: Smart Traffic Light Controller
-- Module Name: Main - Behavioral
-- Project Name: EE4305 Group Project
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
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_signed.all;
use work.mypackage.ALL;


entity main is
    Port ( clk          : in STD_LOGIC;
           reset        : in STD_LOGIC;
           jam          : in integer;
           timer0       : out integer;
           timer1       : out integer;
           timer2       : out integer;
           timer3       : out integer;
           light0       : out STD_LOGIC_VECTOR (2 downto 0);
           light1       : out STD_LOGIC_VECTOR (2 downto 0);
           light2       : out STD_LOGIC_VECTOR (2 downto 0);
           light3       : out STD_LOGIC_VECTOR (2 downto 0);                                          
           greenlight    : out STD_LOGIC_VECTOR (3 downto 0);
           yellowlight   : out STD_LOGIC_VECTOR (3 downto 0);
           redlight      : out STD_LOGIC_VECTOR (3 downto 0));
end main;


architecture Behavioral of main is


-- traffic light initialization
signal lamp0, lamp1, lamp2, lamp3: STD_LOGIC_VECTOR (3 downto 0):="0001";
signal
waktu00, waktu01, waktu02,
waktu10, waktu11, waktu12, 
waktu20, waktu21, waktu22,
waktu30, waktu31, waktu32,
red0, green0,
red1, green1,
red2, green2,
red3, green3: integer range 0 to 1000;


-- state definition
type state_type is array (3 downto 0) of STD_LOGIC;
constant s00: state_type:="0000";
constant s01: state_type:="0001";
constant s02: state_type:="0010";
constant s03: state_type:="0011";
constant s10: state_type:="0100";
constant s11: state_type:="0101";
constant s12: state_type:="0110";
constant s13: state_type:="0111";
constant s20: state_type:="1000";
constant s21: state_type:="1001";
constant s22: state_type:="1010";
constant s23: state_type:="1011";
constant s30: state_type:="1100";
constant s31: state_type:="1101";
constant s32: state_type:="1110";
constant s33: state_type:="1111";
signal present_state, next_state: state_type;


-- traffic time data
signal yellow_time, yellow2_time, green_time, total_green_time: integer range 0 to 250;


signal yellow2_time0, yellow2_time1, yellow2_time2, yellow2_time3: integer range 0 to 250;


signal red_time: integer range 0 to 250 := 5;


-- car number and speed
signal car_num0,car_num1, car_num2, car_num3: integer range 0 to 1000;
signal car_speed0, car_speed1, car_speed2, car_speed3: integer range 0 to 150;


-- next state trigger
signal tick: STD_LOGIC;


begin


P0comb: process (present_state, tick, waktu01, waktu02, waktu11, waktu12, waktu21, waktu22, waktu31, waktu32) is
begin
    case present_state is
        when S00 => -- red light
            lamp3 <= "0001"; -- set side 3 back to light
            lamp0 <= "0001"; -- set side 0 to buffer red light
            if tick = '1' then
                next_state <= S01; -- proceed to next state
            else
                next_state <= S00; -- back to this state
            end if;
            
        when S01 => -- yellow proceeding green light
            lamp0 <= "0010"; --first yellow
            if tick = '0' then
                next_state <= S02;
            else
                next_state <= S01;
            end if;
   
        when S02 => -- green light
            lamp0 <= "0100"; -- green light
            if tick = '1' then            
                next_state <= S03;
            else
                next_state <= S02;
            end if;
             
        when S03 => --yellow proceeding red light
            lamp0 <= "1000"; -- second yellow
            if tick = '0' then
                next_state <= S10;
            else
                next_state <= S03;
            end if;
            
        when S10 =>
            lamp0 <= "0001"; -- return side 0 to red again
            lamp1 <= "0001"; -- set side 1 to buffer red
            if tick = '1' then
                next_state <= S11;
            else
                next_state <= S10;
            end if;
            
        when S11 =>
            lamp1 <= "0010"; -- first yellow
            if tick = '0' then    
                next_state <= S12;
            else
                next_state <= S11;
            end if;
            
        when S12 =>
            lamp1 <= "0100"; -- green light
            if tick = '1' then
                next_state <= S13;
            else
                next_state <= S12;
            end if;
            
        when S13 =>
            lamp1 <= "1000"; -- second yellow
            if tick = '0' then
                next_state <= S20;
            else
                next_state <= S13;
            end if;
            
        when S20 =>
            lamp1 <= "0001";
            lamp2 <= "0001";
            if tick = '1' then
                next_state <= S21;
            else
                next_state <= S20;
            end if;
            
        when S21 =>
            lamp2 <= "0010";
            if tick = '0' then
                next_state <= S22;
            else
                next_state <= S21;
            end if;
            
        when S22 =>
            lamp2 <= "0100";
            if tick = '1' then
                next_state <= S23;
            else
                next_state <= S22;
            end if;
            
        when S23 =>
            lamp2 <= "1000";
            if tick = '0' then
                next_state <= S30;
            else
                next_state <= S23;
            end if;
            
        when S30 =>
            lamp2 <= "0001";
            lamp3 <= "0001";
            if tick = '1' then
                next_state <= S31;    
            else
                next_state <= S30;
            end if;
            
        when S31 =>
            lamp3 <= "0010";
            if tick = '0' then
                next_state <= S32;
            else
                next_state <= S31;
            end if;
            
        when S32 =>
            lamp3 <= "0100";
            if tick = '1' then
                next_state <= S33;
            else
                next_state <= S32;
            end if;
            
        when S33 =>
            lamp3 <= "1000";
            if tick = '0' then
                next_state <= S00;
            else
                next_state <= S33;
            end if;
            
        when others =>
            next_state <= S00;
            
    end case;
end process P0comb;


P1countdown: process (jam, clk, tick, present_state) is
begin
    case present_state is
        when S00 =>
            if clk'event and clk = '1' then
                if red_time = 0 then
                    tick <= '1';
                    -- set timing for next yellow light
                    yellow_time <= 2;
                    
                    -- set timing for next green light
                    green_time <= green_count(jam); -- next green light time, for decrement
                    waktu00 <= waktu01; -- shifting data
                    waktu01 <= waktu02; -- shifting data
                    waktu02 <= green_time; -- entering new duration
                    total_green_time <= green_time; -- hold the green light time
                    
                    -- set timing for next yellow light
                    yellow2_time <= yellow_count(car_speed0);
                    yellow2_time0 <= yellow2_time;


                else
                    red_time <= red_time - 1;
                end if;
            end if;
            
        when S01 =>
            if clk'event and clk = '1' then
                
                if yellow_time = 0 then
                    tick <= '0';
                    
                else
                    yellow_time <= yellow_time - 1;
                end if;
            end if;
            
        when S02 =>
            
            if clk'event and clk = '1' then
                if green_time = 0 then
                    tick <= '1';
                    
                    car_num0 <= car_number(total_green_time);
                    car_speed0 <= car_speed(car_num0, total_green_time);
                    
                else
                    green_time <= green_time - 1;
                end if;
            end if;
            
        when S03 =>
            if clk'event and clk = '1' then
                if yellow2_time = 0 then
                    tick <= '0';
                    -- set timing for next red light
                    red_time <= 5;
                else
                    yellow2_time <= yellow2_time - 1;
                end if;
            end if;
            
        when S10 =>
            if clk'event and clk = '1' then
                if red_time = 0 then
                    tick <= '1';
                    yellow_time <= 2;
                    
                    green_time <= green_count(jam); -- next green light time
                    waktu10 <= waktu11; -- shifting data
                    waktu11 <= waktu12; -- shifting data
                    waktu12 <= green_time; -- entering new duration
                    total_green_time <= green_time; -- used for counting down the time
                    
                    yellow2_time <= yellow_count(car_speed1);
                    yellow2_time1 <= yellow2_time;
                else
                    red_time <= red_time - 1;
                end if;
            end if;
            
        when S11 =>
            if clk'event and clk = '1' then
                
                if yellow_time = 0 then
                    tick <= '0';
                    
                else
                    yellow_time <= yellow_time - 1;
                end if;
            end if;
            
        when S12 =>
                        
            if clk'event and clk = '1' then
                if green_time = 0 then
                    tick <= '1';
                    
                    car_num1 <= car_number(total_green_time);
                    car_speed1 <= car_speed(car_num1, total_green_time);
                    
                else
                    green_time <= green_time - 1;
                end if;
            end if;
            
        when S13 =>
            if clk'event and clk = '1' then
                if yellow2_time = 0 then
                    tick <= '0';
                    red_time <= 5;
                else
                    yellow2_time <= yellow2_time - 1;
                end if;
            end if;
        
        when S20 =>
            if clk'event and clk = '1' then
                if red_time = 0 then
                    tick <= '1';
                    yellow_time <= 2;
                    
                    green_time <= green_count(jam); -- next green light time
                    waktu20 <= waktu21; -- shifting data
                    waktu21 <= waktu22; -- shifting data
                    waktu22 <= green_time; -- entering new duration
                    total_green_time <= green_time; -- used for counting down the time
                    
                    yellow2_time <= yellow_count(car_speed2);
                    yellow2_time2 <= yellow2_time;
                else
                    red_time <= red_time - 1;
                end if;
            end if;
            
        when S21 =>
            if clk'event and clk = '1' then                
                if yellow_time = 0 then
                    tick <= '0';
                   
                else
                    yellow_time <= yellow_time - 1;
                end if;
            end if;
            
        when S22 =>
            
            if clk'event and clk = '1' then
                if green_time = 0 then
                    tick <= '1';
                    
                    car_num2 <= car_number(total_green_time);
                    car_speed2 <= car_speed(car_num2, total_green_time);
                    
                else
                    green_time <= green_time - 1;
                end if;
            end if;
            
        when S23 =>
            if clk'event and clk = '1' then
                if yellow2_time = 0 then
                    tick <= '0';
                    red_time <= 5;
                else
                    yellow2_time <= yellow2_time - 1;
                end if;
            end if;
            
        when S30 =>
            if clk'event and clk = '1' then
                if red_time = 0 then
                    tick <= '1';
                    yellow_time <= 2;
                    
                    green_time <= green_count(jam); -- next green light time
                    waktu30 <= waktu31; -- shifting data
                    waktu31 <= waktu32; -- shifting data
                    waktu32 <= green_time; -- entering new duration
                    total_green_time <= green_time; -- used for counting down the time
                    
                    yellow2_time <= yellow_count(car_speed3);
                    yellow2_time3 <= yellow2_time;
                else
                    red_time <= red_time - 1;
                end if;
            end if;
            
        when S31 =>
            if clk'event and clk = '1' then
            
                if yellow_time = 0 then
                    tick <= '0';
                    
                else
                    yellow_time <= yellow_time - 1;
                end if;
            end if;
            
        when S32 =>
            
            if clk'event and clk = '1' then
                if green_time = 0 then
                    tick <= '1';
                    
                    car_num3 <= car_number(total_green_time);
                    car_speed3 <= car_speed(car_num3, total_green_time);
                else
                    green_time <= green_time - 1;
                end if;
            end if;
            
        when S33 =>
            if clk'event and clk = '1' then
                if yellow2_time = 0 then
                    tick <= '0';
                    red_time <= 5;
                else
                    yellow2_time <= yellow2_time - 1;
                end if;
            end if;
                            
        when others => null;
        
    end case;
end process P1countdown;


P2output: process (lamp0, lamp1, lamp2, lamp3) is -- to process output lamp
begin
    light0(2) <= lamp0(2); -- green light
    light0(1) <= lamp0(3) or lamp0(1); -- yellow light
    light0(0) <= lamp0(0); -- red light
    
    light1(2) <= lamp1(2); -- green light
    light1(1) <= lamp1(3) or lamp1(1); -- yellow light
    light1(0) <= lamp1(0); -- red light
    
    light2(2) <= lamp2(2); -- green light
    light2(1) <= lamp2(3) or lamp2(1); -- yellow light
    light2(0) <= lamp2(0); -- red light
    
    light3(2) <= lamp3(2); -- green light
    light3(1) <= lamp3(3) or lamp3(1); -- yellow light
    light3(0) <= lamp3(0); -- red light
    
    greenlight(0) <= lamp0(2); -- greenlight for lane 0
    greenlight(1) <= lamp1(2); -- greenlight for lane 1
    greenlight(2) <= lamp2(2); -- greenlight for lane 2
    greenlight(3) <= lamp3(2); -- greenlight for lane 3
    
    yellowlight(0) <= lamp0(1) or lamp0(3); -- yellowlight for lane 0
    yellowlight(1) <= lamp1(1) or lamp1(3); -- yellowlight for lane 1
    yellowlight(2) <= lamp2(1) or lamp2(3); -- yellowlight for lane 2
    yellowlight(3) <= lamp3(1) or lamp3(3); -- yellowlight for lane 3
    
    redlight(0) <= lamp0(0); -- redlight for lane 0
    redlight(1) <= lamp1(0); -- redlight for lane 1
    redlight(2) <= lamp2(0); -- redlight for lane 2
    redlight(3) <= lamp3(0); -- redlight for lane 3
    
end process P2output;


P3seq: process (clk, reset) is -- sequential process
begin
    if reset = '1' then
        present_state <= s00;
    elsif clk'event and clk = '1' then
        present_state <= next_state;
    end if;
end process P3seq;


P4timer: process (clk, reset, present_state, lamp0, lamp1, lamp2, lamp3,
green0, green1, green2, green3, red0, red1, red2, red3) is
begin
    case present_state is
        when S00 =>
            if clk'event and clk = '1' then
                red0 <= decr(red0);
                red1 <= decr(red1);
                red2 <= decr(red2);
                red3 <= decr(red3);
            end if;
        
        when S01 =>
            green0 <= waktu02 + yellow2_time;
            if clk'event and clk = '1' then
                red0 <= decr(red0);
                red1 <= decr(red1);
                red2 <= decr(red2);
                red3 <= decr(red3);           
            end if;
        
        when S02 =>
            red0 <= waktu12 + waktu22 + waktu32 + yellow2_time1 + yellow2_time2 + yellow2_time3 + (4*yellow_time) + (4*red_time);
            if clk'event and clk = '1' then
                green0 <= decr(green0);
                red1 <= decr(red1);
                red2 <= decr(red2);
                red3 <= decr(red3);  
            end if;
        
        when S03 =>
            if clk'event and clk = '1' then
                green0 <= decr(green0);
                red1 <= decr(red1);
                red2 <= decr(red2);
                red3 <= decr(red3);  
            end if;
        
        when S10 =>
            if clk'event and clk = '1' then
                red0 <= decr(red0);
                red1 <= decr(red1);
                red2 <= decr(red2);
                red3 <= decr(red3);
            end if;
        
        when S11 =>
            green1 <= waktu12 + yellow2_time;
            if clk'event and clk = '1' then
                red0 <= decr(red0);
                red1 <= decr(red1);
                red2 <= decr(red2);
                red3 <= decr(red3);           
            end if;
        
        when S12 =>
            red1 <= waktu02 + waktu22 + waktu32 + yellow2_time0 + yellow2_time2 + yellow2_time3 + (4*yellow_time) + (4*red_time);
            if clk'event and clk = '1' then
                green1 <= decr(green1);
                red0 <= decr(red0);
                red2 <= decr(red2);
                red3 <= decr(red3);
            end if;
        
        when S13 =>
            if clk'event and clk = '1' then
                green1 <= decr(green1);
                red0 <= decr(red0);
                red2 <= decr(red2);
                red3 <= decr(red3);
            end if;
        
        when S20 =>
            if clk'event and clk = '1' then
                red0 <= decr(red0);
                red1 <= decr(red1);
                red2 <= decr(red2);
                red3 <= decr(red3); 
            end if;
        
        when S21 =>
            green2 <= waktu22 + yellow2_time;
            if clk'event and clk = '1' then
                red0 <= decr(red0);
                red1 <= decr(red1);
                red2 <= decr(red2);
                red3 <= decr(red3);             
            end if;
        
        when S22 =>
            red2 <= waktu12 + waktu02 + waktu32 + yellow2_time1 + yellow2_time0 + yellow2_time3 + (4*yellow_time) + (4*red_time);
            if clk'event and clk = '1' then
                green2 <= decr(green2);
                red0 <= decr(red0);
                red1 <= decr(red1);
                red3 <= decr(red3);
            end if;
        
        when S23 =>
            if clk'event and clk = '1' then
                green2 <= decr(green2);
                red0 <= decr(red0);
                red1 <= decr(red1);
                red3 <= decr(red3);
            end if;
        
        when S30 =>
            if clk'event and clk = '1' then
                red0 <= decr(red0);
                red1 <= decr(red1);
                red2 <= decr(red2);
                red3 <= decr(red3); 
            end if;
        
        when S31 =>
            green3 <= waktu32 + yellow2_time;
            if clk'event and clk = '1' then
                red0 <= decr(red0);
                red1 <= decr(red1);
                red2 <= decr(red2);
                red3 <= decr(red3);            
            end if;
        
        when S32 =>
            red3 <= waktu12 + waktu22 + waktu02 + yellow2_time1 + yellow2_time2 + yellow2_time0 + (4*yellow_time) + (4*red_time);
            if clk'event and clk = '1' then
                green3 <= decr(green3);
                red0 <= decr(red0);
                red1 <= decr(red1);
                red2 <= decr(red2);
            end if;
        
        when S33 =>
            if clk'event and clk = '1' then
                green3 <= decr(green3);
                red0 <= decr(red0);
                red1 <= decr(red1);
                red2 <= decr(red2);
            end if;
        
        when others =>
    end case;
end process P4timer;


P5timerdisplay: process (clk, reset, present_state, lamp0, lamp1, lamp2, lamp3,
green0, green1, green2, green3, red0, red1, red2, red3) is   
begin
    case lamp0 is
        when "0100" =>
            timer0 <= green0;
        when "1000" =>
            timer0 <= green0;    
        when others =>
            timer0 <= red0;
    end case;
    
    case lamp1 is
        when "0100" =>
                timer1 <= green1;
            when "1000" =>
                timer1 <= green1;    
            when others =>
                timer1 <= red1;
    end case;
    
    case lamp2 is
        when "0100" =>
                timer2 <= green2;
            when "1000" =>
                timer2 <= green2;    
            when others =>
                timer2 <= red2;
    end case;
    
    case lamp3 is
        when "0100" =>
                timer3 <= green3;
            when "1000" =>
                timer3 <= green3;    
            when others =>
                timer3 <= red3;
    end case;
end process P5timerdisplay;


end Behavioral;
