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
        
        -- Accumulator (??? ??????? AC_register ?????)
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
        T0, T1, T2, T3, T4, T5, T6, T7, 
        T8, T9, T10, T11, T12, T13, T14, T15
    );
    signal current_state, next_state : state_type;
    
    -- ?????????? ????? ?????
    signal control_signals : STD_LOGIC_VECTOR(31 downto 0);
    
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
    
    -- ==================== State Machine ====================
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= T0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    
    -- ==================== State Transition ====================
    process(current_state, decoded_op)
    begin
        case current_state is
            when T0 => next_state <= T1;
            when T1 => next_state <= T2;
            when T2 => next_state <= T3;
            when T3 => 
                case decoded_op is
                    when "00000001" => next_state <= T4;  -- AND
                    when "00000010" => next_state <= T4;  -- ADD
                    when "00000100" => next_state <= T4;  -- LDA
                    when "00001000" => next_state <= T4;  -- STA
                    when "00010000" => next_state <= T4;  -- BUN
                    when "00100000" => next_state <= T4;  -- BSA
                    when "01000000" => next_state <= T4;  -- ISZ
                    when "10000000" => next_state <= T4;  -- IO/CLA
                    when others => next_state <= T0;
                end case;
            when others => next_state <= T0;
        end case;
    end process;
    
    -- ==================== ????? ????????? ???? ?? ???? ====================
    process(current_state, decoded_op, I_signal)
    begin
        -- ???????: ??? ????????? ???????
        DR_load <= '0'; DR_inr <= '0'; DR_clr <= '0';
        AC_load <= '0'; AC_inr <= '0'; AC_clr <= '0';
        IR_load <= '0'; IR_inr <= '0'; IR_clr <= '0';
        TR_load <= '0'; TR_inr <= '0'; TR_clr <= '0';
        AR_load <= '0'; AR_inr <= '0'; AR_clr <= '0';
        PC_load <= '0'; PC_inr <= '0'; PC_clr <= '0';
        bus_selector <= "000";
        mem_read <= '0'; mem_write <= '0';
        alu_op <= "0000";
        
        -- ????? T
        case current_state is
            when T0 => 
                T_state <= "0000";
                -- PC ? AR
                bus_selector <= "010";  -- PC
                AR_load <= '1';
                
            when T1 => 
                T_state <= "0001";
                -- M ? IR, PC + 1
                mem_read <= '1';
                bus_selector <= "111";  -- Memory
                IR_load <= '1';
                PC_inr <= '1';  -- ?????? PC
                
            when T2 => 
                T_state <= "0010";
                -- Decode
                -- ??? ???????? ??? decode
                
            when T3 => 
                T_state <= "0011";
                -- AR ? IR(0-11)
                bus_selector <= "101";  -- IR
                AR_load <= '1';
                
            when T4 => 
                T_state <= "0100";
                -- ????? ????? (?? ???? opcode)
                case decoded_op is
                    when "00000001" =>  -- AND
                        mem_read <= '1';
                        bus_selector <= "111";  -- Memory
                        DR_load <= '1';
                        
                    when "00000010" =>  -- ADD
                        mem_read <= '1';
                        bus_selector <= "111";  -- Memory
                        DR_load <= '1';
                        
                    when "00000100" =>  -- LDA
                        mem_read <= '1';
                        bus_selector <= "111";  -- Memory
                        DR_load <= '1';
                        
                    when "00001000" =>  -- STA
                        bus_selector <= "100";  -- AC
                        mem_write <= '1';
                        
                    when "00010000" =>  -- BUN
                        bus_selector <= "001";  -- AR
                        PC_load <= '1';
                        
                    when "00100000" =>  -- BSA
                        bus_selector <= "010";  -- PC
                        mem_write <= '1';
                        AR_inr <= '1';
                        
                    when "01000000" =>  -- ISZ
                        mem_read <= '1';
                        bus_selector <= "111";  -- Memory
                        DR_load <= '1';
                        
                    when "10000000" =>  -- IO/CLA
                        -- ???? ??????? IO ?? Clear AC
                        if address(11) = '0' then  -- CLA
                            AC_clr <= '1';
                        else  -- IO operations
                            -- ????????? ????? ????
                        end if;
                        
                    when others => null;
                end case;
                
            when T5 => 
                T_state <= "0101";
                -- ????? ????? ?????
                case decoded_op is
                    when "00000001" =>  -- AND
                        alu_op <= "0010";  -- AND operation
                        AC_load <= '1';
                        
                    when "00000010" =>  -- ADD
                        alu_op <= "0000";  -- ADD operation
                        AC_load <= '1';
                        
                    when "00000100" =>  -- LDA
                        bus_selector <= "011";  -- DR
                        AC_load <= '1';
                        
                    when "00001000" =>  -- STA
                        -- ???? ???
                        
                    when "00100000" =>  -- BSA
                        bus_selector <= "001";  -- AR
                        PC_load <= '1';
                        
                    when "01000000" =>  -- ISZ
                        DR_inr <= '1';
                        
                    when others => null;
                end case;
                
            when T6 => 
                T_state <= "0110";
                -- ????? ????? ?????
                case decoded_op is
                    when "01000000" =>  -- ISZ
                        bus_selector <= "011";  -- DR
                        mem_write <= '1';
                        
                    when others => null;
                end case;
                
            when others => 
                T_state <= "1111";
                -- ?????? ?? T0
        end case;
    end process;
    
end Behavioral;