----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2017 09:47:22 PM
-- Design Name: 
-- Module Name: Response_time - Behavioral
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

entity Response_time is
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           user_input : in STD_LOGIC;
           output_LED : out STD_LOGIC;
           toSSD : out STD_LOGIC_VECTOR (15 downto 0));
end Response_time;

architecture Behavioral of Response_time is

Type State_type is (initial, proceed, final);
SIGNAL State : State_Type := initial;
signal tap_data : std_logic:= '0';
signal count, t: integer;
signal data : std_logic_vector (15 downto 0);
signal counter : integer:= 0;
signal slowc : std_logic:= '0';


begin
process(clk,reset)
begin
	if(reset='1') then
	   State<=initial;
	elsif(clk='1' and clk'event) then
	   case State is 
	   when initial =>
	       if (start = '1') then
	           count <= 0;
	           t <= 0;
	         --  num <= 0;
	           output_LED <= '0';
	           tap_data <= '0';
	           data <= "1111111111111111";
	           toSSD <=    "0000101000010000";
	           State<= proceed;
	       end if;
	   when proceed =>
	       tap_data <= (data(1) xor data(2)) xor (data(3) xor data(15));  
	-- check which bit you have to consider to be the output
	       if (data(6) = '1' and data(5) = '0') then
	            -- got to decide this number
	            if (count < 1000000) then
	               output_LED <= '1';
	            else
	               output_LED <= '0';
	            end if;
            --    num <= num + 1;
	            count <= 0;
           end if;
	       count <= count + 1;
	       if (user_input = '1') then
	           -- Got to decide this least count
	           t <= t + count/100000;
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



end Behavioral;
