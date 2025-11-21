
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Temporary_register is
    port (
        Clock        : in std_logic;
        CLR          : in std_logic;
        INR          : in std_logic;
        LD           : in std_logic;
        Bus_input    : in std_logic_vector(15 downto 0);
        Bus_output   : out std_logic_vector(15 downto 0)

    );
end Temporary_register;

architecture TR of Instruction_register is
        signal TR_reg : unsigned(15 downto 0);
begin 
    
    Bus_output <= std_logic_vector(TR_reg);
    process(Clock , CLR)
    begin
        if CLR = '1' then 
            TR_reg <= (others => '0');
        elsif rising_edge(Clock) then 
            if LD = '1' then 
                TR_reg <= unsigned(Bus_input);
            elsif INR = '1' then 
                TR_reg <= TR_reg + 1;
            end if;
        end if;

    end process;
end TR;

