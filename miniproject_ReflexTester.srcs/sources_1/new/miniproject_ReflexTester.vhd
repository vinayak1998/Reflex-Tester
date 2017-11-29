----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2017 02:05:32 PM
-- Design Name: 
-- Module Name: Reflex_Tester - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity miniproject_ReflexTester is
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           user_input : in STD_LOGIC;
           cathode:out std_logic_vector(6 downto 0);
           anode: out std_logic_vector(3 downto 0);
           output_LED : out STD_LOGIC);
end miniproject_ReflexTester;

architecture Behavioral of miniproject_ReflexTester is

component Dflipflop 
Port ( CLK : in std_logic; 
       Reset : in std_logic; 
       D : in std_logic; 
       start : in std_logic;
       Q : out std_logic); 
end component;


component lab4_seven_segment_display 
   port ( b          : in    std_logic_vector (15 downto 0); 
       clk        : in    std_logic; 
       pushbutton : in    std_logic; 
       anode      : out   std_logic_vector (3 downto 0); 
       cathode    : out   std_logic_vector (6 downto 0)); 
end component; 

Type State_type is (initial, proceed, final);
SIGNAL State : State_Type := initial;
signal tap_data : std_logic:= '0';
signal count, t, num: integer;
signal data : std_logic_vector (15 downto 0);
signal counter : integer:= 0;
signal slowc : std_logic:= '0';
signal toSSD : std_logic_vector (15 downto 0);

begin

process(clk,reset)
begin
	if(reset='1') then
	   State<=initial;
	elsif(clk='1' and clk'event) then
	   case State is 
	   when initial =>
	       if (start = '1') then
	           t <= 0;
	           num<= 0;
	           count<= 0;
	           output_LED <= '0';
	           tap_data <= '0';
	           toSSD <= "0000101000010000";
	           State<= proceed;
	       end if;
	   when proceed =>
	       tap_data <= (data(1) xor data(2)) xor (data(3) xor data(15));  
	       if (data(15) = '1' and data(14) = '0') then
	            count <= 0;
	            num <= num + 1;
           end if;
           -- Each LED glows for 100ms 
           if (count < 100000000) then
              output_LED <= '1';
              count <= count + 1;
           else
              output_LED <= '0';
           end if;
	        
	       
	       if (user_input = '1') then
	           -- Got to decide this least count
	           if (num > 1) then
	               t <= t + count/8388608;
	               
	           end if;
	           -- time has to be multiplied by a factor of 8.388*10^(-2)
	       end if;
	       if (stop = '1') then
	           state <= final;
	       end if;
	   when final =>
	       toSSD <= std_logic_vector(to_unsigned(t, 16));
	   when others =>
	       state<= initial;
	   end case;
	end if;
end process;



process (clk)
begin

-- time period of slow clock is 1s.
    if (counter = 100000000) then
        slowc <= not slowc;
        counter <= 0;
    elsif (clk='1' and clk'event) then
        counter <= counter + 1;
    end if;
end process;

harsha: Dflipflop
    port map(CLK=> slowc, reset=>reset, D=>tap_data,start=>start, Q=>data(0)); 
g0:for i in 0 to 14 generate 
stageN: Dflipflop 
    port map(CLK=>slowc, reset=>reset, D=>data(i), start=>start, Q=>data(i+1)); 
end generate;
SSD: lab4_seven_segment_display
    port map(b=> toSSD, clk=>clk, pushbutton=> '0', anode=> anode, cathode=> cathode);

end Behavioral;
