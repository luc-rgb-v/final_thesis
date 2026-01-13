puts "====== Generating DMEM IP ======"

set IP_NAME dmem_ip

# -------------------------------------------------
# 1. Create IP if needed
# -------------------------------------------------
set ip_obj [get_ips -quiet $IP_NAME]

if {$ip_obj eq ""} {
    puts "Creating IP: $IP_NAME"
    create_ip -name blk_mem_gen \
              -vendor xilinx.com \
              -library ip \
              -version 8.4 \
              -module_name $IP_NAME
    set ip_obj [get_ips $IP_NAME]
} else {
    puts "=========== IP $IP_NAME already exists ==========="
}

# -------------------------------------------------
# 2. Configure IP
# -------------------------------------------------
set_property -dict [list \
  CONFIG.Byte_Size {8} \
  CONFIG.Coe_File {false} \
  CONFIG.Fill_Remaining_Memory_Locations {true} \
  CONFIG.Load_Init_File {false} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Write_Depth_A {256} \
  CONFIG.Write_Width_A {32} \
] $ip_obj

# -------------------------------------------------
# 3. Generate IP (this creates XCI + all outputs)
# -------------------------------------------------
generate_target all $ip_obj

# -------------------------------------------------
# 4. Now safely get the XCI file
# -------------------------------------------------
set ip_xci [get_files -of_objects $ip_obj]

if {$ip_xci eq ""} {
    error "======= Could not find XCI file for IP $IP_NAME ======="
}

puts "XCI file: $ip_xci"

# -------------------------------------------------
# 5. Export IP (optional but good practice)
# -------------------------------------------------
catch { config_ip_cache -export $ip_obj }

export_ip_user_files \
  -of_objects $ip_xci \
  -no_script -sync -force -quiet

puts "======= DMEM IP generated successfully! ======="
