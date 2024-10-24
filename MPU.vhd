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
	 
	
	procedure soma (MatrizA, MatrizB : in matriz; MatrizC : out matriz) is
	begin
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				MatrizC(i, j) <= std_logic_vector(signed(MatrizA(i, j)) + signed(MatrizB(i, j)));
			end loop;
		end loop;
	end procedure;
	
	
	procedure sub (MatrizA, MatrizB : in matriz; MatrizC : out matriz) is
	begin
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				MatrizC(i, j) <= std_logic_vector(signed(MatrizA(i, j)) - signed(MatrizB(i, j)));
			end loop;
		end loop;
	end procedure;
	
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
	
	procedure fill (Matriz: out matriz; valor: in reg16) is
	begin
		 for i in 0 to 3 loop
			  for j in 0 to 3 loop
					-- Preenche cada elemento da matriz com o valor fornecido
					Matriz(i, j) <= valor;
			  end loop;
		 end loop;
	end procedure;
	
	
begin 

end architecture operations;
	