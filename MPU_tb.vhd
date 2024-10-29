library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Numeric_Std.all;

entity MPU_tb is
end entity MPU_tb;

architecture behavior of MPU_tb is
    -- Component declaration of the Unit Under Test (UUT)
    component MPU
        port(
            ce_n: in std_logic;
            we_n: in std_logic;
            oe_n: in std_logic;
            intr: out std_logic;
            clk:  in  std_logic;
            rst:  in  std_logic;
            address: in std_logic_vector(15 downto 0);
            data: inout std_logic_vector(15 downto 0)
        );
    end component;

    -- Signals to connect to the UUT
    signal ce_n: std_logic := '1';
    signal we_n: std_logic := '1';
    signal oe_n: std_logic := '1';
    signal intr: std_logic;
    signal clk: std_logic := '0';
    signal rst: std_logic := '0';
    signal address: std_logic_vector(15 downto 0);
    signal data: std_logic_vector(15 downto 0);

    -- Matrices A, B and C as signals
    signal A : std_logic_vector(255 downto 0);
    signal B : std_logic_vector(255 downto 0);
    signal C : std_logic_vector(255 downto 0);

    constant clk_period : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: MPU
        port map (
            ce_n => ce_n,
            we_n => we_n,
            oe_n => oe_n,
            intr => intr,
            clk  => clk,
            rst  => rst,
            address => address,
            data => data
        );
    -- Test process
    clk_process : process
    begin
        clk <= not(clk);
        wait for clk_period/10;
    end process;


    stimulus: process
        begin
            rst <= '1';
            wait for clk_period;
            rst <= '0';
 


            we_n <='0';
            ce_n <='1';
            oe_n <='1';
            address <= "1111111111111111";
            data <="0000000000000100";
            wait for clk_period;
            --BLOQUINHO DE ESCRITA-----------------------------------------------------
            we_n <='0';
            ce_n <='1';
            oe_n <='1';
            address <= "1111111111111110";
            data <="0000000000000000";
            wait for clk_period;
            we_n <='1';
            data <="0000000000000001";
            wait for clk_period;
            ---------------------------------------------------------------------------
            ce_n <='0';
            wait for clk_period;

            rst <= '1';
            wait for clk_period;

            we_n <='0';
            ce_n <='1';
            oe_n <='1';

            address <= "1111111111111110";

            data <="0000000000000001";
            wait for clk_period;

            ce_n <='0';
            wait for clk_period;

            rst <= '1';
            wait for clk_period;

            ce_n <='1';
            wait for clk_period;

            we_n <='0';
            ce_n <='1';
            oe_n <='1';
            address <= "1111111111111111";
            data <="0000000000000000";
            wait for clk_period;

            ce_n <='0';
            wait for clk_period;

            rst <= '1';
            wait for clk_period;

            ce_n <='1';
            wait for clk_period;

            we_n <='0';
            ce_n <='1';
            oe_n <='1';
            address <= "1111111111111111";
            data <="0000000000000010";
            wait for clk_period;
            ce_n <='0';
            wait for clk_period;

            rst <= '1';
            wait for clk_period;

            ce_n <='1';
            wait for clk_period;

            we_n <='0';
            ce_n <='1';
            oe_n <='1';
            address <= "1111111111111111";
            data <="0000000000000011";
            wait for clk_period;
            we_n<='1';
            wait for clk_period;
            ce_n <='0';
            wait for clk_period;

            ce_n <='1';
            rst <= '1';
            wait for clk_period;








            assert false
            report "End of Simulation: Test completed."
            severity failure;


            
            wait for clk_period;
    end process;
end architecture behavior;
