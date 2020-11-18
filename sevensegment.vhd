library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sevensegment is
  Port (clk : in std_logic;
        input : in std_logic_vector(15 downto 0);
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0) );
end sevensegment;

architecture Behavioral of sevensegment is
  signal digit2 : Integer;
  signal digit3: Integer;
  signal digit4: Integer;
  signal temp: Integer:=0;
  signal clk2kHz : std_logic_vector(1 downto 0):="00";
  begin

  process(clk)
  begin
  if(rising_edge(clk)) then
        temp<=temp+1;
        if(temp = 25000) then
            if(clk2kHz="11") then
                clk2kHz<="00";
            else
                clk2kHz<=std_logic_vector(to_unsigned(to_integer(unsigned(clk2kHz))+1,2));
            end if;
            temp<=0;
        end if;
  end if;
  end process;
  
 -- Seven segment display

 process(input, clk2kHz)
 begin
 case clk2kHz is
 when "00"=>
 an<="1110";
 case (input(3 downto 0)) is
    when "0000" => seg<="1000000";
    when "0001" => seg<="1111001";
    when "0010" => seg<="0100100";
    when "0011" => seg<="0110000";
    when "0100" => seg<="0011001";
    when "0101" => seg<="0010010";
    when "0110" => seg<="0000010";
    when "0111" => seg<="1111000";
    when "1000" => seg<="0000000";
    when "1001" => seg<="0010000";
    when "1010" => seg<="0001000";
    when "1011" => seg<="0000011";
    when "1100" => seg<="1000110";
    when "1101" => seg<="0100001";
    when "1110" => seg<="0000110";
    when others => seg<="0001110";
 end case;

 when "01"=>
 an<="1101";
 case (input(7 downto 4)) is
    when "0000" => seg<="1000000";
    when "0001" => seg<="1111001";
    when "0010" => seg<="0100100";
    when "0011" => seg<="0110000";
    when "0100" => seg<="0011001";
    when "0101" => seg<="0010010";
    when "0110" => seg<="0000010";
    when "0111" => seg<="1111000";
    when "1000" => seg<="0000000";
    when "1001" => seg<="0010000";
    when "1010" => seg<="0001000";
    when "1011" => seg<="0000011";
    when "1100" => seg<="1000110";
    when "1101" => seg<="0100001";
    when "1110" => seg<="0000110";
    when others => seg<="0001110";
 end case;

    when "10"=>
        an<="1011";
        case (input(11 downto 8)) is
            when "0000" => seg<="1000000";
            when "0001" => seg<="1111001";
            when "0010" => seg<="0100100";
            when "0011" => seg<="0110000";
            when "0100" => seg<="0011001";
            when "0101" => seg<="0010010";
            when "0110" => seg<="0000010";
            when "0111" => seg<="1111000";
            when "1000" => seg<="0000000";
            when "1001" => seg<="0010000";
            when "1010" => seg<="0001000";
            when "1011" => seg<="0000011";
            when "1100" => seg<="1000110";
            when "1101" => seg<="0100001";
            when "1110" => seg<="0000110";
            when others => seg<="0001110";
         end case;

     when "11"=>
        an<="0111";
        case (input(15 downto 12)) is
        when "0000" => seg<="1000000";
        when "0001" => seg<="1111001";
        when "0010" => seg<="0100100";
        when "0011" => seg<="0110000";
        when "0100" => seg<="0011001";
        when "0101" => seg<="0010010";
        when "0110" => seg<="0000010";
        when "0111" => seg<="1111000";
        when "1000" => seg<="0000000";
        when "1001" => seg<="0010000";
        when "1010" => seg<="0001000";
        when "1011" => seg<="0000011";
        when "1100" => seg<="1000110";
        when "1101" => seg<="0100001";
        when "1110" => seg<="0000110";
        when others => seg<="0001110";
     end case;
     when others =>
     end case;
end process;
end Behavioral;