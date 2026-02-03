library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlUnit_Mano is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        
        -- ????? ?? IR
        instruction : in  STD_LOGIC_VECTOR(15 downto 0);  
        
        -- ==================== ????????? ????? ???? ??????? ====================
        -- Data Register
        DR_load     : out STD_LOGIC;
        DR_inr      : out STD_LOGIC;
        DR_clr      : out STD_LOGIC;
        
        -- Accumulator
        AC_load     : out STD_LOGIC;
        AC_inr      : out STD_LOGIC;
        AC_clr      : out STD_LOGIC;
        
        -- Instruction Register
        IR_load     : out STD_LOGIC;
        IR_inr      : out STD_LOGIC;
        IR_clr      : out STD_LOGIC;
        
        -- Temporary Register
        TR_load     : out STD_LOGIC;
        TR_inr      : out STD_LOGIC;
        TR_clr      : out STD_LOGIC;
        
        -- Address Register
        AR_load     : out STD_LOGIC;
        AR_inr      : out STD_LOGIC;
        AR_clr      : out STD_LOGIC;
        
        -- Program Counter
        PC_load     : out STD_LOGIC;
        PC_inr      : out STD_LOGIC;
        PC_clr      : out STD_LOGIC;
        
        -- ==================== ????? Bus ====================
        bus_selector : out STD_LOGIC_VECTOR(2 downto 0);
        
        -- ==================== ????? Memory ====================
        mem_read    : out STD_LOGIC;
        mem_write   : out STD_LOGIC;
        
        -- ==================== ????? ALU ====================
        alu_op      : out STD_LOGIC_VECTOR(3 downto 0);
        
        -- ==================== ????? ====================
        T_state     : out STD_LOGIC_VECTOR(3 downto 0);
        I_bit       : out STD_LOGIC;
        opcode_decoded : out STD_LOGIC_VECTOR(7 downto 0)
    );
end ControlUnit_Mano;

architecture Behavioral of ControlUnit_Mano is
    
    signal I_signal   : STD_LOGIC;
    signal opcode     : STD_LOGIC_VECTOR(2 downto 0);
    signal address    : STD_LOGIC_VECTOR(11 downto 0);
    signal decoded_op : STD_LOGIC_VECTOR(7 downto 0);
    
    type state_type is (
        T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10,
        T11, T12, T13, T14, T15
    );
    signal current_state, next_state : state_type;
    
    -- سیگنال‌های داخلی
    signal DR_reg : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    
