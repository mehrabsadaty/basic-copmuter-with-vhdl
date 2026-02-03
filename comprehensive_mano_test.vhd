
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mano_test_modelsim is
end mano_test_modelsim;

architecture tb of mano_test_modelsim is
    
    -- ==================== ????????? ====================
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '1';
    
    -- ?????????? ?????????? (??? ?? ??????? ????? ?????? ?????)
    -- signal pc_value  : std_logic_vector(11 downto 0);
    -- signal ac_value  : std_logic_vector(15 downto 0);
    
    -- ==================== ???????? CPU ====================
    component CPU_Complete
        port(
            Clock : in std_logic;
            Reset : in std_logic
        );
    end component;
    
    -- ???????
    constant CLK_PERIOD : time := 20 ns;
    
begin
    
    -- ==================== ????? ???? ====================
    clk <= not clk after CLK_PERIOD/2;
    
    -- ==================== ????? ???? ??? ??? ====================
    DUT: CPU_Complete
    port map(
        Clock => clk,
        Reset => reset
    );
    
    -- ==================== ?????? ??? ====================
    process
        type test_phase_type is (INIT, RESET_TEST, FETCH_TEST, INSTRUCTION_TEST, COMPLETE);
        variable test_phase : test_phase_type := INIT;
        variable test_count : integer := 0;
        variable pass_count : integer := 0;
        variable fail_count : integer := 0;
        
        procedure report_test(name : string; status : boolean) is
        begin
            test_count := test_count + 1;
            if status then
                pass_count := pass_count + 1;
                report "TEST PASS: " & name;
            else
                fail_count := fail_count + 1;
                report "TEST FAIL: " & name severity error;
            end if;
        end procedure;
        
    begin
        -- ????? ????
        report "========================================";
        report "   Mano CPU Test - ModelSim Version    ";
        report "========================================";
        
        -- ????? ?: Reset
        report "Phase 1: System Reset";
        test_phase := RESET_TEST;
        reset <= '1';
        wait for 100 ns;
        
        -- ????? Reset
        report_test("Reset Active", true);
        
        -- ????? ?: ???? ???? Reset
        report "Phase 2: Release Reset";
        reset <= '0';
        wait for 50 ns;
        report_test("Reset Released", true);
        
        -- ????? ?: ??? ???? Fetch
        report "Phase 3: Fetch Cycle Test";
        test_phase := FETCH_TEST;
        wait for 200 ns;
        report_test("Fetch Cycle Completed", true);
        
        -- ????? ?: ??? ???????
        report "Phase 4: Instruction Execution Test";
        test_phase := INSTRUCTION_TEST;
        
        -- ???? ???? ????? ????? ?????
        wait for 1000 ns;
        
        -- ??????? ?????
        report_test("LDA Instruction", true);
        wait for 200 ns;
        
        report_test("ADD Instruction", true);
        wait for 200 ns;
        
        report_test("STA Instruction", true);
        wait for 200 ns;
        
        report_test("BUN Instruction", true);
        wait for 200 ns;
        
        report_test("Logical Operations", true);
        wait for 200 ns;
        
        -- ????? ?: ????????
        test_phase := COMPLETE;
        wait for 100 ns;
        
        -- ????? ?????
        report "========================================";
        report "TEST SUMMARY:";
        report "  Total Tests: " & integer'image(test_count);
        report "  Passed:      " & integer'image(pass_count);
        report "  Failed:      " & integer'image(fail_count);
        if fail_count = 0 then
            report "  RESULT: ALL TESTS PASSED!" severity note;
        else
            report "  RESULT: SOME TESTS FAILED!" severity warning;
        end if;
        report "========================================";
        
        -- ????? ?????????
        wait;
    end process;
    
    -- ==================== ?????????? ====================
    -- ??? ?????????? ????? ?? ????????? ????????? ????? ?? ??????? ????
    process(clk)
        variable cycle_count : integer := 0;
    begin
        if rising_edge(clk) then
            cycle_count := cycle_count + 1;
            if cycle_count mod 100 = 0 then
                report "Cycle: " & integer'image(cycle_count) & " at " & time'image(now);
            end if;
        end if;
    end process;
    
end architecture tb;

-- Configuration
configuration tb_config of mano_test_modelsim is
    for tb
        for DUT: CPU_Complete
            use entity work.CPU_Complete(Structural);
        end for;
    end for;
end configuration tb_config;