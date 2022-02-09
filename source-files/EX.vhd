----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2021 12:14:29 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
  Port (next_instr_adr: in STD_LOGIC_VECTOR(15 downto 0);
    rd1: in std_logic_vector(15 downto 0);
    rd2: in std_logic_vector(15 downto 0);
    ext_imm: in std_logic_vector(15 downto 0);
    funct: in std_logic_vector(2 downto 0);
    sa: in std_logic;
    ALUsrc: in std_logic;
    ALUop: in std_logic_vector(1 downto 0);
    regdst:in std_logic;
    rt:in std_logic_vector(2 downto 0);
    rd:in std_logic_vector(2 downto 0);
    wa:out std_logic_vector(2 downto 0);
    AluRes: out std_logic_vector(15 downto 0);
    branch_adr: out std_logic_vector(15 downto 0);
    zero: out std_logic;
    bgtez: out std_logic );
end EX;

architecture Behavioral of EX is
signal b: std_logic_vector(15 downto 0);
signal alu_out: std_logic_vector(15 downto 0);
signal alu_ctrl: std_logic_vector(2 downto 0);
begin
    mux1:process(AluSrc, rd2, ext_imm)
    begin
    
        if ALUsrc = '0' then
            b <= rd2;
        else
            b <= ext_imm;
        end if;
    
    end process;
    
    ALUControl:process(AluOp, funct)
    begin
    
        case ALUop is
        when "00" => alu_ctrl <= "000";
        when "01" => alu_ctrl <= "001";
        when "10" => alu_ctrl <= funct; -- am gandit astfel incat aluctrl sa fie funct
        when others => alu_ctrl <= "100";
        end case;
    
    end process;
    
    ALU:process(rd1, b, alu_ctrl, sa)
    begin
        case alu_ctrl is
        when "000" => alu_out <= rd1 + b;
        when "001" => alu_out <= rd1 - b;
        when "010" =>
            if sa = '0' then
                alu_out <= rd1;
            else
                alu_out <= rd1(14 downto 0) & '0';
            end if;
        when "011" =>
            if sa = '0' then
                alu_out <= rd1;
            else
                alu_out <= '0' & rd1(15 downto 1) ;
            end if;
        when "100" => alu_out <= rd1 and b;
        when "101" => alu_out <= rd1 or b;
        when "110" => alu_out <= rd1 xor b;
        when others =>
            if sa = '0' then
                alu_out <= rd1;
            else
                if rd1(15) = '0' then
                    alu_out <= '0' & rd1(15 downto 1) ;
                else
                    alu_out <= '1' & rd1(15 downto 1) ;
                end if;
            end if;
        end case;
    
    end process;
    
    flaguri:process(rd1, b)
    begin
        if alu_out = x"0000" then
            zero <= '1';
        else
            zero <= '0';
        end if;
        bgtez <= not rd1(15);
    end process;
    
    write_adress:process(rt,rd,regdst)
    begin
        if(regdst = '0') then
            wa<=rt;
        else
            wa<=rd;
        end if;
    end process;
    
    branch_address: branch_adr <= next_instr_adr + ext_imm;
    AluRes <= alu_out;

end Behavioral;
