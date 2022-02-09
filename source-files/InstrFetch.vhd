----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2021 05:33:04 PM
-- Design Name: 
-- Module Name: InstrFetch - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstrFetch is
  Port (clk : in STD_LOGIC;
  en : in STD_LOGIC;
  reset : in STD_LOGIC;
  jump : in STD_LOGIC;
  PCSrc : in STD_LOGIC;
  branch_adr: in STD_LOGIC_VECTOR(15 downto 0);
  jump_adr: in STD_LOGIC_VECTOR(15 downto 0);
  instr: out STD_LOGIC_VECTOR(15 downto 0);
  next_instr_adr: out STD_LOGIC_VECTOR(15 downto 0) );
end InstrFetch;

architecture Behavioral of InstrFetch is

type ROM is array (0 to 63) of std_logic_vector(15 downto 0);
signal ROM1: ROM := 
( B"000_000_000_001_0_000", -- 0 add $1, $0 $0
 B"001_000_011_0001010", --1 addi $3 $0 10
 B"000_000_000_000_0_110", --2 noop
 B"010_001_100_0000000", --3 lw $4 0($1) -- minim
 B"010_001_101_0000000", --4 lw $5 0($1) --maxim
 B"000_000_000_000_0_110", --5 noop
 B"011_000_100_0001011", --6 sw $4 11($0) --11 minim
 B"011_000_101_0001100", --7 sw $5 12($0) --12 maxim
 B"100_001_011_0011011",--8 beq $1 $3 27 --if(i==10)jump
 B"000_000_000_000_0_110", --9 noop
 B"000_000_000_000_0_110", --10 noop
 B"000_000_000_000_0_110", --11 noop
 B"010_001_110_0000000",--12 lw $6 0($1) --elem curent
 B"000_000_000_000_0_110", --13 noop
 B"000_000_000_000_0_110",--14 noop
 B"000_101_110_111_0_001", --15 sub $7 $5 $6 --max
 B"000_000_000_000_0_110", --16 noop
 B"000_000_000_000_0_110", --17 noop
 B"110_111_000_0000101", --18 bgez $7 5
 B"000_000_000_000_0_110", --19 noop
 B"000_000_000_000_0_110", --20 noop
 B"000_000_000_000_0_110", --21 noop
 B"000_000_110_101_0_000", --22 add $6 $0 $5 5 = 6+0
 B"011_000_110_0001100", --23 sw $6 12($0)
 B"000_110_100_111_0_001", --24 sub $7 $6 $4 --min
 B"000_000_000_000_0_110", --25 noop
 B"000_000_000_000_0_110", --26 noop
 B"110_111_000_0000101",--27 bgez $7 5
 B"000_000_000_000_0_110", --28 noop
 B"000_000_000_000_0_110", --29 noop
 B"000_000_000_000_0_110", --30 noop
 B"000_000_110_100_0_000", --31 add $4 $0 $6 4 = 6 + 0
 B"011_000_110_0001011", --32 sw $6 11($0)
 B"001_001_001_0000001", --33 addi $1 1
 B"000_000_000_000_0_110", --34 noop
 B"111_0000000001000", --35 j 8
 B"000_000_000_000_0_110", --36 noop
 B"010_000_100_0001011", --37 lw $4 11($0)
 B"010_000_101_0001100", --38 lw $5 12($0)
 B"000_000_000_000_0_110", --39 noop
 B"000_000_000_000_0_110", --40 noop
 B"000_100_101_110_0_000", --41 add $6 $4 $5
 B"000_000_000_000_0_110", --42 noop
 B"000_000_000_000_0_110", --43 noop
 B"000_110_000_110_1_111", --44 sra $6 1
 others => x"0000");

signal prog_counter:  STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal prog_counter_sum:  STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal mux_jump:  STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal mux_branch:  STD_LOGIC_VECTOR(15 downto 0):=x"0000";

begin

    pc: process(clk, en, reset)
    begin
        if reset = '1' then
            prog_counter <= x"0000";
        end if;
        if clk'event and clk='1' then
            if en = '1' then
                prog_counter <= mux_jump;
            end if;
        end if;
    end process;
    
    sumator: prog_counter_sum <= prog_counter + 1;
    
    MUX1:process(PCSrc, branch_adr, prog_counter_sum)
    begin
        if PCSrc = '1' then
            mux_branch <= branch_adr;
        else
            mux_branch <= prog_counter_sum;
        end if;
    end process;
    
    MUX2:process(jump, jump_adr, mux_branch)
    begin
        if jump = '1' then
            mux_jump <= jump_adr;
        else
            mux_jump <= mux_branch;
        end if;
    end process;
    
    instr <= ROM1(conv_integer(prog_counter(6 downto 0)));
    next_instr_adr <= prog_counter_sum;
    
end Behavioral;
