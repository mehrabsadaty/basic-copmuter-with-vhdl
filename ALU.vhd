library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port(
        AC      : in  std_logic_vector(15 downto 0);
        DR      : in  std_logic_vector(15 downto 0);
        INPR    : in  std_logic_vector(7 downto 0);
        E       : in  std_logic;
        ALU_control : in std_logic_vector(2 downto 0); 
        AC_out  : out std_logic_vector(15 downto 0);
        E_out   : out std_logic
    );
end ALU;

architecture Behavioral of ALU is
begin
    process(AC, DR, INPR, E, ALU_control)
        variable tmp : unsigned(15 downto 0);
    begin
        case ALU_control is

            when "000" =>  
                -- AND
                AC_out <= AC and DR;
                E_out  <= E;

            when "001" =>
                -- ADD
                tmp := unsigned(AC) + unsigned(DR);
                AC_out <= std_logic_vector(tmp);
                E_out  <= tmp(16); -- بیت حمل

            when "010" =>
                -- انتقال DR → AC
                AC_out <= DR;
                E_out  <= E;

            when "011" =>
                -- انتقال INPR → AC(0–7)
                AC_out <= AC(15 downto 8) & INPR;
                E_out  <= E;

            when "100" =>
                -- مکمل AC
                AC_out <= not AC;
                E_out  <= E;

            when "101" =>
                -- شیفت راست
                AC_out <= E & AC(15 downto 1);
                E_out  <= AC(0);

            when "110" =>
                -- شیفت چپ
                AC_out <= AC(14 downto 0) & E;
                E_out  <= AC(15);

            when "111" =>
                -- پاک کردن AC
                AC_out <= (others => '0');
                E_out  <= '0';

            when others =>
                AC_out <= AC;
                E_out  <= E;
        end case;
    end process;
end Behavioral;
