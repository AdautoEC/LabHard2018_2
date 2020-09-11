vcom FFD.vhd
vcom vga_raster_traffic.vhd
vcom vga_teste.vhd
vsim vga_teste

add wave clk
add wave swt_sentido
add wave btn_confirma
add wave btn_esq_up
add wave btn_dir_down
add wave confirmacao
add wave esq_up
add wave dir_down
add wave up
add wave down
add wave esq
add wave dir
add wave linha
add wave coluna


force clk '0' 0ps, '1' 50ps -repeat 100ps -cancel 1us
force swt_sentido '0' 0ps, '1' 4000ps 
force btn_confirma '1' 0ps, '0' 2000ps 
force btn_esq_up '1' 0ps, '0' 2000ps 
force btn_dir_down '1' 0ps, '0' 2000ps 

run -all