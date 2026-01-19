########################################
## Clock
########################################
create_clock -name sys_clk -period 20.000 [get_ports clk]

########################################
## Reset (asynchronous)
########################################
set_false_path -from [get_ports rst]

########################################
## Control signals (not timing-critical)
########################################
set_false_path -from [get_ports if_flush]
set_false_path -from [get_ports stall]

########################################
## Asynchronous / bidirectional IO
########################################
set_false_path -from [get_ports i2c_sda]
set_false_path -to   [get_ports i2c_sda]

set_false_path -from [get_ports i2c_scl]
set_false_path -to   [get_ports i2c_scl]

########################################
## UART (output only)
########################################
set_false_path -to [get_ports txd]
set_false_path -to [get_ports uart_tx_busy]
set_false_path -to [get_ports uart_tx_data_ready]

########################################
## Status / error outputs
########################################
set_false_path -to [get_ports {mem_err[*]}]
set_false_path -to [get_ports i2c_ready]

########################################
## CPU pblock constraint
########################################
create_pblock pblock_cpu
add_cells_to_pblock [get_pblocks pblock_cpu] \
    [get_cells -hierarchical *u_top_dut*]

resize_pblock [get_pblocks pblock_cpu] \
    -add {SLICE_X0Y0:SLICE_X50Y100}
