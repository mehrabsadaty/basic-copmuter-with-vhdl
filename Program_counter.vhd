
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Program_counter is
    port(
        Clock        : in std_logic;
        CLR          : in std_logic;
        INR          : in std_logic;
        LD           : in std_logic;
        Bus_input    : in std_logic_vector(11 downto 0);
        Bus_output   : out std_logic_vector(11 downto 0)
    );
end Program_counter;

architecture PC of Program_counter is
    signal PC_reg : unsigned(11 downto 0);
begin

    Bus_output <= std_logic_vector(PC_reg);

    process(Clock, CLR)
    begin
        if CLR = '1' then
            PC_reg <= (others => '0');

        elsif rising_edge(Clock) then
            if LD = '1' then
                PC_reg <= unsigned(Bus_input);
            elsif INR = '1' then
                PC_reg <= PC_reg + 1;
            end if;
        end if;
    end process;

end PC;

