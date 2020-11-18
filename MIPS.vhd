library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS is
port(    clk : in std_logic;
        led : out std_logic_vector(15 downto 0);
        flag : in std_logic;
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0) );
end MIPS;


architecture Behavioral of MIPS is

signal mem_cnt : integer :=0;

--Register File
type reg_type is array(0 to 31) of std_logic_vector(31 downto 0);
signal reg : reg_type := (others => "00000000000000000000000000000000");
 
--States
type stype is (read, buff, exec, initial);
signal state : stype := read;
signal temp1, temp2, temp3 : std_logic :='0';
signal cycle_cnt : integer := 0;
signal index : integer := 0;
signal mem_read_data : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

signal ena : std_logic := '1';
signal wea : STD_LOGIC_VECTOR(0 DOWNTO 0):="0";
signal ram_addr : STD_LOGIC_VECTOR(11 DOWNTO 0);
signal data_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal data_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal led1, led2 : std_logic_vector(15 downto 0);

Component blk_mem_gen_0 IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;

component sevensegment is
  Port (clk : in std_logic;
        input : in std_logic_vector(15 downto 0);
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0) );
end component;

begin
--lw $t1 12
--lw $t2 5--
--add $t3, $t1, $t2
--sub $t4, $t1, $t2
--sll $t5, $t1, 2
--srl $t6, $t2, 1
--sw $t6, loctaion = 1024

    mem: blk_mem_gen_0   port map(clk, ena, wea, ram_addr, data_in, data_out);
    display: sevensegment port map(clk, led1, seg, an);

    process(clk)
    begin

    if clk='1' and clk'event then
        if(flag = '0') then 
            led <= led1;
        else
            led <= led2;
        end if;
        case state is
        when read =>
           cycle_cnt <= cycle_cnt + 1;
           wea <="0";
           ram_addr <=std_logic_vector(to_unsigned(mem_cnt,12));
           state <= initial;

        when initial =>
            cycle_cnt <= cycle_cnt + 1;
              state <= buff;

        when buff =>
            cycle_cnt <= cycle_cnt + 1;
             mem_read_data <= data_out;
             state <= exec;

        when exec =>
            --address <= mem_read_data(15 downto 0);
            --op <= mem_read_data(31 downto 26);
            --func <= mem_read_data(5 downto 0);
            --r1 <= mem_read_data(25 downto 21);
            --r2 <= mem_read_data(20 downto 16);
            --rd <= mem_read_data(15 downto 11);
            --shamt <= mem_read_data(10 downto 6);
            if (mem_read_data = "00000000000000000000000000000000") then

            elsif ( mem_read_data(31 downto 26) = "000000" and mem_read_data(5 downto 0) ="100000") then
                reg(to_integer(unsigned(mem_read_data(15 downto 11)))) <= std_logic_vector(signed(reg(to_integer(unsigned(mem_read_data(25 downto 21))))) + signed(reg(to_integer(unsigned(mem_read_data(20 downto 16))))));
                mem_cnt <= mem_cnt + 1;
                cycle_cnt <= cycle_cnt + 1;
                index <= to_integer(unsigned(mem_read_data(15 downto 11)));
                state<=read;
            elsif ( mem_read_data(31 downto 26) = "000000" and mem_read_data(5 downto 0) = "100010") then
                reg(to_integer(unsigned(mem_read_data(15 downto 11)))) <= std_logic_vector(signed(reg(to_integer(unsigned(mem_read_data(25 downto 21))))) - signed(reg(to_integer(unsigned(mem_read_data(20 downto 16))))));
                mem_cnt <= mem_cnt + 1;
                cycle_cnt <= cycle_cnt + 1;
                index <= to_integer(unsigned(mem_read_data(15 downto 11)));
                state<=read;
            elsif ( mem_read_data(31 downto 26) = "000000" and mem_read_data(5 downto 0) = "000000") then
                reg(to_integer(unsigned(mem_read_data(15 downto 11)))) <= std_logic_vector(shift_left(unsigned(reg(to_integer(unsigned(mem_read_data(20 downto 16))))), (to_integer(unsigned(mem_read_data(10 downto 6))))));
                mem_cnt <= mem_cnt + 1;
                cycle_cnt <= cycle_cnt + 1;
                index <= to_integer(unsigned(mem_read_data(15 downto 11)));
                state<=read;
            elsif ( mem_read_data(31 downto 26) = "000000" and mem_read_data(5 downto 0) = "000010") then
                reg(to_integer(unsigned(mem_read_data(15 downto 11)))) <= std_logic_vector(shift_right(unsigned(reg(to_integer(unsigned(mem_read_data(20 downto 16))))), (to_integer(unsigned(mem_read_data(10 downto 6))))));
                mem_cnt <= mem_cnt + 1;
                cycle_cnt <= cycle_cnt + 1;
                index <= to_integer(unsigned(mem_read_data(15 downto 11)));
                state<=read;
            elsif ( mem_read_data(31 downto 26) = "100011") then 
                if temp1 = '0' and temp2 ='0' then
                    ram_addr <= std_logic_vector(to_unsigned(to_integer(unsigned(reg(to_integer(unsigned(mem_read_data(20 downto 16))))))+to_integer(signed(mem_read_data(15 downto 0))),12));
                    wea<="0";
                    cycle_cnt <= cycle_cnt + 1;
                    temp1 <='1';
                elsif temp1 ='1' and temp2 ='0' then 
                    temp2 <='1';
                    cycle_cnt <= cycle_cnt + 1;
                else
                    reg(to_integer(unsigned(mem_read_data(25 downto 21)))) <= data_out;
                    index <= to_integer(unsigned(mem_read_data(25 downto 21)));
                    mem_cnt <= mem_cnt + 1;
                    cycle_cnt <= cycle_cnt + 1;
                    temp1 <= '0';
                    state <= read;
                    temp2 <= '0';
                end if;
            elsif ( mem_read_data(31 downto 26) = "101011") then  
                if temp3 = '0' and temp2 ='0' then
                    wea <= "1";
                    cycle_cnt <= cycle_cnt + 1;
                    temp3 <= '1';
                    ram_addr <=  std_logic_vector(to_unsigned(to_integer(unsigned(reg(to_integer(unsigned(mem_read_data(20 downto 16))))))+to_integer(signed(mem_read_data(15 downto 0))),12));
                    data_in <= reg(to_integer(unsigned(mem_read_data(25 downto 21))));
                elsif temp3 = '1' and temp2 ='0' then 
                    temp2 <='1';
                    cycle_cnt <= cycle_cnt + 1;
                else
                    wea <= "0";
                    mem_cnt <= mem_cnt + 1;
                    temp3 <= '0';
                    cycle_cnt <= cycle_cnt + 1;
                    state <= read;
                    temp2 <= '0';
                end if;
            elsif( mem_read_data(31 downto 26) = "000100") then   --beq
                if(reg(to_integer(unsigned(mem_read_data(25 downto 21))))) = reg(to_integer(unsigned(mem_read_data(20 downto 16)))) then
                    mem_cnt <= to_integer(unsigned(mem_read_data(15 downto 0)));
                else
                    mem_cnt <= mem_cnt+1;
                end if;
                cycle_cnt <= cycle_cnt + 1;
                reg(31) <= std_logic_vector(to_unsigned(mem_cnt+1, 32));
                state <= read;
            elsif (mem_read_data(31 downto 26) = "000101") then        --bne
                    if((to_integer(signed(reg(to_integer(unsigned(mem_read_data(25 downto 21))))))) /= (to_integer(signed(reg(to_integer(unsigned(mem_read_data(20 downto 16)))))))) then
                        mem_cnt <= to_integer(unsigned(mem_read_data(15 downto 0)));
                    else
                        mem_cnt <= mem_cnt+1;
                    end if;
                    cycle_cnt <= cycle_cnt + 1;
                    reg(31) <= std_logic_vector(to_unsigned(mem_cnt+1, 32));
                    state <= read;
            elsif (mem_read_data(31 downto 26) = "000110") then        --blez
                if((reg(to_integer(unsigned(mem_read_data(25 downto 21)))) <= 0)) then
                    mem_cnt <= to_integer(unsigned(mem_read_data(15 downto 0)));
                else
                    mem_cnt <= mem_cnt+1;
                end if;
                cycle_cnt <= cycle_cnt + 1;
                reg(31) <= std_logic_vector(to_unsigned(mem_cnt+1, 32));
                state <= read;
            elsif (mem_read_data(31 downto 26) = "000111") then         --bgtz
                if(reg(to_integer(unsigned(mem_read_data(25 downto 21)))) > 0) then
                    mem_cnt <= to_integer(unsigned(mem_read_data(15 downto 0)));
                else
                    mem_cnt <= mem_cnt+1;
                end if;
                cycle_cnt <= cycle_cnt + 1;
                reg(31) <= std_logic_vector(to_unsigned(mem_cnt+1, 32));
                state <= read;  
            elsif (mem_read_data(31 downto 26) = "000010") then     --j
                mem_cnt <= to_integer(unsigned(mem_read_data(25 downto 0)));
                cycle_cnt <= cycle_cnt + 1;
                reg(31) <= std_logic_vector(to_unsigned(mem_cnt+1, 32));
                state <= read;
            elsif (mem_read_data(31 downto 26) = "000000" and mem_read_data(5 downto 0) = "001000") then        --jr
                mem_cnt <= to_integer(unsigned(reg(to_integer(unsigned(mem_read_data(25 downto 21))))));
                cycle_cnt <= cycle_cnt + 1;
                state <= read;
            elsif (mem_read_data(31 downto 26) = "000011") then          --jal
                reg(31) <= std_logic_vector(to_unsigned(mem_cnt+1, 32));
                mem_cnt <= to_integer(unsigned(mem_read_data(25 downto 0)));
                cycle_cnt <= cycle_cnt + 1;
                state <= read;
            end if;
        end case;
    end if;
    end process;
    led1 <= std_logic_vector(to_unsigned(cycle_cnt, 16));
    led2 <= reg(index)(15 downto 0);
end Behavioral;