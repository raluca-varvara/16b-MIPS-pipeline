----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2021 05:34:44 PM
-- Design Name: 
-- Module Name: MPG - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MPG is
    Port(en: out  STD_LOGIC;
    input: in STD_LOGIC;
    clk : in  STD_LOGIC);
end MPG;

architecture Behavioral of MPG is

signal cnt: std_logic_vector(15 downto 0) := "0000000000000000";
signal Q1 : std_logic;
signal Q2 : std_logic;
signal Q3 : std_logic;

begin


    numarator:process(clk)
    begin
    if rising_edge(clk) then
        cnt <= cnt + 1;
    end if;
    end process;
    
    D1: process (clk, cnt)
    begin
    if clk'event and clk='1' then
        if cnt(15 downto 0) = "1111111111111111" then
            Q1 <= input; -- am considerat input sa fie butonul 0
        end if;
    end if;
    
    end process;
        
    D23: process(clk, Q1)
    begin
    if rising_edge(clk) then
        Q2 <= Q1;
        Q3 <= Q2;
    end if;
    
    end process;
    
    en <= Q2 and (not Q3);

end Behavioral;

