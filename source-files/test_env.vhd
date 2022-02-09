----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2021 04:40:08 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
 Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR(4 downto 0);
           sw : in STD_LOGIC_VECTOR(15 downto 0);
           led : out STD_LOGIC_VECTOR(15 downto 0);
           an : out STD_LOGIC_VECTOR(3 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end test_env;

architecture Behavioral of test_env is

-- generale
signal en: std_logic;
signal reset: std_logic;
signal digits: std_logic_vector(15 downto 0) := x"0000";
signal instr:  STD_LOGIC_VECTOR(15 downto 0) := x"0000";
signal next_instr_adr: STD_LOGIC_VECTOR(15 downto 0) := x"0000";

--IF
signal branch_adr: std_logic_vector(15 downto 0);
signal jump_adr: std_logic_vector(15 downto 0);

--ID
signal  wd: std_logic_vector(15 downto 0);
signal  rd1: std_logic_vector(15 downto 0);
signal  rd2: std_logic_vector(15 downto 0);
signal  ext_imm: std_logic_vector(15 downto 0);
signal  funct: std_logic_vector(2 downto 0);
signal  sa: std_logic;

-- semnale de control UC
signal regdst: std_logic;
signal regwrite: std_logic;
signal ALUsrc: std_logic;
signal extop: std_logic;
signal ALUop: std_logic_vector(1 downto 0);
signal memwrite: std_logic;
signal memtoreg: std_logic;
signal branch: std_logic;
signal branch_grt: std_logic;
signal jump: std_logic;
signal PCSrc: std_logic;

--semnale ALU EX
signal zero: std_logic;
signal bgtez: std_logic;
signal AluRes: std_logic_vector(15 downto 0);

--semnale MEM
signal mem_data: std_logic_vector(15 downto 0);
signal AluResOut: std_logic_vector(15 downto 0);

--IF_ID
signal IF_ID:std_logic_vector(31 downto 0):=x"00000000";

--ID_EX
signal ID_EX: std_logic_vector(82 downto 0);

--EX/MEM
signal EX_MEM: std_logic_vector(57 downto 0);

--MEM/WB
signal MEM_WB: std_logic_vector(36 downto 0);

signal wa: std_logic_vector(2 downto 0);

component MPG is
    Port(en: out  STD_LOGIC;
    input: in STD_LOGIC;
    clk : in  STD_LOGIC);
end component;

component SSD is
  Port (digits: in STD_LOGIC_VECTOR(15 downto 0);
  clk: in STD_LOGIC;
  an : out STD_LOGIC_VECTOR(3 downto 0);
  cat : out STD_LOGIC_VECTOR(6 downto 0) );
end component;

component InstrFetch is
  Port (clk : in STD_LOGIC;
  en : in STD_LOGIC;
  reset : in STD_LOGIC;
  jump : in STD_LOGIC;
  PCSrc : in STD_LOGIC;
  branch_adr: in STD_LOGIC_VECTOR(15 downto 0);
  jump_adr: in STD_LOGIC_VECTOR(15 downto 0);
  instr: out STD_LOGIC_VECTOR(15 downto 0);
  next_instr_adr: out STD_LOGIC_VECTOR(15 downto 0) );
end component;

component UC is
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
end component;

component ID is
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
end component;

component EX is
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
end component;

component MEM is
  Port (clk : in std_logic;
  en: in std_logic;
  memwrite: in std_logic;
  AluRes: in std_logic_vector(15 downto 0);
  rd2: in std_logic_vector(15 downto 0);
  mem_data: out std_logic_vector(15 downto 0);
  AluResOut: out std_logic_vector(15 downto 0) );
end component;

begin
    --OPCODE
    led(11) <= instr(15);
    led(10) <= instr(14);
    led(9) <= instr(13);
    
    --UC SIGNALS
    led(8) <= regdst;
    led(7) <= regwrite;
    led(6) <= ALUsrc;
    led(5) <= extop;
    led(4) <= memwrite;
    led(3) <= memtoreg;
    led(2) <= branch_grt;
    led(1) <= branch;
    led(0) <= jump;
    
    --flaguri
    led(15) <= zero;
    led(14) <= bgtez;
    
   --IF/ID
    process(clk,en)
    begin
        if clk'event and clk = '1' then
            if en='1' then
                IF_ID(31 downto 16) <= next_instr_adr;
                IF_ID(15 downto 0) <= instr;
            end if;
        end if;
    end process;
    
    --ID/EX
    process(clk,en)
    begin
        if clk'event and clk = '1' then
            if en='1' then
                ID_EX(82 downto 67) <= IF_ID(31 downto 16); --next_adr
                ID_EX(66 downto 51) <= rd1; --rd1
                ID_EX(50 downto 35) <= rd2; --rd2
                ID_EX(34 downto 19) <= ext_imm; --ext_imm
                ID_EX(18 downto 16) <= funct;
                ID_EX(15) <= sa;
                ID_EX(14 downto 12) <= IF_ID(9 downto 7); --rt
                ID_EX(11 downto 9) <= IF_ID(6 downto 4); --rd
                ID_EX(8) <= memtoreg;
                ID_EX(7) <= regwrite;
                ID_EX(6) <= memwrite;
                ID_EX(5) <= Branch;
                ID_EX(4) <= branch_grt;
                ID_EX(3 downto 2) <= ALUOp;
                ID_EX(1) <= ALUSrc;
                ID_EX(0) <= regdst;               
            end if;
        end if;
    end process;
    --EX/MEM
    process(clk,en)
    begin
        if clk'event and clk = '1' then
            if en='1' then
                EX_MEM(57 downto 42) <= branch_adr;
                EX_MEM(41 downto 26) <= ALURes;
                EX_MEM(25 downto 10) <= ID_EX(50 downto 35); --rd2
                EX_MEM(9 downto 7) <= wa;
                EX_MEM(6) <= zero;
                EX_MEM(5) <= bgtez;
                EX_MEM(4) <= ID_EX(8); --memtoreg
                EX_MEM(3) <= ID_EX(7); --regwrite
                EX_MEM(2) <= ID_EX(6); --memwrite
                EX_MEM(1) <= ID_EX(5); --branch
                EX_MEM(0) <= ID_EX(4); --branch_grt             
            end if;
        end if;
    end process;
    
    --MEM/WB
    process(clk,en)
    begin
        if clk'event and clk = '1' then
            if en='1' then   
                MEM_WB(36 downto 21) <= mem_data;
                MEM_WB(20 downto 5) <= EX_MEM(41 downto 26); --AluRes
                MEM_WB(4 downto 2) <= EX_MEM(9 downto 7); --wa  
                MEM_WB(1) <= EX_MEM(4); --memtoreg
                MEM_WB(0) <= EX_MEM(3); --regwrite
                
            end if;
        end if;
    end process;
    
    MPG1: MPG port map (en => en, input => btn(0), clk => clk);
    MPG2: MPG port map (en => reset, input => btn(1), clk => clk);
    SSD1: SSD port map(digits => digits, clk => clk, an => an, cat => cat);
    
    INSTRFETCH1: InstrFetch port map(clk => clk, en => en, reset => reset, jump => jump , PCSrc => PCSrc, branch_adr => EX_MEM(57 downto 42), jump_adr => jump_adr, instr => instr, next_instr_adr => next_instr_adr);
    
    ID1: ID port map(clk => clk, en => en,  regwrite => MEM_WB(0), extop => extop, instr => IF_ID(15 downto 0), wd => wd, wa => MEM_WB(4 downto 2), rd1 => rd1, rd2 => rd2, ext_imm => ext_imm, funct => funct, sa => sa);
    
    UC1: UC port map(opcode => IF_ID(15 downto 13), regdst => regdst, regwrite => regwrite, ALUsrc => ALUsrc, extop => extop, ALUop => ALUop, memwrite => memwrite, memtoreg => memtoreg, branch => branch, branch_grt => branch_grt, jump => jump);
    
    EX1: EX port map(next_instr_adr => ID_EX(82 downto 67), rd1 => ID_EX(66 downto 51), rd2 => ID_EX(50 downto 35), ext_imm => ID_EX(34 downto 19), funct => ID_EX(18 downto 16), sa => ID_EX(15), ALUsrc => ID_EX(1), ALUop => ID_EX(3 downto 2),regdst =>ID_EX(0),rt => ID_EX(14 downto 12), rd =>ID_EX(11 downto 9), wa=>wa, AluRes => AluRes, branch_adr => branch_adr, zero => zero, bgtez => bgtez);
    
    MEM1: MEM port map(clk => clk, en => en, memwrite => EX_MEM(2), AluRes => EX_MEM(41 downto 26), rd2 => EX_MEM(25 downto 10), mem_data => mem_data, AluResOut => AluResOut); 
    
    WB:process(MEM_WB)
    begin
    
        if MEM_WB(1) = '0' then
            wd <= MEM_WB(20 downto 5); --alures
        else
            wd <= MEM_WB(36 downto 21); --memdata
        end if;
    
    end process;
    
    --JUMP ADR
    jump_adr <= IF_ID(31 downto 29) & IF_ID(12 downto 0);
    
    --PCSrc
    PCSrc <= (EX_MEM(1) and EX_MEM(6)) or (EX_MEM(0) and EX_MEM(5)); --branch and zero or branch_grt and bgtez
    
    
    MUX: process(sw(7 downto 5), instr, next_instr_adr, rd1, rd2, wd)
    begin
    
        case sw(7 downto 5) is
        when "000" => digits <= instr;
        when "001" => digits <= next_instr_adr;
        when "010" => digits <= rd1;
        when "011" => digits <= rd2;
        when "100" => digits <= ext_imm;
        when "101" => digits <= AluRes;
        when "110" => digits <= mem_data;
        when others => digits <= wd;
        end case;
    
    end process;
    
end Behavioral;
