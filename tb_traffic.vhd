library IEEE;
use IEEE.STD_LOGIC_1164.ALL;




entity tb_main is
end tb_main;








architecture Behavioral of tb_main is




-- main inputs
signal clk      : std_logic:='0';
signal reset    : std_logic:='0';
signal jam      : integer:=0;
signal timer0   : integer:=0;
signal timer1   : integer:=0;
signal timer2   : integer:=0;
signal timer3   : integer:=0;
signal greenlamp    : std_logic_vector (3 downto 0):="0000";
signal yellowlamp   : std_logic_vector (3 downto 0):="0000";
signal redlamp      : std_logic_vector (3 downto 0):="0000";




-- additional variables for the test bench
constant clkprd : time:=50 ns;
signal count: integer:=0;




begin




uut: entity work.main port map (
    clk => clk,
    reset => reset,
    jam => jam,
    timer0 => timer0,
    timer1 => timer1,
    timer2 => timer2,
    timer3 => timer3,
    greenlamp => greenlamp,
    yellowlamp => yellowlamp,
    redlamp => redlamp);




clock_process: process
begin
    wait for clkprd/2;
    clk <= not clk;
    wait for clkprd/2;
    clk <= not clk;
    
    if count = 240 then
        count <= 0;
    else
        count <= count+1;
    end if;
end process;








time_process: process (count)
begin
    case count is
        when 0 to 9 => jam <= 0;
        when 10 to 19 => jam <= 1;
        when 20 to 29 => jam <= 2;
        when 30 to 39 => jam <= 3;
        when 40 to 49 => jam <= 4;
        when 50 to 59 => jam <= 5;
        when 60 to 69 => jam <= 6;
        when 70 to 79 => jam <= 7;
        when 80 to 89 => jam <= 8;
        when 90 to 99 => jam <= 9;
        when 100 to 109 => jam <= 10;
        when 110 to 119 => jam <= 11;
        when 120 to 129 => jam <= 12;
        when 130 to 139 => jam <= 13;
        when 140 to 149 => jam <= 14;
        when 150 to 159 => jam <= 15;
        when 160 to 169 => jam <= 16;
        when 170 to 179 => jam <= 17;
        when 180 to 189 => jam <= 18;
        when 190 to 199 => jam <= 19;
        when 200 to 209 => jam <= 20;
        when 210 to 219 => jam <= 21;
        when 220 to 229 => jam <= 22;
        when others => jam <= 23;
    end case;
end process;


reset_process: process
begin
    wait for 10 us;
    reset <= not reset;
    wait for 1 us;
    reset <= not reset;
    wait;
end process;


end Behavioral;
