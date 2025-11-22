library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
    port(
        clk              : in  std_logic;
        write_enable     : in  std_logic;
        read_enable      : in  std_logic;
        address          : in  unsigned(11 downto 0);
        bus_input        : in  std_logic_vector(15 downto 0);
        bus_output       : out std_logic_vector(15 downto 0)
    );
end memory;

architecture rtl of memory is

    type memory_array is array (0 to 4095) of std_logic_vector(15 downto 0);
    signal RAM : memory_array := (others => (others => '0'));

begin

   
    process(clk)
    begin
        if rising_edge(clk) then
            if write_enable = '1' then
                RAM(to_integer(address)) <= bus_input;
            end if;
        end if;
    end process;

    --
    bus_output <= RAM(to_integer(address)) when read_enable = '1'
                  else (others => 'Z');

end rtl;
