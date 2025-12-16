# scripts/create_project.tcl
#
# Disable board repository scanning (optional)
# set_param board.repoPaths {}
#
# ===== Project settings =====
set proj_name  vivado
set proj_dir   "C:/Github/final_thesis/hw/vivado"
set part_name  xc7z020clg484-1
set board_part "xilinx.com:zc702:part0:1.4"

# ===== Source directories =====
set RTL_DIR "D:/Github/final_thesis/hw/rtl"
set TB_DIR  "D:/Github/final_thesis/hw/tb"
set IP_DIR  "D:/Github/final_thesis/hw/ip"

# ===== Create project =====
create_project $proj_name $proj_dir -part $part_name -force

# Board definition (ZC702)
set_property board_part $board_part [current_project]

# IP definition
set_property ip_repo_paths %IP_DIR [current_project]

# Refresh IP catalog (optional but clean)
update_ip_catalog

# ===== Add RTL sources =====
add_files -fileset sources_1 [glob $RTL_DIR/*.v]
update_compile_order -fileset sources_1
set_property top $RTL_TOP [get_filesets sources_1]

# ===== Add IP (.xci files) =====
set ip_files [glob -nocomplain $IP_DIR/**/*.xci]
if {[llength $ip_files] > 0} {
    add_files -fileset sources_1 $ip_files
    generate_target all [get_files $ip_files]
}

# ===== Add testbench =====
add_files -fileset sim_1 [glob $TB_DIR/*.v]
update_compile_order -fileset sim_1
set_property top $TB_TOP [get_filesets sim_1]


# ===== Simulation =====
open_wave_database
log_wave -r *
launch_simulation
run all
# Open GUI after creation
start_gui
