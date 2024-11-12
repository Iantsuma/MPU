library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use work.R8.all;
use ieee.std_logic_textio.all;

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
    ---signal A 	: std_logic_vector(255 downto 0);
   -- signal B 	: std_logic_vector(255 downto 0);
   -- signal C 	: std_logic_vector(255 downto 0);
    signal MATRIX :std_logic_vector(1023 downto 0);
    --1023 -> 768   : A
    --767 -> 512    : B
    --511 -> 256    : C
    --255 -> 0      : CONTROLE
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
                C(255 downto 240) <=temp_sum00(15 downto 0);
                --############################################################################00              
                temp_sum01:=
                std_logic_vector
                    (
                        (signed(A(255 downto 240)) * signed(B(239 downto 224))) +
                        (signed(A(239 downto 224)) * signed(B(175 downto 160))) +
                        (signed(A(223 downto 208)) * signed(B(111 downto 96))) +
                        (signed(A(207 downto 192)) * signed(B(47 downto 32)))
                    );
                C(239 downto 224) <=temp_sum01(15 downto 0);
                --############################################################################01
                temp_sum02:=
                std_logic_vector
                    (
                        (signed(A(255 downto 240)) * signed(B(223 downto 208))) +
                        (signed(A(239 downto 224)) * signed(B(159 downto 144))) +
                        (signed(A(223 downto 208)) * signed(B(95  downto 80))) +
                        (signed(A(207 downto 192)) * signed(B(15 downto 0)))
                    );
                C(223 downto 208) <=temp_sum02(15 downto 0);
                --############################################################################02
                temp_sum03:=
                std_logic_vector
                    (
                        (signed(A(255 downto 240)) * signed(B(207 downto 192))) +
                        (signed(A(239 downto 224)) * signed(B(143 downto 128))) +
                        (signed(A(223 downto 208)) * signed(B(79 downto 64))) +
                        (signed(A(207 downto 192)) * signed(B(15 downto 0)))
                    );
                C(207 downto 192) <=temp_sum03(15 downto 0);
                --############################################################################03
                temp_sum10:=
                std_logic_vector
                    (
                        (signed(A(191 downto 176)) * signed(B(255 downto 240))) +
                        (signed(A(175 downto 160)) * signed(B(191 downto 176))) +
                        (signed(A(159 downto 144)) * signed(B(127 downto 112))) +
                        (signed(A(143 downto 128)) * signed(B(63 downto 48)))
                    );
                C(191 downto 176) <=temp_sum10(15 downto 0);
                
                temp_sum11:=
                std_logic_vector
                (
                    (signed(A(191 downto 176)) * signed(B(239 downto 224))) +
                    (signed(A(175 downto 160)) * signed(B(175 downto 160))) +
                    (signed(A(159 downto 144)) * signed(B(111 downto 96))) +
                    (signed(A(143 downto 128)) * signed(B(47 downto 32)))
                );
                C(175 downto 160) <=temp_sum11(15 downto 0);

                temp_sum12:=
                std_logic_vector
                (
                    (signed(A(191 downto 176)) * signed(B(223 downto 208))) +           
                    (signed(A(175 downto 160)) * signed(B(159 downto 144))) +
                    (signed(A(159 downto 144)) * signed(B(95  downto 80))) +
                    (signed(A(143 downto 128)) * signed(B(15 downto 0)))
                );
                C(159 downto 144) <=temp_sum12(15 downto 0);

                temp_sum13:=
                std_logic_vector
                (
                    (signed(A(191 downto 176)) * signed(B(207 downto 192))) +
                    (signed(A(175 downto 160)) * signed(B(143 downto 128))) +
                    (signed(A(159 downto 144)) * signed(B(79 downto 64))) +
                    (signed(A(143 downto 128)) * signed(B(15 downto 0)))
                );
                C(143 downto 128) <=temp_sum13(15 downto 0);

                temp_sum20:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(255 downto 240))) +
                    (signed(A(111 downto 96))  * signed(B(191 downto 176))) +
                    (signed(A(95  downto 80))  * signed(B(127 downto 112))) +
                    (signed(A(79 downto 64))   * signed(B(63 downto 48)))
                );
                C(127 downto 112) <=temp_sum20(15 downto 0);

                temp_sum21:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(239 downto 224))) +
                    (signed(A(111 downto 96))  * signed(B(175 downto 160))) +
                    (signed(A(95  downto 80))  * signed(B(111 downto 96))) +
                    (signed(A(79 downto 64))   * signed(B(47 downto 32)))
                );
                C(111 downto 96) <=temp_sum21(15 downto 0);

                temp_sum22:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(223 downto 208))) +
                    (signed(A(111 downto 96))  * signed(B(159 downto 144))) +
                    (signed(A(95  downto 80))  * signed(B(95  downto 80))) +
                    (signed(A(79 downto 64))   * signed(B(15 downto 0)))
                );
                C(95  downto 80) <=temp_sum22(15 downto 0);

                temp_sum23:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(207 downto 192))) +
                    (signed(A(111 downto 96))  * signed(B(143 downto 128))) +
                    (signed(A(95  downto 80))  * signed(B(79 downto 64))) +
                    (signed(A(79 downto 64))   * signed(B(15 downto 0)))
                );
                C(79 downto 64) <=temp_sum23(15 downto 0);

                temp_sum30:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(255 downto 240))) +
                    (signed(A(111 downto 96))  * signed(B(191 downto 176))) +
                    (signed(A(95  downto 80))  * signed(B(127 downto 112))) +
                    (signed(A(79 downto 64))   * signed(B(63 downto 48)))
                );
                C(63 downto 48) <=temp_sum30(15 downto 0);

                temp_sum31:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(239 downto 224))) +
                    (signed(A(111 downto 96))  * signed(B(175 downto 160))) +
                    (signed(A(95  downto 80))  * signed(B(111 downto 96))) +
                    (signed(A(79 downto 64))   * signed(B(47 downto 32)))
                );
                C(47 downto 32) <=temp_sum31(15 downto 0);

                temp_sum32:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(223 downto 208))) +
                    (signed(A(111 downto 96))  * signed(B(159 downto 144))) +
                    (signed(A(95  downto 80))  * signed(B(95  downto 80))) +
                    (signed(A(79 downto 64))   * signed(B(15 downto 0)))
                );
                C(31 downto 16) <=temp_sum32(15 downto 0);

                temp_sum33:=
                std_logic_vector
                (
                    (signed(A(127 downto 112)) * signed(B(207 downto 192))) +
                    (signed(A(111 downto 96))  * signed(B(143 downto 128))) +
                    (signed(A(95  downto 80))  * signed(B(79 downto 64))) +
                    (signed(A(79 downto 64))   * signed(B(15 downto 0)))
                );
                C(15 downto 0) <=temp_sum33(15 downto 0);
    end MUL;

    procedure MAC (
        signal A 	:   in  std_logic_vector(255 downto 0);
        signal B 	:   in  std_logic_vector(255 downto 0);
        signal C 	:   inout std_logic_vector(255 downto 0)
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
                Variable TEMP_MAT   : std_logic_vector(255 downto 0);
                Variable TEMP_MAT2   : std_logic_vector(255 downto 0);
                begin
                temp_sum00:=
                    std_logic_vector
                        (
                            (signed(A(255 downto 240)) * signed(B(255 downto 240))) +
                            (signed(A(239 downto 224)) * signed(B(191 downto 176))) +
                            (signed(A(223 downto 208)) * signed(B(127 downto 112))) +
                            (signed(A(207 downto 192)) * signed(B(63 downto 48)))
                        );
                    TEMP_MAT(255 downto 240) :=temp_sum00(15 downto 0);
                    --############################################################################00              
                    temp_sum01:=
                    std_logic_vector
                        (
                            (signed(A(255 downto 240)) * signed(B(239 downto 224))) +
                            (signed(A(239 downto 224)) * signed(B(175 downto 160))) +
                            (signed(A(223 downto 208)) * signed(B(111 downto 96))) +
                            (signed(A(207 downto 192)) * signed(B(47 downto 32)))
                        );
                    TEMP_MAT(239 downto 224) :=temp_sum01(15 downto 0);
                    --############################################################################01
                    temp_sum02:=
                    std_logic_vector
                        (
                            (signed(A(255 downto 240)) * signed(B(223 downto 208))) +
                            (signed(A(239 downto 224)) * signed(B(159 downto 144))) +
                            (signed(A(223 downto 208)) * signed(B(95  downto 80))) +
                            (signed(A(207 downto 192)) * signed(B(15 downto 0)))
                        );
                    TEMP_MAT(223 downto 208) :=temp_sum02(15 downto 0);
                    --############################################################################02
                    temp_sum03:=
                    std_logic_vector
                        (
                            (signed(A(255 downto 240)) * signed(B(207 downto 192))) +
                            (signed(A(239 downto 224)) * signed(B(143 downto 128))) +
                            (signed(A(223 downto 208)) * signed(B(79 downto 64))) +
                            (signed(A(207 downto 192)) * signed(B(15 downto 0)))
                        );
                    TEMP_MAT(207 downto 192) :=temp_sum03(15 downto 0);
                    --############################################################################03
                    temp_sum10:=
                    std_logic_vector
                        (
                            (signed(A(191 downto 176)) * signed(B(255 downto 240))) +
                            (signed(A(175 downto 160)) * signed(B(191 downto 176))) +
                            (signed(A(159 downto 144)) * signed(B(127 downto 112))) +
                            (signed(A(143 downto 128)) * signed(B(63 downto 48)))
                        );
                    TEMP_MAT(191 downto 176) :=temp_sum10(15 downto 0);
                    
                    temp_sum11:=
                    std_logic_vector
                    (
                        (signed(A(191 downto 176)) * signed(B(239 downto 224))) +
                        (signed(A(175 downto 160)) * signed(B(175 downto 160))) +
                        (signed(A(159 downto 144)) * signed(B(111 downto 96))) +
                        (signed(A(143 downto 128)) * signed(B(47 downto 32)))
                    );
                    TEMP_MAT(175 downto 160) :=temp_sum11(15 downto 0);
    
                    temp_sum12:=
                    std_logic_vector
                    (
                        (signed(A(191 downto 176)) * signed(B(223 downto 208))) +           
                        (signed(A(175 downto 160)) * signed(B(159 downto 144))) +
                        (signed(A(159 downto 144)) * signed(B(95  downto 80))) +
                        (signed(A(143 downto 128)) * signed(B(15 downto 0)))
                    );
                    TEMP_MAT(159 downto 144) :=temp_sum12(15 downto 0);
    
                    temp_sum13:=
                    std_logic_vector
                    (
                        (signed(A(191 downto 176)) * signed(B(207 downto 192))) +
                        (signed(A(175 downto 160)) * signed(B(143 downto 128))) +
                        (signed(A(159 downto 144)) * signed(B(79 downto 64))) +
                        (signed(A(143 downto 128)) * signed(B(15 downto 0)))
                    );
                    TEMP_MAT(143 downto 128) :=temp_sum13(15 downto 0);
    
                    temp_sum20:=
                    std_logic_vector
                    (
                        (signed(A(127 downto 112)) * signed(B(255 downto 240))) +
                        (signed(A(111 downto 96))  * signed(B(191 downto 176))) +
                        (signed(A(95  downto 80))  * signed(B(127 downto 112))) +
                        (signed(A(79 downto 64))   * signed(B(63 downto 48)))
                    );
                    TEMP_MAT(127 downto 112) :=temp_sum20(15 downto 0);
    
                    temp_sum21:=
                    std_logic_vector
                    (
                        (signed(A(127 downto 112)) * signed(B(239 downto 224))) +
                        (signed(A(111 downto 96))  * signed(B(175 downto 160))) +
                        (signed(A(95  downto 80))  * signed(B(111 downto 96))) +
                        (signed(A(79 downto 64))   * signed(B(47 downto 32)))
                    );
                    TEMP_MAT(111 downto 96) :=temp_sum21(15 downto 0);
    
                    temp_sum22:=
                    std_logic_vector
                    (
                        (signed(A(127 downto 112)) * signed(B(223 downto 208))) +
                        (signed(A(111 downto 96))  * signed(B(159 downto 144))) +
                        (signed(A(95  downto 80))  * signed(B(95  downto 80))) +
                        (signed(A(79 downto 64))   * signed(B(15 downto 0)))
                    );
                    TEMP_MAT(95  downto 80) :=temp_sum22(15 downto 0);
    
                    temp_sum23:=
                    std_logic_vector
                    (
                        (signed(A(127 downto 112)) * signed(B(207 downto 192))) +
                        (signed(A(111 downto 96))  * signed(B(143 downto 128))) +
                        (signed(A(95  downto 80))  * signed(B(79 downto 64))) +
                        (signed(A(79 downto 64))   * signed(B(15 downto 0)))
                    );
                    TEMP_MAT(79 downto 64) :=temp_sum23(15 downto 0);
    
                    temp_sum30:=
                    std_logic_vector
                    (
                        (signed(A(127 downto 112)) * signed(B(255 downto 240))) +
                        (signed(A(111 downto 96))  * signed(B(191 downto 176))) +
                        (signed(A(95  downto 80))  * signed(B(127 downto 112))) +
                        (signed(A(79 downto 64))   * signed(B(63 downto 48)))
                    );
                    TEMP_MAT(63 downto 48) :=temp_sum30(15 downto 0);
    
                    temp_sum31:=
                    std_logic_vector
                    (
                        (signed(A(127 downto 112)) * signed(B(239 downto 224))) +
                        (signed(A(111 downto 96))  * signed(B(175 downto 160))) +
                        (signed(A(95  downto 80))  * signed(B(111 downto 96))) +
                        (signed(A(79 downto 64))   * signed(B(47 downto 32)))
                    );
                    TEMP_MAT(47 downto 32) :=temp_sum31(15 downto 0);
    
                    temp_sum32:=
                    std_logic_vector
                    (
                        (signed(A(127 downto 112)) * signed(B(223 downto 208))) +
                        (signed(A(111 downto 96))  * signed(B(159 downto 144))) +
                        (signed(A(95  downto 80))  * signed(B(95  downto 80))) +
                        (signed(A(79 downto 64))   * signed(B(15 downto 0)))
                    );
                    TEMP_MAT(31 downto 16) :=temp_sum32(15 downto 0);
    
                    temp_sum33:=
                    std_logic_vector
                    (
                        (signed(A(127 downto 112)) * signed(B(207 downto 192))) +
                        (signed(A(111 downto 96))  * signed(B(143 downto 128))) +
                        (signed(A(95  downto 80))  * signed(B(79 downto 64))) +
                        (signed(A(79 downto 64))   * signed(B(15 downto 0)))
                    );
                    TEMP_MAT(15 downto 0) :=temp_sum33(15 downto 0);
                    TEMP_MAT2 := C;


                    report "C: " & to_string(C);

                

                C(255 downto 240) <= std_logic_vector(signed(TEMP_MAT2(255 downto 240)) + signed(TEMP_MAT(255 downto 240)));
                C(239 downto 224) <= std_logic_vector(signed(TEMP_MAT2(239 downto 224)) + signed(TEMP_MAT(239 downto 224)));
                C(223 downto 208) <= std_logic_vector(signed(TEMP_MAT2(223 downto 208)) + signed(TEMP_MAT(223 downto 208)));
                C(207 downto 192) <= std_logic_vector(signed(TEMP_MAT2(207 downto 192)) + signed(TEMP_MAT(207 downto 192)));
                C(191 downto 176) <= std_logic_vector(signed(TEMP_MAT2(191 downto 176)) + signed(TEMP_MAT(191 downto 176)));
                C(175 downto 160) <= std_logic_vector(signed(TEMP_MAT2(175 downto 160)) + signed(TEMP_MAT(175 downto 160)));
                C(159 downto 144) <= std_logic_vector(signed(TEMP_MAT2(159 downto 144)) + signed(TEMP_MAT(159 downto 144)));
                C(143 downto 128) <= std_logic_vector(signed(TEMP_MAT2(143 downto 128)) + signed(TEMP_MAT(143 downto 128)));
                C(127 downto 112) <= std_logic_vector(signed(TEMP_MAT2(127 downto 112)) + signed(TEMP_MAT(127 downto 112)));
                C(111 downto 96)  <= std_logic_vector(signed(TEMP_MAT2(111 downto 96)) + signed(TEMP_MAT(111 downto 96)));
                C(95  downto 80)  <= std_logic_vector(signed(TEMP_MAT2(95  downto 80)) + signed(TEMP_MAT(95  downto 80)));
                C(79  downto 64)  <= std_logic_vector(signed(TEMP_MAT2(79  downto 64)) + signed(TEMP_MAT(79  downto 64)));
                C(63  downto 48)  <= std_logic_vector(signed(TEMP_MAT2(63  downto 48)) + signed(TEMP_MAT(63  downto 48)));
                C(47  downto 32)  <= std_logic_vector(signed(TEMP_MAT2(47  downto 32)) + signed(TEMP_MAT(47  downto 32)));
                C(31  downto 16)  <= std_logic_vector(signed(TEMP_MAT2(31  downto 16)) + signed(TEMP_MAT(31  downto 16)));
                C(15  downto 0)   <= std_logic_vector(signed(TEMP_MAT2(15  downto 0)) + signed(TEMP_MAT(15  downto 0)));

        end MAC;
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

    procedure READ (
                    signal address :   in std_logic_vector(5 downto 0);
                    signal data :   out std_logic_vector(15 downto 0);
                    signal MAT 	:   in  std_logic_vector(1023 downto 0)
                    ) is
        begin
            case address is
                when    "000000"=>
                        data <= MAT(1023 downto 1008);
                when    "000001"=>
                        data <= MAT(1007 downto 992);
                when    "000010"=>  
                        data <= MAT(991 downto 976);
                when    "000011"=>
                        data <= MAT(975 downto 960);
                when    "000100"=>
                        data <= MAT(959 downto 944);
                when    "000101"=>
                        data <= MAT(943 downto 928);
                when    "000110"=>
                        data <= MAT(927 downto 912);
                when    "000111"=>
                        data <= MAT(911 downto 896);
                when    "001000"=>
                        data <= MAT(895 downto 880);
                when    "001001"=>
                        data <= MAT(879 downto 864);
                when    "001010"=>
                        data <= MAT(863 downto 848);
                when    "001011"=>
                        data <= MAT(847 downto 832);
                when    "001100"=>
                        data <= MAT(831 downto 816);
                when    "001101"=>
                        data <= MAT(815 downto 800);
                when    "001110"=>
                        data <= MAT(799 downto 784);
                when    "001111"=>
                        data <= MAT(783 downto 768);
                when    "010000"=>
                        data <= MAT(767 downto 752);
                when    "010001"=>
                        data <= MAT(751 downto 736);
                when    "010010"=>
                        data <= MAT(735 downto 720);
                when    "010011"=>
                        data <= MAT(719 downto 704);
                when    "010100"=>
                        data <= MAT(703 downto 688);
                when    "010101"=>
                        data <= MAT(687 downto 672);
                when    "010110"=>
                        data <= MAT(671 downto 656);
                when    "010111"=>
                        data <= MAT(655 downto 640);
                when    "011000"=>
                        data <= MAT(639 downto 624);
                when    "011001"=>
                        data <= MAT(623 downto 608);
                when    "011010"=>
                        data <= MAT(607 downto 592);
                when    "011011"=>
                        data <= MAT(591 downto 576);
                when    "011100"=>
                        data <= MAT(575 downto 560);
                when    "011101"=>
                        data <= MAT(559 downto 544);
                when    "011110"=>
                        data <= MAT(543 downto 528);
                when    "011111"=>
                        data <= MAT(527 downto 512);
                when    "100000"=>
                        data <= MAT(511 downto 496);
                when    "100001"=>
                        data <= MAT(495 downto 480);
                when    "100010"=>
                        data <= MAT(479 downto 464);
                when    "100011"=>
                        data <= MAT(463 downto 448);
                when    "100100"=>
                        data <= MAT(447 downto 432);
                when    "100101"=>
                        data <= MAT(431 downto 416);
                when    "100110"=>
                        data <= MAT(415 downto 400);
                when    "100111"=>
                        data <= MAT(399 downto 384);
                when    "101000"=>
                        data <= MAT(383 downto 368);
                when    "101001"=>
                        data <= MAT(367 downto 352);
                when    "101010"=>
                        data <= MAT(351 downto 336);
                when    "101011"=>
                        data <= MAT(335 downto 320);
                when    "101100"=>
                        data <= MAT(319 downto 304);
                when    "101101"=>
                        data <= MAT(303 downto 288);
                when    "101110"=>
                        data <= MAT(287 downto 272);
                when    "101111"=>
                        data <= MAT(271 downto 256);
                when    "110000"=>
                        data <= MAT(255 downto 240);
                when    "110001"=>
                        data <= MAT(239 downto 224);
                when    "110010"=>
                        data <= MAT(223 downto 208);
                when    "110011"=>
                        data <= MAT(207 downto 192);
                when    "110100"=>
                        data <= MAT(191 downto 176);
                when    "110101"=>
                        data <= MAT(175 downto 160);
                when    "110110"=>
                        data <= MAT(159 downto 144);
                when    "110111"=>
                        data <= MAT(143 downto 128);
                when    "111000"=>
                        data <= MAT(127 downto 112);
                when    "111001"=>
                        data <= MAT(111 downto 96);
                when    "111010"=>
                        data <= MAT(95 downto 80);
                when    "111011"=>
                        data <= MAT(79 downto 64);
                when    "111100"=>
                        data <= MAT(63 downto 48);
                when    "111101"=>
                        data <= MAT(47 downto 32);
                when    "111110"=>
                        data <= MAT(31 downto 16);
                when    "111111"=>
                        data <= MAT(15 downto 0);
                when others =>
            end case;

    end READ;

    procedure WRITE (
                    signal address :   in std_logic_vector(5 downto 0);
                    signal data :   in std_logic_vector(15 downto 0);
                    signal MAT 	:   out  std_logic_vector(1023 downto 0)
                    ) is
        begin
            case address is
                when    "000000"=>
                        MAT(1023 downto 1008) <= data;
                when    "000001"=>
                        MAT(1007 downto 992) <= data;
                when    "000010"=>  
                        MAT(991 downto 976) <= data;
                when    "000011"=>
                        MAT(975 downto 960) <= data;
                when    "000100"=>
                        MAT(959 downto 944) <= data;
                when    "000101"=>
                        MAT(943 downto 928) <= data;
                when    "000110"=>
                        MAT(927 downto 912) <= data;
                when    "000111"=>
                        MAT(911 downto 896) <= data;
                when    "001000"=>
                        MAT(895 downto 880) <= data;
                when    "001001"=>
                        MAT(879 downto 864) <= data;
                when    "001010"=>
                        MAT(863 downto 848) <= data;
                when    "001011"=>
                        MAT(847 downto 832) <= data;
                when    "001100"=>
                        MAT(831 downto 816) <= data;
                when    "001101"=>
                        MAT(815 downto 800) <= data;
                when    "001110"=>
                        MAT(799 downto 784) <= data;
                when    "001111"=>
                        MAT(783 downto 768) <= data;
                when    "010000"=>
                        MAT(767 downto 752) <= data;
                when    "010001"=>
                        MAT(751 downto 736) <= data;
                when    "010010"=>
                        MAT(735 downto 720) <= data;
                when    "010011"=>
                        MAT(719 downto 704) <= data;
                when    "010100"=>
                        MAT(703 downto 688) <= data;
                when    "010101"=>
                        MAT(687 downto 672) <= data;
                when    "010110"=>
                        MAT(671 downto 656) <= data;
                when    "010111"=>
                        MAT(655 downto 640) <= data;
                when    "011000"=>
                        MAT(639 downto 624) <= data;
                when    "011001"=>
                        MAT(623 downto 608) <= data;
                when    "011010"=>
                        MAT(607 downto 592) <= data;
                when    "011011"=>
                        MAT(591 downto 576) <= data;
                when    "011100"=>
                        MAT(575 downto 560) <= data;
                when    "011101"=>
                        MAT(559 downto 544) <= data;
                when    "011110"=>
                        MAT(543 downto 528) <= data;
                when    "011111"=>
                        MAT(527 downto 512) <= data;
                when    "100000"=>
                        MAT(511 downto 496) <= data;
                when    "100001"=>
                        MAT(495 downto 480) <= data;
                when    "100010"=>
                        MAT(479 downto 464) <= data;
                when    "100011"=>
                        MAT(463 downto 448) <= data;
                when    "100100"=>
                        MAT(447 downto 432) <= data;
                when    "100101"=>
                        MAT(431 downto 416) <= data;
                when    "100110"=>
                        MAT(415 downto 400) <= data;
                when    "100111"=>
                        MAT(399 downto 384) <= data;
                when    "101000"=>
                        MAT(383 downto 368) <= data;
                when    "101001"=>
                        MAT(367 downto 352) <= data;
                when    "101010"=>
                        MAT(351 downto 336) <= data;
                when    "101011"=>
                        MAT(335 downto 320) <= data;
                when    "101100"=>
                        MAT(319 downto 304) <= data;
                when    "101101"=>
                        MAT(303 downto 288) <= data;
                when    "101110"=>
                        MAT(287 downto 272) <= data;
                when    "101111"=>
                        MAT(271 downto 256) <= data;
                when    "110000"=>
                        MAT(255 downto 240) <= data;
                when    "110001"=>
                        MAT(239 downto 224) <= data;
                when    "110010"=>
                        MAT(223 downto 208) <= data;
                when    "110011"=>
                        MAT(207 downto 192) <= data;
                when    "110100"=>
                        MAT(191 downto 176) <= data;
                when    "110101"=>
                        MAT(175 downto 160) <= data;
                when    "110110"=>
                        MAT(159 downto 144) <= data;
                when    "110111"=>
                        MAT(143 downto 128) <= data;
                when    "111000"=>
                        MAT(127 downto 112) <= data;
                when    "111001"=>
                        MAT(111 downto 96) <= data;
                when    "111010"=>
                        MAT(95 downto 80) <= data;
                when    "111011"=>
                        MAT(79 downto 64) <= data;
                when    "111100"=>
                        MAT(63 downto 48) <= data;
                when    "111101"=>
                        MAT(47 downto 32) <= data;
                when    "111110"=>
                        MAT(31 downto 16) <= data;
                when    "111111"=>
                        MAT(15 downto 0) <= data;
                when others =>
            end case;

    end WRITE;
begin
    

	    -- Processamento da ULA baseado no opcode


        process(oe_n, ce_n, we_n, clk, rst, data, address, intr)
        begin
                if rising_edge(clk) then
                        if rst = '1' then
                                intr <= '0';
                        end if;

                        if we_n = '0' and ce_n = '1' then       --Escrita
                                data <= (others => 'Z');
                                WRITE(address(5 downto 0), data, MATRIX);
                              report "A: " & to_string(MATRIX(1023 downto 768));
                              report "B: " & to_string(MATRIX(767 downto 512));
                              report "C: " & to_string(MATRIX(511 downto 256));
                              report "address: " & to_string(address(5 downto 0));
                              report "data: " & to_string(data);
                        elsif oe_n = '0' and ce_n = '1' then    --Leitura
                                READ(address(5 downto 0), data, MATRIX);
                        elsif ce_n = '0' then                   --Operações


                                case MATRIX(15 downto 0) is  --Se a porção dos últimos 16 bits da matriz, na zona de controle, for:

                                        when "0000000000000000"=>--Soma de A, B e salva no C.
                                                SOMA(MATRIX(1023 downto 768), MATRIX(767 downto 512), MATRIX(511 downto 256)); --ADD A, B, GUARDA C
                                                                             
                                        when "0000000000000001"=>                              
                                                SUB(MATRIX(1023 downto 768), MATRIX(767 downto 512), MATRIX(511 downto 256));
                                        when "0000000000000010"=>                              
                                                MUL(MATRIX(1023 downto 768), MATRIX(767 downto 512), MATRIX(511 downto 256));  --MUL A, B, GUARDA C
                                        when "0000000000000011"=>                              
                                                MAC(MATRIX(1023 downto 768), MATRIX(767 downto 512), MATRIX(511 downto 256));                 
                                        when "0000000000000100"=>                                                              --Fill
                                                case MATRIX (31 downto 16) is
                                                        when "0000000000000000"=>
                                                                FILL(MATRIX(1023 downto 768), data);                            --A
                                                        when "0000000000000001"=>
                                                                FILL(MATRIX(767 downto 512), data);                             --B
                                                        when "0000000000000010"=>   
                                                                FILL(MATRIX(511 downto 256), data);                             --C
                                                        when others =>
                                                                null;
                                                end case;
                                        when "0000000000000101"=>                              
                                                case MATRIX (31 downto 16) is
                                                        when "0000000000000000"=>
                                                                ID(MATRIX(1023 downto 768), data);      --ID A
                                                        when "0000000000000001"=>
                                                                ID(MATRIX(767 downto 512), data);       --ID B
                                                        when "0000000000000010"=>   
                                                                ID(MATRIX(511 downto 256), data);       --ID C
                                                        when others =>
                                                                null;
                                                end case;
                                        
                                        when others =>
                                                null;
                                end case;
                                intr <= '1';
                        end if;
                end if;
        end process;

end architecture reg;




