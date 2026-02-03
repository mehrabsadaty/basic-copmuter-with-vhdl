library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port(
        AC      : in  std_logic_vector(15 downto 0);
        DR      : in  std_logic_vector(15 downto 0);
        INPR    : in  std_logic_vector(7 downto 0);
        E       : in  std_logic;
        ALU_op  : in std_logic_vector(3 downto 0);
        AC_out  : out std_logic_vector(15 downto 0);
        E_out   : out std_logic
    );
end ALU;

architecture Behavioral of ALU is
    signal temp_result : unsigned(16 downto 0);
    signal ac_unsigned : unsigned(15 downto 0);
    signal dr_unsigned : unsigned(15 downto 0);
    signal inpr_unsigned : unsigned(7 downto 0);
begin
    
    ac_unsigned <= unsigned(AC);
    dr_unsigned <= unsigned(DR);
    inpr_unsigned <= unsigned(INPR);
    
    process(AC, DR, INPR, E, ALU_op, ac_unsigned, dr_unsigned, inpr_unsigned)
    begin
        case ALU_op is
            when "0000" =>  -- ADD: AC + DR
                temp_result <= ('0' & ac_unsigned) + ('0' & dr_unsigned);
                AC_out <= std_logic_vector(temp_result(15 downto 0));
                E_out <= temp_result(16);
                
            when "0001" =>  -- ADDI: AC + 1
                temp_result <= ('0' & ac_unsigned) + 1;
                AC_out <= std_logic_vector(temp_result(15 downto 0));
                E_out <= temp_result(16);
                
            when "0010" =>  -- AND: AC AND DR
                AC_out <= AC and DR;
                E_out <= E;
                
            when "0011" =>  -- OR: AC OR DR
                AC_out <= AC or DR;
                E_out <= E;
                
            when "0100" =>  -- XOR: AC XOR DR
                AC_out <= AC xor DR;
                E_out <= E;
                
            when "0101" =>  -- NOT: NOT AC
                AC_out <= not AC;
                E_out <= E;
                
            when "0110" =>  -- SHL: Shift Left
                AC_out <= AC(14 downto 0) & '0';
                E_out <= AC(15);
                
            when "0111" =>  -- SHR: Shift Right
                AC_out <= '0' & AC(15 downto 1);
                E_out <= AC(0);
                
            when "1000" =>  -- CLR: Clear AC
                AC_out <= (others => '0');
                E_out <= '0';
                
            when "1001" =>  -- CMA: Complement AC
                AC_out <= not AC;
                E_out <= E;
                
            when "1010" =>  -- CME: Complement E
                AC_out <= AC;
                E_out <= not E;
                
            when "1011" =>  -- INP: Input from INPR
                AC_out <= "00000000" & INPR;
                E_out <= E;
                
            when others =>
                AC_out <= AC;
                E_out <= E;
        end case;
    end process;
 
end Behavioral;