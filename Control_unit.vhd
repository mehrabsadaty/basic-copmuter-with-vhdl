library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlUnit_Mano is
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        increase : in  STD_LOGIC; 
        clear    : in  STD_LOGIC; 
        
    
        instruction : in  STD_LOGIC_VECTOR(15 downto 0);  
    
        I_bit       : out STD_LOGIC;  
        address_out : out STD_LOGIC_VECTOR(11 downto 0);  
        opcode_decoded : out STD_LOGIC_VECTOR(7 downto 0);  
        T_outputs   : out STD_LOGIC_VECTOR(15 downto 0)  
    );
end ControlUnit_Mano;

architecture Behavioral of ControlUnit_Mano is
    
    
    signal I_signal   : STD_LOGIC;
    signal opcode     : STD_LOGIC_VECTOR(2 downto 0);
    signal address    : STD_LOGIC_VECTOR(11 downto 0);
    signal decoded_op : STD_LOGIC_VECTOR(7 downto 0);
    signal seq_counter: UNSIGNED(3 downto 0) := "0000";
    
begin

    
    I_signal   <= instruction(15);
    opcode     <= instruction(14 downto 12); 
    address    <= instruction(11 downto 0); 
    
    
    I_bit       <= I_signal;
    address_out <= address;
    
    
    process(opcode)
    begin
        case opcode is
            when "000"  => decoded_op <= "00000001";
            when "001"  => decoded_op <= "00000010";
            when "010"  => decoded_op <= "00000100";
            when "011"  => decoded_op <= "00001000";
            when "100"  => decoded_op <= "00010000";
            when "101"  => decoded_op <= "00100000";
            when "110"  => decoded_op <= "01000000";
            when "111"  => decoded_op <= "10000000";
            when others => decoded_op <= "00000000";
        end case;
    end process;
    
    opcode_decoded <= decoded_op;
    

    process(clk, reset)
    begin
        if reset = '1' then
            seq_counter <= "0000";
        elsif rising_edge(clk) then
            if clear = '1' then
                seq_counter <= "0000";
            elsif increase = '1' then
                if seq_counter = 15 then
                    seq_counter <= "0000";
                else
                    seq_counter <= seq_counter + 1;
                end if;
            end if;
        end if;
    end process;
    
    
    process(seq_counter)
    begin
        T_outputs <= (others => '0');
        T_outputs(to_integer(seq_counter)) <= '1';
    end process;

end Behavioral;