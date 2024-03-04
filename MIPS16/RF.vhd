----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2023 05:24:29 PM
-- Design Name: 
-- Module Name: Bloc_de_registre - Behavioral
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

entity Bloc_de_registre is
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
end Bloc_de_registre;

architecture Behavioral of Bloc_de_registre is

--    type reg is array (0 to 15) of std_logic_vector(15 downto 0);
--    signal registru: reg:=(x"0110",x"0001",x"0002",x"0003",x"0004",x"0005",x"0006",x"0007",
--            x"0008",x"0009",x"000a",x"000b",x"000c",x"000d",x"000e",x"000f", others=>x"0010");
    type reg is array (0 to 7) of std_logic_vector(15 downto 0);
    signal registru: reg:=(x"0000", others=>x"0000");
begin

process(clk)
begin
    if rising_edge(clk) then
        if en='1' and wen = '1' then
            registru(conv_integer(wa)) <= wd;
        end if;
    end if;
 end process;
        rd1 <= registru(conv_integer(ra1));
        rd2 <= registru(conv_integer(ra2));
end Behavioral;