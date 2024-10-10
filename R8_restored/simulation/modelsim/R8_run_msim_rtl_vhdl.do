transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/re_ro/OneDrive/Documentos/Arquitetura_pratica/Projeto_Final/R8_restored/R8.vhd}

vcom -93 -work work {C:/Users/re_ro/OneDrive/Documentos/Arquitetura_pratica/Projeto_Final/R8_restored/R8.vhd}
vcom -93 -work work {C:/Users/re_ro/OneDrive/Documentos/Arquitetura_pratica/Projeto_Final/R8_restored/R8_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneive -L rtl_work -L work -voptargs="+acc"  R8_tb

add wave *
view structure
view signals
run 4000 ns
