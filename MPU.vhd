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

architecture operations of MPU is
    
	type matriz is array (0 to 3, 0 to 3) of std_logic_vector(15 downto 0); --Definição do tipo MATRIZ 4x4
																									 --Cada celula é um vetor de 16bits
	type matriz_bank is array (0 to 2) of matriz; --Registrador de 3 bit para cada uma das matrizes A,B,C
	
	signal registrador_comandos: std_logic_vector(255 downto 0) := (others => '0'); 
	
	signal aux_matriz : matriz;
	
	signal reg : matriz_bank := (others =>(others =>(others =>(others => '0')))); 
	 
	signal data_out : reg16;
	
	
	 
	--Procedimento Soma
	
	procedure soma (MatrizA, MatrizB : in matriz; MatrizC : out matriz) is
	begin
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				MatrizC(i, j) <= std_logic_vector(signed(MatrizA(i, j)) + signed(MatrizB(i, j)));
			end loop;
		end loop;
	end procedure;
	
	
	--Procedimaento Subtração
	
	procedure sub (MatrizA, MatrizB : in matriz; MatrizC : out matriz) is
	begin
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				MatrizC(i, j) <= std_logic_vector(signed(MatrizA(i, j)) - signed(MatrizB(i, j)));
			end loop;
		end loop;
	end procedure;
	
	
	--Procedimento Multiplicação
	
	procedure multiplica (MatrizA, MatrizB : in matriz; MatrizC : out matriz) is
	begin
		 for i in 0 to 3 loop
			  for j in 0 to 3 loop
					-- Inicializa o elemento MatrizC(i,j) com zero
					MatrizC(i, j) <= (others => '0');
					for k in 0 to 3 loop
						 -- Acumula o produto da linha de A com a coluna de B
						 MatrizC(i, j) <= std_logic_vector(signed(MatrizC(i, j)) + signed(MatrizA(i, k)) * signed(MatrizB(k, j)));
					end loop;
			  end loop;
		 end loop;
	end procedure;
	
	
	
	--Procedimento Fill
	
	procedure fill (Matriz: out matriz; valor: in reg16) is
	begin
		 for i in 0 to 3 loop
			  for j in 0 to 3 loop
					-- Preenche cada elemento da matriz com o valor fornecido
					Matriz(i, j) <= valor;
			  end loop;
		 end loop;
	end procedure;

	
	--Procedimento Indentidade
	
	procedure identidade (Matriz: out matriz; valor: in reg16) is
	begin
		 for i in 0 to 3 loop
			  for j in 0 to 3 loop
					-- Se estiver na diagonal principal (i = j), coloca o valor fornecido
					if i = j then
						 Matriz(i, j) <= valor;
					else
						 -- Caso contrário, preenche com zero
						 Matriz(i, j) <= (others => '0');
					end if;
			  end loop;
		 end loop;
	end procedure;
	
	
	
	process(clk, ce_n, we_n, oe_n, data, adress, registrador_comandos)
		if rising_edge(clk) then
			if ce_n = '0' and we_n = '0' then
				 if address(5 downto 4) = "00" then
						 registrador_comandos(31 downto 16) <= data;
					else
						 -- Escreve nos registradores de matriz A, B ou C
						 reg(to_integer(unsigned(address(5 downto 4))))(to_integer(unsigned(address(3 downto 2))), to_integer(unsigned(address(1 downto 0)))) <= data;
					end if;
			  end if;

			  -- Leitura de dados
			  if ce_n = '0' and oe_n = '0' then
					if address(5 downto 4) = "00" then
						 data_out <= registrador_comandos(15 downto 0);
					else
						 data_out <= reg(to_integer(unsigned(address(5 downto 4))))(to_integer(unsigned(address(3 downto 2))), to_integer(unsigned(address(1 downto 0))));
					end if;
			  end if;

			  -- Operações de acordo com os comandos
			  if ce_n = '1' then
					-- Seleciona os registradores A e B para a operação
					aux_matriz <= reg(to_integer(unsigned(registrador_comandos(21 downto 20))));
					case registrador_comandos(19 downto 16) is
						 when "0000" => -- Soma
							  soma(reg(to_integer(unsigned(registrador_comandos(21 downto 20)))), reg(to_integer(unsigned(registrador_comandos(23 downto 22)))), reg(2));
						 when "0001" => -- Subtração
							  sub(reg(to_integer(unsigned(registrador_comandos(21 downto 20)))), reg(to_integer(unsigned(registrador_comandos(23 downto 22)))), reg(2));
						 when "0010" => -- Multiplicação
							  multiplica(reg(to_integer(unsigned(registrador_comandos(21 downto 20)))), reg(to_integer(unsigned(registrador_comandos(23 downto 22)))), reg(2));
						 when "0011" => -- Soma após multiplicação
							  multiplica(reg(to_integer(unsigned(registrador_comandos(21 downto 20)))), reg(to_integer(unsigned(registrador_comandos(23 downto 22)))), aux_matriz);
							  soma(aux_matriz, reg(2), reg(2));
						 when "0100" => -- Preencher matriz com um valor
							  fill(reg(to_integer(unsigned(registrador_comandos(21 downto 20)))), data);
						 when "0101" => -- Preencher matriz identidade
							  identidade(reg(to_integer(unsigned(registrador_comandos(21 downto 20)))), data);
						 when others => -- Nenhuma operação
							  null;
					end case;

					-- Gera interrupção após a operação
					intr <= '1';
			  end if;
		 end if;
	end process;

	-- Atribuir a saída de dados ao barramento de dados
	data <= data_out when oe_n = '0' else (others => 'Z');  -- Tristate logic
 
					
		
	
	
begin 

end architecture operations;
	