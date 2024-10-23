library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Std_Logic_Signed.all;
use IEEE.Std_Logic_Unsigned.all;
use IEEE.Numeric_Std.all;  -- Adicione esta biblioteca para manipular operações aritméticas
use work.R8.all;

entity MPU is
    port(
        ce_n, we_n, oe_n: in std_logic;
        intr: out std_logic;
        clk:    in std_logic;
        rst:    in std_logic;
        address: in std_logic_vector(15 downto 0);
        data: inout std_logic_vector(15 downto 0)
    );
end entity MPU;

architecture reg of MPU is
    signal A 	: std_logic_vector(255 downto 0);
    signal B 	: std_logic_vector(255 downto 0);
    signal C 	: std_logic_vector(255 downto 0);
    signal com  : std_logic_vector(255 downto 0);
	 signal regA : std_logic_vector(15 downto 0);
	 signal regB : std_logic_vector(15 downto 0);
	 signal regC : std_logic_vector(31 downto 0);
    signal temp_sum : std_logic_vector(31 downto 0);
     

begin
    data <= (others => 'Z');
    -- LINHA ABAIXO FEITa APENAS PARA TESTE
        com(15 downto 0) <= "0000000000000000";
    --LINHAS ACIMA FEITAS APENAS PARA TESTE SEM O r8
	    -- Processamento da ULA baseado no opcode
    process(A, B, com, clk, rst, data)
    begin
        case com(15 downto 0) is  --Se com na posição address for igual a:
            when "0000000000000000"=>                              --fill A com data
                A(255 downto 240) <= data;
                A(239 downto 224) <= data;
                A(223 downto 208) <= data;
                A(207 downto 192) <= data;
                A(191 downto 176) <= data;
                A(175 downto 160) <= data;
                A(159 downto 144) <= data;
                A(143 downto 128) <= data;
                A(127 downto 112) <= data;
                A(111 downto 96)  <= data;
                A(95  downto 80)  <= data;
                A(79  downto 64)  <= data;
                A(63  downto 48)  <= data;
                A(47  downto 32)  <= data;
                A(31  downto 16)  <= data;
                A(15  downto 0)   <= data;
            when "0000000000000001"=>                              --fill B com data
                B(255 downto 240) <= data;
                B(239 downto 224) <= data;
                B(223 downto 208) <= data;
                B(207 downto 192) <= data;
                B(191 downto 176) <= data;
                B(175 downto 160) <= data;
                B(159 downto 144) <= data;
                B(143 downto 128) <= data;
                B(127 downto 112) <= data;
                B(111 downto 96)  <= data;
                B(95  downto 80)  <= data;
                B(79  downto 64)  <= data;
                B(63  downto 48)  <= data;
                B(47  downto 32)  <= data;
                B(31  downto 16)  <= data;
                B(15  downto 0)   <= data;
            when "0000000000000010"=>                              --fill C com data
                C(255 downto 240) <= data;
                C(239 downto 224) <= data;
                C(223 downto 208) <= data;
                C(207 downto 192) <= data;
                C(191 downto 176) <= data;
                C(175 downto 160) <= data;
                C(159 downto 144) <= data;
                C(143 downto 128) <= data;
                C(127 downto 112) <= data;
                C(111 downto 96)  <= data;
                C(95  downto 80)  <= data;
                C(79  downto 64)  <= data;
                C(63  downto 48)  <= data;
                C(47  downto 32)  <= data;
                C(31  downto 16)  <= data;
                C(15  downto 0)   <= data;
            when "0000000000000011"=>
                C(255 downto 240) <= std_logic_vector(unsigned(A(255 downto 240)) + unsigned(B(255 downto 240)));
                C(239 downto 224) <= std_logic_vector(unsigned(A(239 downto 224)) + unsigned(B(239 downto 224)));
                C(223 downto 208) <= std_logic_vector(unsigned(A(223 downto 208)) + unsigned(B(223 downto 208)));
                C(207 downto 192) <= std_logic_vector(unsigned(A(207 downto 192)) + unsigned(B(207 downto 192)));
                C(191 downto 176) <= std_logic_vector(unsigned(A(191 downto 176)) + unsigned(B(191 downto 176)));
                C(175 downto 160) <= std_logic_vector(unsigned(A(175 downto 160)) + unsigned(B(175 downto 160)));
                C(159 downto 144) <= std_logic_vector(unsigned(A(159 downto 144)) + unsigned(B(159 downto 144)));
                C(143 downto 128) <= std_logic_vector(unsigned(A(143 downto 128)) + unsigned(B(143 downto 128)));
                C(127 downto 112) <= std_logic_vector(unsigned(A(127 downto 112)) + unsigned(B(127 downto 112)));
                C(111 downto 96)  <= std_logic_vector(unsigned(A(111 downto 96)) + unsigned(B(111 downto 96)));
                C(95  downto 80)  <= std_logic_vector(unsigned(A(95  downto 80)) + unsigned(B(95  downto 80)));
                C(79  downto 64)  <= std_logic_vector(unsigned(A(79  downto 64)) + unsigned(B(79  downto 64)));
                C(63  downto 48)  <= std_logic_vector(unsigned(A(63  downto 48)) + unsigned(B(63  downto 48)));
                C(47  downto 32)  <= std_logic_vector(unsigned(A(47  downto 32)) + unsigned(B(47  downto 32)));
                C(31  downto 16)  <= std_logic_vector(unsigned(A(31  downto 16)) + unsigned(B(31  downto 16)));
                C(15  downto 0)   <= std_logic_vector(unsigned(A(15  downto 0)) + unsigned(B(15  downto 0)));
            when "0000000000000100"=>
                C(255 downto 240) <= std_logic_vector(unsigned(A(255 downto 240)) - unsigned(B(255 downto 240)));
                C(239 downto 224) <= std_logic_vector(unsigned(A(239 downto 224)) - unsigned(B(239 downto 224)));
                C(223 downto 208) <= std_logic_vector(unsigned(A(223 downto 208)) - unsigned(B(223 downto 208)));
                C(207 downto 192) <= std_logic_vector(unsigned(A(207 downto 192)) - unsigned(B(207 downto 192)));
                C(191 downto 176) <= std_logic_vector(unsigned(A(191 downto 176)) - unsigned(B(191 downto 176)));
                C(175 downto 160) <= std_logic_vector(unsigned(A(175 downto 160)) - unsigned(B(175 downto 160)));
                C(159 downto 144) <= std_logic_vector(unsigned(A(159 downto 144)) - unsigned(B(159 downto 144)));
                C(143 downto 128) <= std_logic_vector(unsigned(A(143 downto 128)) - unsigned(B(143 downto 128)));
                C(127 downto 112) <= std_logic_vector(unsigned(A(127 downto 112)) - unsigned(B(127 downto 112)));
                C(111 downto 96)  <= std_logic_vector(unsigned(A(111 downto 96)) - unsigned(B(111 downto 96)));
                C(95  downto 80)  <= std_logic_vector(unsigned(A(95  downto 80)) - unsigned(B(95  downto 80)));
                C(79  downto 64)  <= std_logic_vector(unsigned(A(79  downto 64)) - unsigned(B(79  downto 64)));
                C(63  downto 48)  <= std_logic_vector(unsigned(A(63  downto 48)) - unsigned(B(63  downto 48)));
                C(47  downto 32)  <= std_logic_vector(unsigned(A(47  downto 32)) - unsigned(B(47  downto 32)));
                C(31  downto 16)  <= std_logic_vector(unsigned(A(31  downto 16)) - unsigned(B(31  downto 16)));
                C(15  downto 0)   <= std_logic_vector(unsigned(A(15  downto 0)) - unsigned(B(15  downto 0)));
            when "0000000000000101"=>
                if rising_edge(clk) then
                    -- Para cada linha de A (i varia de 0 a 15)
                    for i in 0 to 15 loop
                        -- Para cada coluna de B (j varia de 0 a 15)
                        for j in 0 to 15 loop
                            -- Inicializa o somatório para C(i, j)
                            
                            -- Para cada elemento da linha i de A e coluna j de B
                            for k in 0 to 15 loop
                                -- Multiplica o elemento A(i, k) pelo elemento B(k, j)
                                temp_sum <= temp_sum + (unsigned(A((i * 16 + k) * 16 + 15 downto (i * 16 + k) * 16)) *
                                            unsigned(B((k * 16 + j) * 16 + 15 downto (k * 16 + j) * 16)));
                            end loop;
            
                            -- Atribui o resultado à posição C(i, j)
                            C((i * 16 + j) * 16 + 15 downto (i * 16 + j) * 16) <= std_logic_vector(temp_sum);
                        end loop;
                    end loop;
                end if;
            when others =>        
        end case;
    end process;

end architecture reg;
	