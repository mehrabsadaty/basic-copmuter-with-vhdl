library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port(
        AC      : in  std_logic_vector(15 downto 0);
        DR      : in  std_logic_vector(15 downto 0);
        INPR    : in  std_logic_vector(7 downto 0);
        E       : in  std_logic;
        ALU_op : in std_logic_vector(3 downto 0); 
        AC_out  : out std_logic_vector(15 downto 0);
        E_out   : out std_logic
    );
end ALU;

architecture Behavioral of ALU is
begin
    



 
end Behavioral;
