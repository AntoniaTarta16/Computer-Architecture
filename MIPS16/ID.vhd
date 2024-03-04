----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.04.2023 15:37:35
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID is
  Port ( RegWrite: in std_logic;
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
end ID;

architecture Behavioral of ID is

component Bloc_de_registre is
    port (
    clk : in std_logic;
    ra1 : in std_logic_vector (2 downto 0);
    ra2 : in std_logic_vector (2 downto 0);
    wa : in std_logic_vector (2 downto 0);
    wd : in std_logic_vector (15 downto 0);
    wen : in std_logic;
    rd1 : out std_logic_vector (15 downto 0);
    rd2 : out std_logic_vector (15 downto 0);
    en:in std_logic
    );
end component;

signal WriteAddress: std_logic_vector(2 downto 0);
signal extbit: std_logic_vector (8 downto 0);

begin
    RF1: Bloc_de_registre port map(clk,Instr(12 downto 10), Instr(9 downto 7), WriteAddress,WD,RegWrite,RD1,RD2,en);
    WriteAddress<=Instr(9 downto 7) when RegDst='0' else Instr(6 downto 4);
    
    func<=Instr(2 downto 0);
    sa<= Instr(3);
    
    extbit<="000000000" when Instr(6)='0' else "111111111";
    
    Ext_imm<="000000000"&Instr(6 downto 0) when ExtOp='0' else extbit&Instr(6 downto 0);
                    
end Behavioral;