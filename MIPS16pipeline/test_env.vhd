----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2023 02:50:44 AM
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
         btn : in STD_LOGIC_VECTOR (4 downto 0);
         sw : in STD_LOGIC_VECTOR (15 downto 0);
         led : out STD_LOGIC_VECTOR (15 downto 0);
         an : out STD_LOGIC_VECTOR (3 downto 0);
         cat : out STD_LOGIC_VECTOR (6 downto 0));
end entity;

architecture Behavioral of test_env is

    component MPG is
        Port ( btn : in STD_LOGIC;
               clk : in STD_LOGIC;
               en : out STD_LOGIC);
    end component;
    
    component SSD is
    Port ( digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
    end component; 
    
    component UnitateIF is
         Port(   clk: in std_logic;
                 en_PC: in std_logic;
                 en_reset: in std_logic;
                 branch_address: in std_logic_vector(15 downto 0);
                 jump_address: in std_logic_vector(15 downto 0);
                 jump: in std_logic;
                 PCSrc: in std_logic;
                 instruction: out std_logic_vector(15 downto 0);
                 next_instruction_address: out std_logic_vector(15 downto 0));
    end component;
    
    component UC is
        Port( Instr:in std_logic_vector(15 downto 0);
              RegDst: out std_logic;
              ExtOp: out std_logic;
              ALUSrc: out std_logic;
              Branch: out std_logic;
              Jump: out std_logic;
              ALUOp: out std_logic_vector (2 downto 0);
              MemWrite: out std_logic;
              MemToReg: out std_logic;
              RegWrite: out std_logic);
    end component;
    
    component ID is
    Port ( RegWrite: in std_logic;
        Instr: in std_logic_vector(15 downto 0);
        clk: in std_logic;
        en:in std_logic;
        ExtOp: in std_logic;
        WD:in std_logic_vector(15 downto 0);
        WA: in std_logic_vector(2 downto 0); 
        RD1: out std_logic_vector(15 downto 0);
        RD2: out std_logic_vector (15 downto 0);
        Ext_imm: out std_logic_vector (15 downto 0);
        func: out std_logic_vector(2 downto 0);
        sa : out std_logic;
        rt: out std_logic_vector (2 downto 0);
        rd: out std_logic_vector (2 downto 0));
    end component;
    
    component EX is
    Port( RD1: in std_logic_vector(15 downto 0);
          RD2: in std_logic_vector (15 downto 0);
          ALUSrc: in std_logic;
          Ext_imm: in std_logic_vector(15 downto 0);
          sa: in std_logic;
          func: in std_logic_vector(2 downto 0);
          ALUOp: in std_logic_vector (2 downto 0);
          PCplus1: in std_logic_vector (15 downto 0);
          Zero: out std_logic;
          ALURes: out std_logic_vector (15 downto 0);
          BranchAddress: out std_logic_Vector(15 downto 0);
          rt: in std_logic_vector (2 downto 0);
          rd: in std_logic_vector (2 downto 0);
          RegDst: in std_logic;
          rWA: out std_logic_vector (2 downto 0)
          );  
     end component;
     
     component MEM is
     Port(MemWrite: in std_logic;
          ALUResIn: in std_logic_vector(15 downto 0);
          RD2: in std_logic_vector (15 downto 0);
          clk: in std_logic;
          en: in std_logic;
          MemData: out std_logic_vector(15 downto 0);
          ALUResOut: out std_logic_vector (15 downto 0));
    end component;
    
    signal out1 : std_logic_vector (15 downto 0);
    signal enable1, enable2: std_logic;
    signal PCplus1:  std_logic_vector(15 downto 0);
    signal Instruction:  std_logic_vector (15 downto 0);
    signal Jump, MemToReg, MemWrite, Branch, ALUSrc :std_logic;
    signal RegWrite, RegDst, ExtOp, sa: std_logic;
    signal ALUOp: std_logic_vector (2 downto 0);
    signal RD1, RD2, ExtImm, WD: std_logic_vector (15 downto 0);
    signal func: std_logic_vector (2 downto 0);
    signal JumpAddress, BranchAddress, ALURes, MemData, ALUResOut: std_logic_vector(15 downto 0);
    signal PCSrc, Zero :std_logic;
    signal rd, rt, rWA: std_logic_vector(2 downto 0);

    signal IF_ID: std_logic_vector (31 downto 0);
    signal ID_EX: std_logic_vector (66 downto 0);
    signal EX_MEM: std_logic_vector (55 downto 0);
    signal MEM_WB: std_logic_vector (36 downto 0);
    
    signal AuxMemData:std_logic_vector(15 downto 0);
    signal AuxAluRes:std_logic_vector(15 downto 0);
    signal AuxrWA:std_logic_vector(2 downto 0);
    signal AuxWB:std_logic_vector(1 downto 0);
    
    
begin
IF_ID<=Instruction & PCplus1;
ID_EX<=rt & rd & sa & ExtImm & RD2 & RD1 & func & RegDst & ALUSrc & ALUOp & Branch & MemWrite & RegWrite & MemToReg;
EX_MEM<=rWA & ID_EX(43 downto 28) & ALURes & Zero & BranchAddress & ID_EX(3 downto 0);
--MEM_WB<=EX_MEM(55 downto 53) & EX_MEM(36 downto 21) & MemData & EX_MEM(1 downto 0);
MEM_WB<=AuxrWA & AuxAluRes & AuxMemData & AuxWB;

led(10 downto 0)<=ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemToReg & RegWrite; 
          --      3        1         1      1       1        1        1           1          1
JumpAddress<=IF_ID(15 downto 13) & IF_ID(28 downto 16);
WD<=MEM_WB(33 downto 18) when MEM_WB(0)='0' else MEM_WB(17 downto 2);
PCSrc<= EX_MEM(3) and EX_MEM(20);

MPG1 : MPG port map(btn(0), clk, enable1);

MPG2 : MPG port map(btn(1), clk, enable2);

IF1 : UnitateIF port map  (clk, enable1, enable2, EX_MEM(19 downto 4), JumpAddress, Jump, PCSrc, Instruction, PCplus1);

ID1: ID port map (RegWrite, IF_ID(31 downto 16), clk, enable1, ExtOp, WD, MEM_WB(36 downto 34), RD1, RD2, ExtImm, func, sa,rt, rd);

UC1: UC port map (IF_ID(31 downto 16), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemToReg, RegWrite);

EX1: EX port map (ID_EX(27 downto 12), ID_EX(43 downto 28), ID_EX(7), ID_EX(59 downto 44), ID_EX(60), ID_EX(11 downto 9), ID_EX(6 downto 4), IF_ID(15 downto 0), Zero, ALURes, BranchAddress, ID_EX(66 downto 64), ID_EX(63 downto 61),ID_EX(8), rWA);

MEM1: MEM port map (EX_MEM(2), EX_MEM(36 downto 21), EX_MEM(52 downto 37), clk, enable1, MemData, EX_MEM(36 downto 21));

SSD1 : SSD port map(out1(3 downto 0), out1(7 downto 4), out1(11 downto 8), out1(15 downto 12), clk, an, cat);

with sw(7 downto 5) Select
out1<=Instruction when "000",
    PCPlus1 when "001",
    RD1 when "010",
    RD2 when "011",
    ExtImm when "100",
    ALURes when "101",
    MemData when "110",
    WD when "111";
    
process(clk)
    begin
    if rising_edge(clk) then
        if enable1='1' then
            AuxMemData<=MemData;
            AuxAluRes<=EX_MEM(36 downto 21);
            AuxrWA<=EX_MEM(55 downto 53);
            AuxWB<=EX_MEM(1 downto 0);
        end if;
    end if;
    end process;

end Behavioral;
