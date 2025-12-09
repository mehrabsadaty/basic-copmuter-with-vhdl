
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;  -- ??? ?? ?? ????? ????

entity test_memory_dr is
end test_memory_dr;

architecture tb of test_memory_dr is
    
    signal clk : std_logic := '0';
    
    -- ?????????? ?????
    signal mem_write : std_logic := '0';
    signal mem_read : std_logic := '0';
    signal mem_address : unsigned(11 downto 0) := (others => '0');
    signal mem_data_in : std_logic_vector(15 downto 0) := (others => '0');
    signal mem_data_out : std_logic_vector(15 downto 0);
    
    -- ?????????? DR
    signal dr_clear : std_logic := '0';
    signal dr_increment : std_logic := '0';
    signal dr_load : std_logic := '0';
    signal dr_bus_in : std_logic_vector(15 downto 0);
    signal dr_bus_out : std_logic_vector(15 downto 0);
    signal dr_alu_out : std_logic_vector(15 downto 0);
    
begin
    
    clk <= not clk after 10 ns;
    
    MEMORY_UNIT: entity work.memory
    port map(
        clk => clk,
        write_enable => mem_write,
        read_enable => mem_read,
        address => mem_address,
        bus_input => mem_data_in,
        bus_output => mem_data_out
    );
    
    DATA_REG: entity work.Data_register
    port map(
        Clock => clk,
        CLR => dr_clear,
        INR => dr_increment,
        LD => dr_load,
        Bus_input => dr_bus_in,
        Bus_output => dr_bus_out,
        alu_output => dr_alu_out
    );
    
    -- ????? Bus
    dr_bus_in <= mem_data_out when mem_read = '1' else (others => '0');
    
    process
        variable expected_value : integer;
        variable actual_value : integer;
    begin
        
        report "?????? ?????? ????? ?? ???? ????";
        wait for 20 ns;
        
        -- ?. ??? ???? DR
        dr_clear <= '1';
        wait for 20 ns;
        dr_clear <= '0';
        wait for 20 ns;
        
        report "???? ???? ??? ??";
        
        -- ?. ????? ?? ?????
        mem_address <= "000000000000";
        mem_data_in <= "0000010000010100";  -- 0x0414 = 1044 ?????
        mem_write <= '1';
        wait for 20 ns;
        mem_write <= '0';
        wait for 20 ns;
        
        expected_value := 1044;
        report "????? " & integer'image(expected_value) & " ?? ???? 0 ????? ????? ??";
        
        -- ?. ?????? ?? ?????
        mem_read <= '1';
        wait for 20 ns;
        
        -- ?. ???????? ?? DR
        dr_load <= '1';
        wait for 20 ns;
        dr_load <= '0';
        mem_read <= '0';
        wait for 20 ns;
        
        -- ?. ????? ?????
        actual_value := to_integer(unsigned(dr_bus_out));
        report "????? DR: " & integer'image(actual_value);
        
        if actual_value = expected_value then
            report "????: ?????? ????? ?? DR ???? ???";
        else
            report "??????: DR = " & integer'image(actual_value) & 
                   " ??????: " & integer'image(expected_value);
        end if;
        
        -- ?. ?????? ??????
        dr_increment <= '1';
        wait for 20 ns;
        dr_increment <= '0';
        wait for 20 ns;
        
        actual_value := to_integer(unsigned(dr_bus_out));
        report "DR ??? ?? ??????: " & integer'image(actual_value);
        
        if actual_value = expected_value + 1 then
            report "?????? DR ???? ???";
        else
            report "?????? DR ???? ????";
        end if;
        
        -- ?. ?????? ??? ????
        dr_clear <= '1';
        wait for 20 ns;
        dr_clear <= '0';
        wait for 20 ns;
        
        actual_value := to_integer(unsigned(dr_bus_out));
        report "DR ??? ?? ??? ????: " & integer'image(actual_value);
        
        if actual_value = 0 then
            report "??? ???? DR ???? ???";
        else
            report "??? ???? DR ???? ????";
        end if;
        
        report "????? ??????";
        wait;
        
    end process;
    
end tb;