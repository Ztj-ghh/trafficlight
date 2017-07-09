library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;








package mypackage is


function decr (traffic_time: integer) return integer;
function yellow_count (car_speed: integer) return integer;
function green_count (current_time: integer) return integer;
function car_number (time_count: integer) return integer;
function car_speed (car_num, time_count: integer) return integer;
    
end mypackage;
















package body mypackage is
    
-- Decrement the countdown timer in the traffic lights
-- or reset it to 0 in the case of negative input (unlikely)
function decr (traffic_time: integer) return integer is
variable result: integer;


begin
    if (traffic_time > 0) then
        result := traffic_time - 1;
    else
        result := 0;
    end if;
    return result;
end function decr;




-- Count second yellow-light state timing
function yellow_count (car_speed: integer) return integer is
variable yellow_time: integer;


begin
    -- Sample formula to calculate second yellow time
    yellow_time := 1 + car_speed/20;
    return yellow_time;
end function yellow_count;




-- Count green-light state timing
function green_count (current_time: integer) return integer is
-- current_time in hours. Example: 12am -> 0; 1am -> 1; 5pm -> 17
variable green_time: integer;


begin
    case current_time is
        when 11 to 14 => green_time := 40;
        when 17 to 18 => green_time := 45;
        when 19 to 20 => green_time := 60;
        when 0 to 5 => green_time := 20;
        when 23 => green_time := 25;
        when others => green_time := 30;
    end case;
    return green_time;
end function green_count;




function car_number (time_count: integer) return integer is
variable car_num: integer;


begin
    -- Sample formula to calculate number of cars passing through green light
    -- In reality, a detector should be implemented to calculate the number
    if (time_count > 35) then
        -- Peak hour condition
        car_num := 5*1 + (time_count-15)*(time_count/10) + 10*2;
    else
        -- Non-peak hour
        car_num := time_count*2;
    end if;
    return car_num;
end function car_number;




function car_speed (car_num, time_count: integer) return integer is
variable car_spd: integer;


begin
    -- Sample formula to calculate average speed of cars passing through green light
    -- In reality, a detector should be implemented to calculate the speed
    if (time_count > 35) then
        -- Peak hour condition
        car_spd := 15*car_num/time_count;
    else
        -- Non-peak hour
        car_spd := 10*car_num/time_count;
    end if;
    return car_spd;
end function car_speed;
    
end mypackage;
