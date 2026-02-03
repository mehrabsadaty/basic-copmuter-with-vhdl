library IEEE;
use IEEE.std_logic_1164.all;

entity data_bus is
    port(
        selector      : in  std_logic_vector(2 downto 0);
        memory        : in  std_logic_vector(15 downto 0);
        DR            : in  std_logic_vector(15 downto 0);
        AC            : in  std_logic_vector(15 downto 0);
        IR            : in  std_logic_vector(15 downto 0);
        TR            : in  std_logic_vector(15 downto 0);
        AR            : in  std_logic_vector(11 downto 0);
        PC            : in  std_logic_vector(11 downto 0);
        register_data : out std_logic_vector(15 downto 0)
    );
end data_bus;

architecture bus_arch of data_bus is
begin
    process (selector, memory, DR, AC, IR, TR, AR, PC)
    begin
        case selector is
            when "000" =>
                register_data <= (others => '0');  -- Ground
            when "001" =>
                register_data <= "0000" & AR;  -- 4 bits zero + 12 bits AR = 16 bits
            when "010" =>
                register_data <= "0000" & PC;  -- 4 bits zero + 12 bits PC = 16 bits
            when "011" => 
                register_data <= DR;
            when "100" =>
                register_data <= AC;
            when "101" =>
                register_data <= IR;
            when "110" =>
                register_data <= TR;
            when "111" =>
                register_data <= memory;
            when others =>
                register_data <= (others => '0');
        end case;
    end process;
 
end bus_arch;