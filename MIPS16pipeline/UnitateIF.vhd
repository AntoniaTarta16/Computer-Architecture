----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2023 02:48:12 PM
-- Design Name: 
-- Module Name: UnitateIF - Behavioral
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

entity UnitateIF is
    Port(   clk: in std_logic;
            en_PC: in std_logic;
            en_reset: in std_logic;
            branch_address: in std_logic_vector(15 downto 0);
            jump_address: in std_logic_vector(15 downto 0);
            jump: in std_logic;
            PCSrc: in std_logic;
            instruction: out std_logic_vector(15 downto 0);
            next_instruction_address: out std_logic_vector(15 downto 0));
end UnitateIF;

architecture Behavioral of UnitateIF is

signal PC: std_logic_vector(15 downto 0) := (others => '0');
signal out_MUX_JA: std_logic_vector(15 downto 0);
signal out_MUX_BA: std_logic_vector(15 downto 0);
signal out_sum: std_logic_vector(15 downto 0);
type ROM_array is array (0 to 255) of std_logic_vector(15 downto 0);
signal ROM: ROM_array := (

--B"000_000_000_101_0_110",  --xor $5, $0, $0      0056
--B"000_000_000_001_0_110",  --xor $1, $0, $0      0016
--B"000_000_000_010_0_110",  --xor $2, $0, $0      0026
--B"001_000_100_0000100",    --addi $4, $0, 4      2204
--B"100_001_100_0000111",    --beq $1, $4, 7       8607
--B"001_101_101_0000001",    --addi $5, $5, 1      3681
--B"000_101_001_101_0_000",  --add $5, $5, $1      14D0                                                                                       
--B"010_010_011_0000000",    --lw $3, v_addr($2)   4980
--B"000_101_011_101_0_001",  --sub $5, $5, $3      15D1                                  
--B"001_010_010_0000001",    --addi $2, $2, 1      2901
--B"001_001_001_0000001",    --addi $1, $1, 1      2481
--B"111_0000000000100",      --j 4                 E004
--B"011_101_101_0000000",    --sw $5, rez_addr($5) 7680

B"000_000_000_101_0_110",    --xor $5, $0, $0      0056
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"001_101_101_0000001",      --addi $5, $5, 1      3681
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"001_101_101_0000010",      --addi $5, $5, 2      3682
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"001_101_101_0000011",      --addi $5, $5, 3      3683
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"001_101_101_0000100",      --addi $5, $5, 4      3684
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"001_101_101_0000101",      --addi $5, $5, 5      3685
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_001_0_110",    --xor $1, $0, $0      0016
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_010_0_110",    --xor $2, $0, $0      0026
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"001_000_100_0000100",      --addi $4, $0, 4      2204
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"100_001_100_0010100",      --beq $1, $4, 20       8605
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"010_010_011_0000000",      --lw $3, v_addr($2)   4980
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_101_011_101_0_001",    --sub $5, $5, $3      15D1
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"001_010_010_0000001",      --addi $2, $2, 1      2901
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"001_001_001_0000001",      --addi $1, $1, 1      2481  
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"111_0000000100100",        --j 36                 E009
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"000_000_000_000_0_110",
B"011_101_101_0000000",      --sw $5, 0($5)        7680

  
others => X"0000" --NoOp (ADD $0, $0, $0) 
);

begin

process(PCSrc)
begin
    case PCSrc is
        when '0' => out_MUX_BA <= out_sum;
        when '1' => out_MUX_BA <= branch_address;
        when others => out_MUX_BA <= x"0000";
    end case;
end process;

process(jump)
begin 
    case jump is
        when '0' => out_MUX_JA <= out_MUX_BA;
        when '1' => out_MUX_JA <= jump_address;
        when others => out_mux_BA <= x"0000";
    end case;
end process;

out_sum <= PC + 1;

next_instruction_address <= out_sum;

process(clk, en_PC, en_reset)
begin
    if rising_edge(clk) then
        if en_reset = '1' then 
            PC <= x"0000"; 
        elsif en_PC = '1' then
            PC <= out_MUX_JA;
        end if;
    end if;
end process;

instruction <= ROM(conv_integer(PC(6 downto 0)));

end Behavioral;
