library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Address_register is
    port(
        Clock        : in std_logic;
        CLR          : in std_logic;
        INR          : in std_logic;
        LD           : in std_logic;
        Bus_input    : in std_logic_vector(11 downto 0);
        Bus_output   : out std_logic_vector(11 downto 0);
        memory_output : out std_logic_vector(11 downto 0)
    );
end Address_register;

architecture AR of Address_register is
    signal AR_reg : unsigned(11 downto 0);
begin

    Bus_output <= std_logic_vector(AR_reg);
    memory_output <= std_logic_vector(AR_reg);

    process(Clock, CLR)
    begin
        if CLR = '1' then
            AR_reg <= (others => '0');

        elsif rising_edge(Clock) then
            if LD = '1' then
                AR_reg <= unsigned(Bus_input);
            elsif INR = '1' then
                AR_reg <= AR_reg + 1;
            end if;
        end if;
    end process;

end AR;
