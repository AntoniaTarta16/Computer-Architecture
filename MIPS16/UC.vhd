----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2020 05:00:29 PM
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
end UC;

architecture Behavioral of UC is

begin
    --RegDst<='0'; ExtOp<='0'; ALUSrc<='0'; Branch<='0'; Jump<='0';
    --MemWrite<='0'; MemToReg<='0'; RegWrite<='0'; ALUOp<="000"; 
    process (Instr)
    begin
    
--        case Instr(15 downto 13) is
--        when "000" => RegDst<='1'; RegWrite<='1';  --tip R
--        when "001" => ExtOp<='1'; ALUSrc<='1'; RegWrite<='1'; ALUOp<="001"; --addi
--        when "010" => ExtOp<='1'; ALUSrc<='1'; MemToReg<='1'; RegWrite<='1'; ALUOp<="001"; --lw
--        when "011" => ExtOp<='1'; ALUSrc<='1'; MemWrite<='1'; ALUOp<="001"; --sw
--        when "100" => ExtOp<='1'; Branch<='1'; ALUOp<="010"; --beq
--        when "101" => ALUSrc<='1'; RegWrite<='1'; ALUOp<="011"; --andi
--        when "110" => ALUSrc<='1'; RegWrite<='1'; ALUOp<="100"; --ori
--        when "111" => Jump<='1'; ALUOp<="111"; --j xxx
--        end case;
          case Instr(15 downto 13) is
          when "000" => RegDst<='1'; RegWrite<='1';ExtOp<='0'; ALUSrc<='0';Branch<='0';Jump<='0'; MemWrite<='0';MemToReg<='0';ALUOp<="000"; --R
          when "001" => ExtOp<='1'; ALUSrc<='1'; RegWrite<='1'; ALUOp<="001";RegDst<='0';Branch<='0';Jump<='0';MemWrite<='0';MemToReg<='0';-- addi
          when "010" => ExtOp<='1'; ALUSrc<='1'; MemToReg<='1'; RegWrite<='1'; ALUOp<="001";RegDst<='0';Branch<='0';Jump<='0';MemWrite<='0';--lw
          when "011" => ExtOp<='1'; ALUSrc<='1'; MemWrite<='1'; ALUOp<="001";RegDst<='0';Branch<='0'; Jump<='0';MemToReg<='0';RegWrite<='0';--sw
          when "100" => ExtOp<='1'; ALUSrc<='0'; Branch<='1'; ALUOp<="010";RegDst<='0';Jump<='0';MemWrite<='0';MemToReg<='0';RegWrite<='0'; --beq
          when "101" => ExtOp<='0'; ALUSrc<='1'; RegWrite<='1'; ALUOp<="011";RegDst<='0';Branch<='0'; Jump<='0';MemWrite<='0';MemToReg<='0'; --andi
          when "110" => ExtOp<='0'; ALUSrc<='1'; ALUOp<="100";RegDst<='0';Branch<='0'; Jump<='0'; MemWrite<='0';MemToReg<='0';RegWrite<='1';--ori
          when "111" => Jump<='1'; ALUOp<="111"; RegDst<='0';ExtOp<='0';ALUSrc<='0';Branch<='0';MemWrite<='0';MemToReg<='0';RegWrite<='0'; --j
          end case;
    end process;

end Behavioral;
