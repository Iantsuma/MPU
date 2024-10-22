library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Std_Logic_Signed.all;
use IEEE.Numeric_Std.all;  -- Adicione esta biblioteca para manipular operações aritméticas
use work.R8.all;

entity MPU is
    port(
        ce_n, we_n, oe_n: in std_logic;
        intr: out std_logic;
        clk:    in std_logic;
        address: in reg16;
        data: inout reg16
    );
end entity MPU;

architecture reg of MPU is
    signal A 	: std_logic_vector(255 downto 0);
    signal B 	: std_logic_vector(255 downto 0);
    signal C 	: std_logic_vector(255 downto 0);
	 signal regA : std_logic_vector(15 downto 0);
	 signal regB : std_logic_vector(15 downto 0);
	 signal regC : std_logic_vector(31 downto 0);
    signal temp_sum : std_logic_vector(31 downto 0);
     

begin
    data <= (others => 'Z');
 
	    -- Processamento da ULA baseado no opcode
    process(A, B, C, data)
    begin
        case data is
            when "0000000000000000" =>  -- Operação de Soma
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
            when "0000000000000001" =>
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
            -- Adicione outras operações da ULA aqui (subtração, AND, OR, etc.)
            when "0000000000000010"=>
                for i in 0 to 3 loop
                    for j in 0 to 3 loop
                        temp_sum <= (others => '0'); -- Inicializa o somador

                        for k in 0 to 3 loop
                            -- Pegando os elementos 16 bits de A e B para multiplicação
                            regA <= A(16*(i*4+k) + 15 downto 16*(i*4+k));
                            regB <= B(16*(k*4+j) + 15 downto 16*(k*4+j));

                            -- Multiplicação e acumulação dos resultados
                            temp_sum <= temp_sum + std_logic_vector(signed(regA) * signed(regB));
                        end loop;

                        -- Guardar o resultado 16 bits em C (note que tomamos os 16 bits menos significativos)
                        C(16*(i*4+j) + 15 downto 16*(i*4+j)) <= temp_sum(15 downto 0); 
                    end loop;
            end loop;

            when others => 
                C <= (others => '0');  -- Valor padrão se o opcode não for reconhecido
        end case;
    end process;

end architecture reg;
	