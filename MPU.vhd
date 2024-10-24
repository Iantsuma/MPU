library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.ALL;
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

    --ce_n chip enable = chip disponível, se estiver realizando operação, está 1
    --write enable chip write, 0 quando pode escrever e 1 quando não
    --output enable == REad
end entity MPU;

architecture reg of MPU is
    signal A 	: std_logic_vector(255 downto 0);
    signal B 	: std_logic_vector(255 downto 0);
    signal C 	: std_logic_vector(255 downto 0);
    signal AUX  : std_logic_vector(255 downto 0);
    signal com  : std_logic_vector(255 downto 0);


     

    procedure SOMA  ( 
                    signal MAT1 	:   in  std_logic_vector(255 downto 0);
                    signal MAT2 	:   in  std_logic_vector(255 downto 0);
                    signal MATR 	:   out std_logic_vector(255 downto 0)
                    ) is
        begin
            MATR(255 downto 240) <= std_logic_vector(signed(MAT1(255 downto 240)) + signed(MAT2(255 downto 240)));
            MATR(239 downto 224) <= std_logic_vector(signed(MAT1(239 downto 224)) + signed(MAT2(239 downto 224)));
            MATR(223 downto 208) <= std_logic_vector(signed(MAT1(223 downto 208)) + signed(MAT2(223 downto 208)));
            MATR(207 downto 192) <= std_logic_vector(signed(MAT1(207 downto 192)) + signed(MAT2(207 downto 192)));
            MATR(191 downto 176) <= std_logic_vector(signed(MAT1(191 downto 176)) + signed(MAT2(191 downto 176)));
            MATR(175 downto 160) <= std_logic_vector(signed(MAT1(175 downto 160)) + signed(MAT2(175 downto 160)));
            MATR(159 downto 144) <= std_logic_vector(signed(MAT1(159 downto 144)) + signed(MAT2(159 downto 144)));
            MATR(143 downto 128) <= std_logic_vector(signed(MAT1(143 downto 128)) + signed(MAT2(143 downto 128)));
            MATR(127 downto 112) <= std_logic_vector(signed(MAT1(127 downto 112)) + signed(MAT2(127 downto 112)));
            MATR(111 downto 96)  <= std_logic_vector(signed(MAT1(111 downto 96)) + signed(MAT2(111 downto 96)));
            MATR(95  downto 80)  <= std_logic_vector(signed(MAT1(95  downto 80)) + signed(MAT2(95  downto 80)));
            MATR(79  downto 64)  <= std_logic_vector(signed(MAT1(79  downto 64)) + signed(MAT2(79  downto 64)));
            MATR(63  downto 48)  <= std_logic_vector(signed(MAT1(63  downto 48)) + signed(MAT2(63  downto 48)));
            MATR(47  downto 32)  <= std_logic_vector(signed(MAT1(47  downto 32)) + signed(MAT2(47  downto 32)));
            MATR(31  downto 16)  <= std_logic_vector(signed(MAT1(31  downto 16)) + signed(MAT2(31  downto 16)));
            MATR(15  downto 0)   <= std_logic_vector(signed(MAT1(15  downto 0)) + signed(MAT2(15  downto 0)));
    end SOMA;

    procedure SUB  ( 
                signal MAT1 	:   in  std_logic_vector(255 downto 0);
                signal MAT2 	:   in  std_logic_vector(255 downto 0);
                signal MATR 	:   out std_logic_vector(255 downto 0)
                ) is
        begin
            MATR(255 downto 240) <= std_logic_vector(signed(MAT1(255 downto 240)) - signed(MAT2(255 downto 240)));
            MATR(239 downto 224) <= std_logic_vector(signed(MAT1(239 downto 224)) - signed(MAT2(239 downto 224)));
            MATR(223 downto 208) <= std_logic_vector(signed(MAT1(223 downto 208)) - signed(MAT2(223 downto 208)));
            MATR(207 downto 192) <= std_logic_vector(signed(MAT1(207 downto 192)) - signed(MAT2(207 downto 192)));
            MATR(191 downto 176) <= std_logic_vector(signed(MAT1(191 downto 176)) - signed(MAT2(191 downto 176)));
            MATR(175 downto 160) <= std_logic_vector(signed(MAT1(175 downto 160)) - signed(MAT2(175 downto 160)));
            MATR(159 downto 144) <= std_logic_vector(signed(MAT1(159 downto 144)) - signed(MAT2(159 downto 144)));
            MATR(143 downto 128) <= std_logic_vector(signed(MAT1(143 downto 128)) - signed(MAT2(143 downto 128)));
            MATR(127 downto 112) <= std_logic_vector(signed(MAT1(127 downto 112)) - signed(MAT2(127 downto 112)));
            MATR(111 downto 96)  <= std_logic_vector(signed(MAT1(111 downto 96)) - signed(MAT2(111 downto 96)));
            MATR(95  downto 80)  <= std_logic_vector(signed(MAT1(95  downto 80)) - signed(MAT2(95  downto 80)));
            MATR(79  downto 64)  <= std_logic_vector(signed(MAT1(79  downto 64)) - signed(MAT2(79  downto 64)));
            MATR(63  downto 48)  <= std_logic_vector(signed(MAT1(63  downto 48)) - signed(MAT2(63  downto 48)));
            MATR(47  downto 32)  <= std_logic_vector(signed(MAT1(47  downto 32)) - signed(MAT2(47  downto 32)));
            MATR(31  downto 16)  <= std_logic_vector(signed(MAT1(31  downto 16)) - signed(MAT2(31  downto 16)));
            MATR(15  downto 0)   <= std_logic_vector(signed(MAT1(15  downto 0)) - signed(MAT2(15  downto 0)));
    end SUB;

    procedure FILL  (
                    signal MAT 	:   out  std_logic_vector(255 downto 0);
                    signal data :   in std_logic_vector(15 downto 0)
                    ) is
        begin
            MAT(255 downto 240) <= data;
            MAT(239 downto 224) <= data;
            MAT(223 downto 208) <= data;
            MAT(207 downto 192) <= data;
            MAT(191 downto 176) <= data;
            MAT(175 downto 160) <= data;
            MAT(159 downto 144) <= data;
            MAT(143 downto 128) <= data;
            MAT(127 downto 112) <= data;
            MAT(111 downto 96)  <= data;
            MAT(95  downto 80)  <= data;
            MAT(79  downto 64)  <= data;
            MAT(63  downto 48)  <= data;
            MAT(47  downto 32)  <= data;
            MAT(31  downto 16)  <= data;
            MAT(15  downto 0)   <= data;
    end FILL;

    procedure MUL  (
                        signal A 	:   in  std_logic_vector(255 downto 0);
                        signal B 	:   in  std_logic_vector(255 downto 0);
                        signal C 	:   out std_logic_vector(255 downto 0)
                       ) is
                        variable temp_sum00 : std_logic_vector(31 downto 0);
                        variable temp_sum01 : std_logic_vector(31 downto 0);
                        variable temp_sum02 : std_logic_vector(31 downto 0);
                        variable temp_sum03 : std_logic_vector(31 downto 0);
                        variable temp_sum10 : std_logic_vector(31 downto 0);
                        variable temp_sum11: std_logic_vector(31 downto 0);
                        variable temp_sum12 : std_logic_vector(31 downto 0);
                        variable temp_sum13 : std_logic_vector(31 downto 0);
                        variable temp_sum20: std_logic_vector(31 downto 0);
                        variable temp_sum21: std_logic_vector(31 downto 0);
                        variable temp_sum22 : std_logic_vector(31 downto 0);
                        variable temp_sum23 : std_logic_vector(31 downto 0);
                        variable temp_sum30: std_logic_vector(31 downto 0);
                        variable temp_sum31 : std_logic_vector(31 downto 0);
                        variable temp_sum32 : std_logic_vector(31 downto 0);
                        variable temp_sum33 : std_logic_vector(31 downto 0);
        begin
            temp_sum00:=
                std_logic_vector
                    (
                        (signed(A(255 downto 240)) * signed(B(255 downto 240))) +
                        (signed(A(239 downto 224)) * signed(B(191 downto 176))) +
                        (signed(A(223 downto 208)) * signed(B(127 downto 112))) +
                        (signed(A(207 downto 192)) * signed(B(63 downto 48)))
                    );
                C(255 downto 240) <=temp_sum00(31 downto 16);
                --############################################################################00              
                temp_sum01:=
                std_logic_vector
                    (
                        (signed(A(255 downto 240)) * signed(B(239 downto 224))) +
                        (signed(A(239 downto 224)) * signed(B(175 downto 160))) +
                        (signed(A(223 downto 208)) * signed(B(111 downto 96))) +
                        (signed(A(207 downto 192)) * signed(B(47 downto 32)))
                    );
                C(239 downto 224) <=temp_sum01(31 downto 16);
                --############################################################################01
                temp_sum02:=
                std_logic_vector
                    (
                        (signed(A(255 downto 240)) * signed(B(223 downto 208))) +
                        (signed(A(239 downto 224)) * signed(B(159 downto 144))) +
                        (signed(A(223 downto 208)) * signed(B(95  downto 80))) +
                        (signed(A(207 downto 192)) * signed(B(31 downto 16)))
                    );
                C(223 downto 208) <=temp_sum02(31 downto 16);
                --############################################################################02
                temp_sum03:=
                std_logic_vector
                    (
                        (signed(A(255 downto 240)) * signed(B(207 downto 192))) +
                        (signed(A(239 downto 224)) * signed(B(143 downto 128))) +
                        (signed(A(223 downto 208)) * signed(B(79 downto 64))) +
                        (signed(A(207 downto 192)) * signed(B(15 downto 0)))
                    );
                C(207 downto 192) <=temp_sum03(31 downto 16);
                --############################################################################03
                temp_sum10:=
                std_logic_vector
                    (
                        (signed(A(191 downto 176)) * signed(B(255 downto 240))) +
                        (signed(A(175 downto 160)) * signed(B(191 downto 176))) +
                        (signed(A(159 downto 144)) * signed(B(127 downto 112))) +
                        (signed(A(143 downto 128)) * signed(B(63 downto 48)))
                    );
                C(191 downto 176) <=temp_sum10(31 downto 16);
                
                temp_sum11:=
                std_logic_vector
                (
                    (signed(A(191 downto 176)) * signed(B(239 downto 224))) +
                    (signed(A(175 downto 160)) * signed(B(175 downto 160))) +
                    (signed(A(159 downto 144)) * signed(B(111 downto 96))) +
                    (signed(A(143 downto 128)) * signed(B(47 downto 32)))
                );
                C(175 downto 160) <=temp_sum11(31 downto 16);

                temp_sum12:=
                std_logic_vector
                (
                    (signed(A(191 downto 176)) * signed(B(223 downto 208))) +           
                    (signed(A(175 downto 160)) * signed(B(159 downto 144))) +
                    (signed(A(159 downto 144)) * signed(B(95  downto 80))) +
                    (signed(A(143 downto 128)) * signed(B(31 downto 16)))
                );
                C(159 downto 144) <=temp_sum12(31 downto 16);

                temp_sum13:=
                std_logic_vector
                (
                    (signed(A(191 downto 176)) * signed(B(207 downto 192))) +
                    (signed(A(175 downto 160)) * signed(B(143 downto 128))) +
                    (signed(A(159 downto 144)) * signed(B(79 downto 64))) +
                    (signed(A(143 downto 128)) * signed(B(15 downto 0)))
                );
                C(143 downto 128) <=temp_sum13(31 downto 16);

                temp_sum20:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(255 downto 240))) +
                    (signed(A(111 downto 96))  * signed(B(191 downto 176))) +
                    (signed(A(95  downto 80))  * signed(B(127 downto 112))) +
                    (signed(A(79 downto 64))   * signed(B(63 downto 48)))
                );
                C(127 downto 112) <=temp_sum20(31 downto 16);

                temp_sum21:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(239 downto 224))) +
                    (signed(A(111 downto 96))  * signed(B(175 downto 160))) +
                    (signed(A(95  downto 80))  * signed(B(111 downto 96))) +
                    (signed(A(79 downto 64))   * signed(B(47 downto 32)))
                );
                C(111 downto 96) <=temp_sum21(31 downto 16);

                temp_sum22:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(223 downto 208))) +
                    (signed(A(111 downto 96))  * signed(B(159 downto 144))) +
                    (signed(A(95  downto 80))  * signed(B(95  downto 80))) +
                    (signed(A(79 downto 64))   * signed(B(31 downto 16)))
                );
                C(95  downto 80) <=temp_sum22(31 downto 16);

                temp_sum23:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(207 downto 192))) +
                    (signed(A(111 downto 96))  * signed(B(143 downto 128))) +
                    (signed(A(95  downto 80))  * signed(B(79 downto 64))) +
                    (signed(A(79 downto 64))   * signed(B(15 downto 0)))
                );
                C(79 downto 64) <=temp_sum23(31 downto 16);

                temp_sum30:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(255 downto 240))) +
                    (signed(A(111 downto 96))  * signed(B(191 downto 176))) +
                    (signed(A(95  downto 80))  * signed(B(127 downto 112))) +
                    (signed(A(79 downto 64))   * signed(B(63 downto 48)))
                );
                C(63 downto 48) <=temp_sum30(31 downto 16);

                temp_sum31:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(239 downto 224))) +
                    (signed(A(111 downto 96))  * signed(B(175 downto 160))) +
                    (signed(A(95  downto 80))  * signed(B(111 downto 96))) +
                    (signed(A(79 downto 64))   * signed(B(47 downto 32)))
                );
                C(47 downto 32) <=temp_sum31(31 downto 16);

                temp_sum32:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(223 downto 208))) +
                    (signed(A(111 downto 96))  * signed(B(159 downto 144))) +
                    (signed(A(95  downto 80))  * signed(B(95  downto 80))) +
                    (signed(A(79 downto 64))   * signed(B(31 downto 16)))
                );
                C(31 downto 16) <=temp_sum32(31 downto 16);

                temp_sum33:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(207 downto 192))) +
                    (signed(A(111 downto 96))  * signed(B(143 downto 128))) +
                    (signed(A(95  downto 80))  * signed(B(79 downto 64))) +
                    (signed(A(79 downto 64))   * signed(B(15 downto 0)))
                );
                C(15 downto 0) <=temp_sum33(31 downto 16);
    end MUL;

    procedure ID   (
                    signal MAT 	:   out  std_logic_vector(255 downto 0);
                    signal data :   in std_logic_vector(15 downto 0)
                   ) is
        begin
        MAT(255 downto 240) <= data;
        MAT(239 downto 224) <= "0000000000000000";
        MAT(223 downto 208) <= "0000000000000000";
        MAT(207 downto 192) <= "0000000000000000";
        MAT(191 downto 176) <= "0000000000000000";
        MAT(175 downto 160) <= data;
        MAT(159 downto 144) <= "0000000000000000";
        MAT(143 downto 128) <= "0000000000000000";
        MAT(127 downto 112) <= "0000000000000000";
        MAT(111 downto 96)  <= "0000000000000000";
        MAT(95  downto 80)  <= data;
        MAT(79  downto 64)  <= "0000000000000000";
        MAT(63  downto 48)  <= "0000000000000000";
        MAT(47  downto 32)  <= "0000000000000000";
        MAT(31  downto 16)  <= "0000000000000000";
        MAT(15  downto 0)   <= data;

    end ID;