begin

    -- ??????? ??????????
    I_signal   <= instruction(15);
    opcode     <= instruction(14 downto 12); 
    address    <= instruction(11 downto 0); 
    
    I_bit       <= I_signal;
    
    -- ?????? Opcode
    process(opcode)
    begin
        case opcode is
            when "000"  => decoded_op <= "00000001";  -- AND
            when "001"  => decoded_op <= "00000010";  -- ADD
            when "010"  => decoded_op <= "00000100";  -- LDA
            when "011"  => decoded_op <= "00001000";  -- STA
            when "100"  => decoded_op <= "00010000";  -- BUN
            when "101"  => decoded_op <= "00100000";  -- BSA
            when "110"  => decoded_op <= "01000000";  -- ISZ
            when "111"  => decoded_op <= "10000000";  -- INP/OUT/CLA/etc
            when others => decoded_op <= "00000000";
        end case;
    end process;
    
    opcode_decoded <= decoded_op;
    
    -- ==================== State Machine (Sequential) ====================
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= T0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    
    -- ==================== State Transition Logic (Combinational) ====================
    process(current_state, decoded_op, I_signal, address)
    begin
        case current_state is
            when T0 => 
                -- Fetch: PC -> MAR
                next_state <= T1;
                
            when T1 => 
                -- Fetch: M[MAR] -> MBR, PC+1
                next_state <= T2;
                
            when T2 => 
                -- Fetch: MBR -> IR
                next_state <= T3;
                
            when T3 => 
                -- Decode & AR <- IR(0-11)
                next_state <= T4;
                
            when T4 => 
                -- Memory Read/Write based on opcode
                case decoded_op is
                    when "00000001" | "00000010" | "00000100" | "01000000" => 
                        -- AND, ADD, LDA, ISZ: نیاز به خواندن از حافظه
                        next_state <= T5;
                        
                    when "00001000" =>  -- STA
                        next_state <= T6;
                        
                    when "00010000" =>  -- BUN
                        next_state <= T9;
                        
                    when "00100000" =>  -- BSA
                        next_state <= T7;
                        
                    when "10000000" =>  -- IO/CLA
                        if address(11) = '0' then  -- CLA
                            next_state <= T9;
                        else  -- INP/OUT/SKP
                            next_state <= T8;
                        end if;
                        
                    when others =>
                        next_state <= T0;
                end case;
                
            when T5 => 
                -- Memory Read Complete
                case decoded_op is
                    when "00000001" | "00000010" =>  -- AND, ADD
                        next_state <= T10;
                        
                    when "00000100" =>  -- LDA
                        next_state <= T11;
                        
                    when "01000000" =>  -- ISZ
                        next_state <= T12;
                        
                    when others =>
                        next_state <= T0;
                end case;
                
            when T6 => 
                -- STA: Write to memory
                next_state <= T9;
                
            when T7 => 
                -- BSA: Save return address
                next_state <= T13;
                
            when T8 => 
                -- I/O Operations
                next_state <= T9;
                
            when T9 => 
                -- Return to fetch
                next_state <= T0;
                
            when T10 => 
                -- AND/ADD: ALU operation
                next_state <= T9;
                
            when T11 => 
                -- LDA: Load to AC
                next_state <= T9;
                
            when T12 => 
                -- ISZ: Check if zero
                next_state <= T14;
                
            when T13 => 
                -- BSA: Jump to subroutine
                next_state <= T9;
                
            when T14 => 
                -- ISZ: Skip if zero
                next_state <= T9;
                
            when T15 => 
                -- Unused state
                next_state <= T0;
                
        end case;
    end process;
    
    -- ==================== Control Signals Generation ====================
    process(current_state, decoded_op, I_signal, address)
    begin
        -- Default values
        DR_load <= '0'; DR_inr <= '0'; DR_clr <= '0';
        AC_load <= '0'; AC_inr <= '0'; AC_clr <= '0';
        IR_load <= '0'; IR_inr <= '0'; IR_clr <= '0';
        TR_load <= '0'; TR_inr <= '0'; TR_clr <= '0';
        AR_load <= '0'; AR_inr <= '0'; AR_clr <= '0';
        PC_load <= '0'; PC_inr <= '0'; PC_clr <= '0';
        bus_selector <= "000";  -- Ground
        mem_read <= '0'; mem_write <= '0';
        alu_op <= "0000";  -- No operation
        
        case current_state is
            -- ========== FETCH CYCLE ==========
            when T0 => 
                T_state <= "0000";
                -- PC -> MAR
                bus_selector <= "010";  -- Select PC
                AR_load <= '1';         -- Load to AR (MAR)
                
            when T1 => 
                T_state <= "0001";
                -- Read memory at MAR, PC+1
                mem_read <= '1';
                bus_selector <= "111";  -- Select memory output
                PC_inr <= '1';          -- Increment PC
                
            when T2 => 
                T_state <= "0010";
                -- MBR -> IR
                IR_load <= '1';
                
            when T3 => 
                T_state <= "0011";
                -- AR <- IR(0-11)
                bus_selector <= "101";  -- Select IR
                AR_load <= '1';
                
            -- ========== EXECUTE CYCLE ==========
            when T4 => 
                T_state <= "0100";
                -- Memory operation based on opcode
                case decoded_op is
                    when "00000001" | "00000010" | "00000100" | "01000000" => 
                        -- AND, ADD, LDA, ISZ: Read from memory
                        mem_read <= '1';
                        bus_selector <= "111";  -- Memory
                        DR_load <= '1';        -- Load to DR
                        
                    when "00001000" =>  -- STA
                        -- AC -> Memory
                        bus_selector <= "100";  -- Select AC
                        mem_write <= '1';
                        
                    when "00010000" =>  -- BUN
                        -- AR -> PC
                        bus_selector <= "001";  -- Select AR
                        PC_load <= '1';
                        
                    when "00100000" =>  -- BSA
                        -- PC -> Memory, AR+1
                        bus_selector <= "010";  -- Select PC
                        mem_write <= '1';
                        AR_inr <= '1';
                        
                    when "10000000" =>  -- IO/CLA
                        if address(11) = '0' then  -- CLA
                            AC_clr <= '1';
                        else
                            -- I/O operations
                            case address(10 downto 9) is
                                when "00" =>  -- INP
                                    alu_op <= "1011";  -- INP operation
                                    AC_load <= '1';
                                when "01" =>  -- OUT
                                    -- Output from AC (would connect to output port)
                                    null;
                                when "10" =>  -- SKI
                                    -- Skip if input flag
                                    null;
                                when "11" =>  -- SKO
                                    -- Skip if output flag
                                    null;
                                when others => null;
                            end case;
                        end if;
                        
                    when others => null;
                end case;
                
            when T5 => 
                T_state <= "0101";
                -- Memory read completed, DR has data
                null;  -- Data already in DR from T4
                
            when T6 => 
                T_state <= "0110";
                -- STA completed
                null;
                
            when T7 => 
                T_state <= "0111";
                -- BSA: AR -> PC (jump to subroutine)
                bus_selector <= "001";  -- Select AR
                PC_load <= '1';
                
            when T8 => 
                T_state <= "1000";
                -- I/O operations completed
                null;
                
            when T9 => 
                T_state <= "1001";
                -- Return to fetch
                null;
                
            when T10 => 
                T_state <= "1010";
                -- AND/ADD: ALU operation
                case decoded_op is
                    when "00000001" =>  -- AND
                        alu_op <= "0010";  -- AND operation
                        AC_load <= '1';
                        
                    when "00000010" =>  -- ADD
                        alu_op <= "0000";  -- ADD operation
                        AC_load <= '1';
                        
                    when others => null;
                end case;
                
            when T11 => 
                T_state <= "1011";
                -- LDA: DR -> AC
                if decoded_op = "00000100" then  -- LDA
                    bus_selector <= "011";  -- Select DR
                    AC_load <= '1';
                end if;
                
            when T12 => 
                T_state <= "1100";
                -- ISZ: DR+1
                if decoded_op = "01000000" then  -- ISZ
                    DR_inr <= '1';
                end if;
                
            when T13 => 
                T_state <= "1101";
                -- BSA: AR contains return address+1
                null;
                
            when T14 => 
                T_state <= "1110";
                -- ISZ: Check if zero and skip
                if decoded_op = "01000000" then  -- ISZ
                    -- Write back incremented value
                    bus_selector <= "011";  -- Select DR
                    mem_write <= '1';
                    
                    -- Check if zero (skip next instruction)
                    -- This would require checking DR value
                    -- For now, we'll implement simple version
                    if DR_reg = "0000000000000000" then
                        PC_inr <= '1';  -- Skip next instruction
                    end if;
                end if;
                
            when T15 => 
                T_state <= "1111";
                -- Idle state
                null;
                
        end case;
    end process;
    
    -- Process to track DR value for ISZ
    process(clk)
    begin
        if rising_edge(clk) then
            if current_state = T4 and 
               (decoded_op = "01000000" or decoded_op = "00000001" or 
                decoded_op = "00000010" or decoded_op = "00000100") then
                -- DR gets loaded from memory
                -- In real implementation, this would come from DR register
            end if;
        end if;
    end process;
    
end Behavioral;