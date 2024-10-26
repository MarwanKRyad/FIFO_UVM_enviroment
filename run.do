vlib work
vlog -f src_files.list +define+SIM  +cover -covercells
vsim -voptargs=+acc work.top -cover 
add wave /top/inter_type/*
coverage save FIFO.ucdb -onexit 
run -all
