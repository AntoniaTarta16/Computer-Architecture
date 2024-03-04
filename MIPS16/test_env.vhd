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
        Port( RegWrite: in std_logic;
              Instr: in std_logic_vector(15 downto 0);
              RegDst: in std_logic;
              clk: in std_logic;
              en:in std_logic;
              ExtOp: in std_logic;
              WD:in std_logic_vector(15 downto 0);
              RD1: out std_logic_vector(15 downto 0);
              RD2: out std_logic_vector (15 downto 0);
              Ext_imm: out std_logic_vector (15 downto 0);
              func: out std_logic_vector(2 downto 0);
              sa : out std_logic);
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
          BranchAddress: out std_logic_Vector(15 downto 0));
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

    
begin
    
led(10 downto 0)<=ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemToReg & RegWrite; 
          --      3        1         1      1       1        1        1           1          1
JumpAddress<=PCplus1(15 downto 13) & Instruction(12 downto 0);
WD<=ALUResOut when MemToReg='0' else MemData;
PCSrc<= Branch and Zero;

MPG1 : MPG port map(btn(0), clk, enable1);

MPG2 : MPG port map(btn(1), clk, enable2);

IF1 : UnitateIF port map  (clk, enable1, enable2, BranchAddress, JumpAddress, Jump, PCSrc, Instruction, PCplus1);


ID1: ID port map (RegWrite, Instruction, RegDst, clk, enable1, ExtOp, WD, RD1, RD2, ExtImm, func, sa);

UC1: UC port map (Instruction, RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemToReg, RegWrite);

EX1: EX port map (RD1, RD2, ALUSrc, ExtImm, sa, func, ALUOp, PCplus1, Zero, ALURes, BranchAddress);

MEM1: MEM port map (MemWrite, ALURes, RD2, clk, enable1, MemData, ALUResOut);

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

end Behavioral;
