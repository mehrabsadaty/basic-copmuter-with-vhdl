library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Instruction_register is
    port (
        Clock        : in std_logic;
        CLR          : in std_logic;
        INR          : in std_logic;
        LD           : in std_logic;
        Bus_input    : in std_logic_vector(15 downto 0);
        Bus_output   : out std_logic_vector(15 downto 0)

    );
end Instruction_register;

architecture IR of Instruction_register is
        signal IR_reg : unsigned(15 downto 0);
begin 
    
    Bus_output <= std_logic_vector(IR_reg);
    process(Clock , CLR)
    begin
        if CLR = '1' then 
            IR_reg <= (others => '0');
        elsif rising_edge(Clock) then 
            if LD = '1' then 
                IR_reg <= unsigned(Bus_input);
            elsif INR = '1' then 
                IR_reg <= IR_reg + 1;
            end if;
        end if;

    end process;
end IR;

