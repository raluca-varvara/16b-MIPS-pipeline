----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2021 06:11:02 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
  Port (clk: in std_logic;
  en: in std_logic;
  regwrite: in std_logic;
  extop: in std_logic;
  instr: in std_logic_vector(15 downto 0);
  wd: in std_logic_vector(15 downto 0);
  wa: in std_logic_vector(2 downto 0);
  rd1: out std_logic_vector(15 downto 0);
  rd2: out std_logic_vector(15 downto 0);
  ext_imm: out std_logic_vector(15 downto 0);
  funct: out std_logic_vector(2 downto 0);
  sa: out std_logic );
end ID;

architecture Behavioral of ID is

component RF is
 Port (clk : in std_logic;
       wen : in std_logic;
       en : in std_logic;
       ra1 : in std_logic_vector (2 downto 0);
       ra2 : in std_logic_vector (2 downto 0);
       wa : in std_logic_vector (2 downto 0);
       wd : in std_logic_vector (15 downto 0);      
       rd1 : out std_logic_vector (15 downto 0);
       rd2 : out std_logic_vector (15 downto 0));
end component;

--signal writeadr: std_logic_vector(2 downto 0);
signal ra1: std_logic_vector(2 downto 0);
signal ra2: std_logic_vector(2 downto 0);

begin
    --funct
    funct <= instr(2 downto 0);
    --sa 
    sa <= instr(3);
    
--    mux: process(regdst, instr)
--    begin
--        if regdst = '0' then
--            writeadr <= instr(9 downto 7);
--        else
--            writeadr <= instr(6 downto 4);
--        end if;
--    end process;
    
    extension_unit: process(extop, instr)
    begin
        
        if extop = '0' then
            ext_imm <= "000000000" & instr(6 downto 0);
        else
            if instr(6) = '0' then
                ext_imm <= "000000000" & instr(6 downto 0);
            else
                ext_imm <= "111111111" & instr(6 downto 0);
            end if;
        end if;
    
    end process;
    
    --REGISTER FILE
    ra1 <= instr(12 downto 10);
    ra2 <= instr(9 downto 7);
    RF1: RF port map(clk => clk, wen => regwrite, en => en, ra1 => ra1, ra2 => ra2, wa => wa, wd => wd, rd1 => rd1, rd2 => rd2);

end Behavioral;