begin
    data <= (others => 'Z');
    -- LINHA ABAIXO FEITa APENAS PARA TESTE
        com(15 downto 0) <= "0000000000000000";
    --LINHAS ACIMA FEITAS APENAS PARA TESTE SEM O r8
	    -- Processamento da ULA baseado no opcode
    process(A, B, AUX, com, clk, rst, data)
    begin
        if rising_edge(clk) then
            case com(15 downto 0) is  --Se com na posição address for igual a:
                when "0000000000000000"=>                              --fill A com data
                    FILL(A, data);
                when "0000000000000001"=>                              --fill B com data
                    FILL(B, data);
                when "0000000000000010"=>                              --fill C com data
                    FILL(C, data);
                when "0000000000000011"=>                              --Soma A, B, Armazena em C
                    SOMA(A, B, C);
                when "0000000000000100"=>                              --Sub A, B, Armazena em C
                    SUB(A, B, C);
                when "0000000000000101"=>                              --Multiplicação C = A X B
                    MUL(A, B, C);
                when "0000000000000111"=>                              --Mac C= C + A X B
                    MUL(A, B, AUX);
                    SOMA(C, AUX, C);
                when "0000000000001000"=>                              --Identidade A, B e C igual a data respectivamente
                    ID(A, data);                                         
                when "0000000000001001"=>
                    ID(B, data);
                when "0000000000001010"=>
                    ID(C, data);
                    
                    
                    


                when others =>        
            end case;
        end if;
    end process;

end architecture reg;