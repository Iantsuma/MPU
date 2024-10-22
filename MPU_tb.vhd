library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Numeric_Std.all;

entity MPU_tb is
end entity MPU_tb;

architecture behavior of MPU_tb is
    -- Component declaration of the Unit Under Test (UUT)
    component MPU
        port(
            ce_n, we_n, oe_n: in std_logic;
            intr: out std_logic;
            clk:  in  std_logic;
            address: in std_logic_vector(15 downto 0);
            data: inout std_logic_vector(15 downto 0)
        );
    end component;

    -- Signals to connect to the UUT
    signal ce_n, we_n, oe_n: std_logic := '1';
    signal intr: std_logic;
    signal clk: std_logic;
    signal address: std_logic_vector(15 downto 0) := (others => '0');
    signal data: std_logic_vector(15 downto 0);

    -- Matrices A, B and C as signals
    signal A : std_logic_vector(255 downto 0);
    signal B : std_logic_vector(255 downto 0);
    signal C : std_logic_vector(255 downto 0);

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: MPU
        port map (
            ce_n => ce_n,
            we_n => we_n,
            oe_n => oe_n,  --Output enable, ligado quando usando o data como saída, else Z
            intr => intr,
            clk  => clk,
            address => address,
            data => data
        );

    -- Test process
    clk_process: process
    begin
        clk <= not(clk);
        wait for 1 ns;
    end process;

    stimulus_process: process
    begin
        -- Initialize signals
        ce_n <= '0';
        we_n <= '0';
        oe_n <= '0';
        
        -- Test 1: Matriz A e B com valores conhecidos
        -- Definir valores para A e B (exemplo simples, você pode modificar)
        wait for 2 ns;
        A(239 downto 224) <= "0000000000000001";
        A(255 downto 240) <= "0000000000000001";
        A(223 downto 208) <= "0000000000000001";
        A(207 downto 192) <= "0000000000000001";
        A(191 downto 176) <= "0000000000000001";
        A(175 downto 160) <= "0000000000000001";
        A(159 downto 144) <= "0000000000000001";
        A(143 downto 128) <= "0000000000000001";
        A(127 downto 112) <= "0000000000000001";
        A(111 downto 96)  <= "0000000000000001";
        A(95  downto 80)  <= "0000000000000001";
        A(79  downto 64)  <= "0000000000000001";
        A(63  downto 48)  <= "0000000000000001";
        A(47  downto 32)  <= "0000000000000001";
        A(31  downto 16)  <= "0000000000000001";
        A(15  downto 0)   <= "0000000000000001";
        wait for 2 ns;

        B(255 downto 240) <= "0000000000000001";
        B(239 downto 224) <= "0000000000000001";
        B(223 downto 208) <= "0000000000000001";
        B(207 downto 192) <= "0000000000000001";
        B(191 downto 176) <= "0000000000000001";
        B(175 downto 160) <= "0000000000000001";
        B(159 downto 144) <= "0000000000000001";
        B(143 downto 128) <= "0000000000000001";
        B(127 downto 112) <= "0000000000000001";
        B(111 downto 96)  <= "0000000000000001";
        B(95  downto 80)  <= "0000000000000001";
        B(79  downto 64)  <= "0000000000000001";
        B(63  downto 48)  <= "0000000000000001";
        B(47  downto 32)  <= "0000000000000001";
        B(31  downto 16)  <= "0000000000000001";
        B(15  downto 0)   <= "0000000000000001";
        wait for 2 ns;

        -- Inicializar o sinal data
        data(15 downto 0) <= "0000000000000000";
        wait for 10 ns;

        data(15 downto 0) <= "0000000000000001";
        wait for 10 ns;

        data(15 downto 0) <= "0000000000000010";
        wait for 10 ns;

        -- Finalizar a simulação após um tempo
        wait;
    end process;
end architecture behavior;
