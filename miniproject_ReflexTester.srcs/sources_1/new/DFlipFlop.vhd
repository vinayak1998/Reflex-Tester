----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2017 02:16:30 PM
-- Design Name: 
-- Module Name: DFlipFlop - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity Dflipflop is 
Port (  CLK : in std_logic; 
        Reset : in std_logic; 
        D : in std_logic;
        start : in std_logic; 
        Q : out std_logic); 
end Dflipflop; 
architecture Behavioral of Dflipflop is  
begin 
process (CLK, start) 
begin 
    if  (start = '1') then
       Q <= '1'; 
    elsif (CLK'event and CLK='1') then 
        
        if (reset='1') then 
            Q <= '1'; 
        else 
            Q <= D; 
        end if; 
    end if; 
end process; 
end Behavioral; 