########################################
## Clock
########################################
create_clock -name sys_clk -period 10.000 [get_ports clk]

########################################
## Reset
########################################
set_false_path -from [get_ports rst]

########################################
## Asynchronous IO
########################################
set_false_path -from [get_ports i2c_sda]
set_false_path -to   [get_ports i2c_sda]
set_false_path -from [get_ports i2c_scl]
set_false_path -to   [get_ports i2c_scl]

set_false_path -to [get_ports txd]
set_false_path -to [get_ports mem_err]

create_pblock pblock_cpu
add_cells_to_pblock [get_pblocks pblock_cpu] [get_cells -hierarchical *u_top_dut*]
resize_pblock [get_pblocks pblock_cpu] -add {SLICE_X0Y0:SLICE_X50Y100}
