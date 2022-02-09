----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2021 07:24:58 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
  Port (opcode: in std_logic_vector(2 downto 0);
  regdst: out std_logic;
  regwrite: out std_logic;
  ALUsrc: out std_logic;
  extop: out std_logic;
  ALUop: out std_logic_vector(1 downto 0);
  memwrite: out std_logic;
  memtoreg: out std_logic;
  branch: out std_logic;
  branch_grt: out std_logic;
  jump: out std_logic);
end UC;

architecture Behavioral of UC is

begin
    process(opcode)
    begin
        regdst <= '0';
        regwrite <= '0';
        ALUsrc <= '0';
        extop <= '0';
        ALUop <= "00";
        memwrite <= '0';
        memtoreg <= '0';
        branch <= '0';
        branch_grt <= '0';
        jump <= '0';
        
        case opcode is
            when "000" => regdst <= '1'; regwrite <= '1'; ALUop <= "10"; --tip r
            when "001" => regwrite <= '1'; ALUsrc <= '1'; extop <= '1'; --addi
            when "010" => regwrite <= '1'; ALUsrc <= '1'; extop <= '1'; memtoreg <= '1'; --lw
            when "011" => ALUsrc <= '1'; extop <= '1'; memwrite <= '1'; --sw
            when "100" => extop <= '1'; ALUop <= "01"; branch <= '1'; --beq
            when "101" => regwrite <= '1'; ALUsrc <= '1'; ALUop <= "11"; --andi
            when "110" => extop <= '1'; branch_grt <= '1';
            when others => jump <= '1';
        end case;
        
    end process;

end Behavioral;
