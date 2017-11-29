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
--library IEEE; 
--use IEEE.STD_LOGIC_1164.ALL; 
--use IEEE.STD_LOGIC_ARITH.ALL; 
--use IEEE.STD_LOGIC_UNSIGNED.ALL; 

--entity slow_clock is 
--Port (   CLK : in std_logic;
--         slowclk : out std_logic);
--end entity;

--architecture behavioural of slow_clock is 
--signal counter : integer:= 0;
--signal slowc : std_logic;
--begin

--process (clk)
--begin
---- should fix upon this value of counter
--    if (counter = 100000) then
--        slowc <= not slowc;
--        counter <= 0;
--    elsif (clk='1' and clk'event) then
--        counter <= counter + 1;
--    end if;
--end process;
--   slowclk <= slowc;
--end behavioural;

library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity Dflipflop is 
Port (  CLK : in std_logic; 
        Reset : in std_logic; 
        D : in std_logic; 
        Q : out std_logic); 
end Dflipflop; 
architecture Behavioral of Dflipflop is 
begin 
process (CLK) 
begin 
    if CLK'event and CLK='1' then 
        if reset='1' then 
            Q <= '1'; 
        else 
            Q <= D; 
        end if; 
    end if; 
end process; 
end Behavioral; 

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
           toSSD : out STD_LOGIC_VECTOR (15 downto 0);
           output_LED : out STD_LOGIC);
end miniproject_ReflexTester;

architecture Behavioral of miniproject_ReflexTester is

component Dflipflop 
Port ( CLK : in std_logic; 
       Reset : in std_logic; 
       D : in std_logic; 
       Q : out std_logic); 
end component; 

Type State_type is (initial, proceed, final);
SIGNAL State : State_Type;
signal tap_data, data_out : std_logic;
signal count : integer;
signal data_reg : std_logic_vector (15 downto 0);
signal counter : integer:= 0;
signal slowc : std_logic;

begin

process(clk,reset)
begin
	if(reset='1') then
	   State<=initial;
	elsif(clk='1' and clk'event) then
	   case State is 
	   when initial =>
	       if (start = '1') then
	           count<= 0;
	           data_reg <= "1100000000000000";
	           toSSD<= "0000101000010000";
	           State<= proceed;
	       end if;
	   when proceed =>
	       tap_data <= (data_reg(1) xor data_reg(2)) xor (data_reg(3) xor data_reg(15));  
	-- check which bit you have to consider to be the output
	        
	   when final =>
	   when others =>
	       state<= initial;
	   end case;
	end if;
end process;

process (clk)
begin
-- should fix upon this value of counter
    if (counter = 100000) then
        slowc <= not slowc;
        counter <= 0;
    elsif (clk='1' and clk'event) then
        counter <= counter + 1;
    end if;
end process;

stage0: Dflipflop 
    port map(CLK=> slowc, reset=>reset, D=>tap_data, Q=>data_reg(0)); 
g0:for i in 0 to 14 generate 
stageN: Dflipflop 
    port map(CLK=>slowc, reset=>reset, D=>data_reg(i), Q=>data_reg(i+1)); 
end generate;

end Behavioral;
