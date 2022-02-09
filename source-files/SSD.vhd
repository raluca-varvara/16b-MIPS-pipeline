----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2021 05:36:35 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

entity SSD is
    Port (digits: in STD_LOGIC_VECTOR(15 downto 0);
     clk: in STD_LOGIC;
     an : out STD_LOGIC_VECTOR(3 downto 0);
     cat : out STD_LOGIC_VECTOR(6 downto 0) );
end SSD;

architecture Behavioral of SSD is

signal count: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal dig: STD_LOGIC_VECTOR(3 downto 0) := "0000";

begin

numarator: process(clk)
    begin
    if rising_edge(clk) then
        count <= count + 1;
    end if;
    end process;
    
    mux1: process(count,digits)
    begin
        case count(15 downto 14) is
            when "00" => dig <= digits(3 downto 0);
            when "01" => dig <= digits(7 downto 4);
            when "10" => dig <= digits(11 downto 8);
            when others => dig <= digits(15 downto 12);
        end case;
    end process;
    
    mux2: process(count)
    begin
        case count(15 downto 14) is
            when "00" => an <= "1110";
            when "01" => an <= "1101";
            when "10" => an <= "1011";
            when others => an <= "0111";
        end case;
    end process;
    
    HEXto7SEG: process(dig)
    begin
    case dig is
        when "0000" => cat <= "1000000"; --0     
        when "0001" => cat <= "1111001"; --1 
        when "0010" => cat <= "0100100"; --2 
        when "0011" => cat <= "0110000"; --3
        when "0100" => cat <= "0011011"; --4
        when "0101" => cat <= "0010010"; --5
        when "0110" => cat <= "0000010"; --6
        when "0111" => cat <= "1111000"; --7
        when "1000" => cat <= "0000000"; --8     
        when "1001" => cat <= "0010000"; --9
        when "1010" => cat <= "0001000"; --a
        when "1011" => cat <= "0000011"; --b
        when "1100" => cat <= "1000110"; --c
        when "1101" => cat <= "0100001"; --d
        when "1110" => cat <= "0000110"; --e
        when "1111" => cat <= "0001110"; --f
    end case;
    end process;

end Behavioral;
