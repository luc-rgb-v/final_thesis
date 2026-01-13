# Directory where this TCL file lives (…/scripts)
set SCRIPT_DIR [file dirname [file normalize [info script]]]

# Project root (…/new_riscv)
set ROOT_DIR   [file normalize "$SCRIPT_DIR/.."]

# Project name and directory
set PROJ_NAME mem_stage
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
# Create fresh project in new_riscv/mem_stage
# -------------------------------------------------
create_project $PROJ_NAME $PROJ_DIR -part xc7z020clg484-1

set_property board_part xilinx.com:zc702:part0:1.4 [current_project]

# -------------------------------------------------
# Add RTL + IP + MEM
# -------------------------------------------------
set IP_SCRIPT "$SCRIPT_DIR/gen_dmem_ip_sim.tcl"
source $IP_SCRIPT

add_files -norecurse [list \
    $ROOT_DIR/src/defines.vh \
    $ROOT_DIR/src/dmem.v \
    $ROOT_DIR/SRC/dmem_wrab.v \
    $ROOT_DIR/SRC/mem_stage.v \
    $ROOT_DIR/SRC/store_cvt.v \
    $ROOT_DIR/SRC/load_cvt.v \
]

update_compile_order -fileset sources_1

# -------------------------------------------------
# Export IP
# -------------------------------------------------
#export_ip_user_files -of_objects [get_ips imem_ip] -force -quiet

# -------------------------------------------------
# Simulation files
# -------------------------------------------------
set_property SOURCE_SET sources_1 [get_filesets sim_1]

add_files -fileset sim_1 -norecurse [list \
    $ROOT_DIR/src/defines.vh \
    $ROOT_DIR/tb/tb_mem_stage.v \
]

update_compile_order -fileset sim_1
set_property top tb_mem_stage [get_filesets sim_1]

# -------------------------------------------------
# Run simulation
# -------------------------------------------------
launch_simulation
