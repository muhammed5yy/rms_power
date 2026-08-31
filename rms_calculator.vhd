----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.08.2026 14:07:14
-- Design Name: 
-- Module Name: rms_calculator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rms_calculator is
  Port (
         sample         : in std_logic_vector(11 downto 0);
         clk, reset     : in std_logic;
         sample_valid   : in std_logic;
         power          : out std_logic_vector(31 downto 0)
   );
end rms_calculator;

architecture Behavioral of rms_calculator is

signal accumulator: std_logic_vector(31 downto 0) := (others => '0');
signal sample_s   : std_logic_vector(31 downto 0) := (others => '0');
signal counter    : std_logic_vector(7 downto 0)  := (others => '0');  
begin
sample_s <= std_logic_vector(resize(signed(sample) * signed(sample), 32));

RMS_CALCULATION: process(clk) begin

    if rising_edge(clk) then
      if reset = '1' then
        accumulator <= (others => '0');
--        sample_s    <= (others => '0');
        counter     <= (others => '0');
      else      
        if sample_valid = '1' then
--            sample_s <= std_logic_vector(resize(signed(sample) * signed(sample), 32));
            accumulator <= std_logic_vector(signed(accumulator) + signed(sample_s));
           if counter = "11111111" then
               counter  <= "00000000";
               power <= std_logic_vector(unsigned(accumulator) + resize(unsigned(sample_s), 32)); 
               accumulator <= (others => '0');
--           elsif counter = "00000001" then
--               accumulator <=  std_logic_vector(signed(accumulator) + signed(sample_s));
--               counter <= std_logic_vector(unsigned(counter) + "00000001");   
           else
               counter <= std_logic_vector(unsigned(counter) + "00000001");           
           end if;
           end if;
       end if;
    end if;
end process;
end Behavioral;
 
