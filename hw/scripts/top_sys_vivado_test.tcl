# Directory where this TCL file lives (…/scripts)
set SCRIPT_DIR [file dirname [file normalize [info script]]]

# Project root (…/new_riscv)
set ROOT_DIR   [file normalize "$SCRIPT_DIR/.."]

# Project name and directory
set PROJ_NAME top_sys_vivado
set PROJ_DIR  [file normalize "$ROOT_DIR/$PROJ_NAME"]

# -------------------------------------------------
# Close existing project
# -------------------------------------------------
if {[llength [get_projects -quiet]] != 0} {
    close_project -quiet
}

# -------------------------------------------------
# Remove old project directory completely
# -------------------------------------------------
if {[file exists $PROJ_DIR]} {
    puts "Deleting old project directory: $PROJ_DIR"
    file delete -force $PROJ_DIR
}

# -------------------------------------------------
# Create fresh project in new_riscv/if_stage
# -------------------------------------------------
create_project $PROJ_NAME $PROJ_DIR -part xc7z020clg484-1

set_property board_part xilinx.com:zc702:part0:1.4 [current_project]

set IP_SCRIPT "$SCRIPT_DIR/gen_dmem_ip_sim.tcl"
source $IP_SCRIPT
puts "IP setup done"

add_files -norecurse [list \
    $ROOT_DIR/src/defines.vh \
    $ROOT_DIR/src/dmem.v \
    $ROOT_DIR/src/dmem_wrab.v \
    $ROOT_DIR/src/ex_stage.v \
    $ROOT_DIR/src/forwarding.v \
    $ROOT_DIR/src/i2c_master.v \
    $ROOT_DIR/src/i2c_slave.v \
    $ROOT_DIR/src/id_stage.v \
    $ROOT_DIR/src/if_stage.v \
    $ROOT_DIR/src/imem.v \
    $ROOT_DIR/src/load_cvt.v \
    $ROOT_DIR/src/mem_stage.v \
    $ROOT_DIR/src/registers_file.v \
    $ROOT_DIR/src/store_cvt.v \
    $ROOT_DIR/src/top_system.v \
    $ROOT_DIR/src/uart_rx.v \
    $ROOT_DIR/src/uart_tx.v \
]

add_files -norecurse [list \
    $ROOT_DIR/support/instructions.mem
]

update_compile_order -fileset sources_1

# -------------------------------------------------
# Update new RTL as top
# -------------------------------------------------
#set_property top if_stage [current_fileset]
#update_compile_order -fileset sources_1

# -------------------------------------------------
# Simulation files
# -------------------------------------------------
set_property SOURCE_SET sources_1 [get_filesets sim_1]

add_files -fileset sim_1 -norecurse [list \
    $ROOT_DIR/src/defines.vh \
    $ROOT_DIR/tb/tb_system_top.v \
]

update_compile_order -fileset sim_1
set_property top tb_system_top [get_filesets sim_1]

# -------------------------------------------------
# Run simulation
# -------------------------------------------------
launch_simulation