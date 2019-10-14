# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.cache/wt [current_project]
set_property parent.project_path C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property ip_repo_paths c:/Users/Aamir/Downloads/DarakSir/HLS/HLS_LED_CONTROLLER [current_project]
set_property ip_output_repo c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files C:/Users/Aamir/Desktop/project_versions/basePro_bramS/GameScreen.coe
add_files C:/Users/Aamir/Desktop/project_versions/basePro_bramS/optimized_screen.coe
add_files C:/Users/Aamir/Desktop/project_versions/basePro_bramS/full_intro.coe
add_files C:/Users/Aamir/Desktop/project_versions/basePro_bramS/full_intro_eldGuys.coe
add_files C:/Users/Aamir/Desktop/project_versions/basePro_bramS/somya_instr.coe
add_files C:/Users/Aamir/Desktop/project_versions/basePro_bramS/lives.coe
add_files C:/Users/Aamir/Desktop/project_versions/basePro_bramS/optimized_screen_v2.coe
add_files C:/Users/Aamir/Desktop/project_versions/basePro_bramS/game_over.coe
add_files C:/Users/Aamir/Desktop/project_versions/basePro_bramS/Counting_0_to_9.coe
add_files C:/Users/Aamir/Desktop/project_versions/basePro_bramS/full_intro_eldGuys1.coe
add_files C:/Users/Aamir/Desktop/project_versions/basePro_bramS/somya_instr1.coe
add_files c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/full_intro_eldGuys1.coe
add_files c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/coe/somya_instr1.coe
add_files c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/coe/lives.coe
add_files c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/coe/Counting_0_to_9.coe
add_files c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/coe/optimized_screen_v2.coe
add_files c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/coe/game_over.coe
add_files c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/coe/full_intro_eldGuys1.coe
add_files c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/coe/full_intro_eldGuys.coe
read_verilog -library xil_defaultlib {
  C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/new/ball_on_module.v
  C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/new/bin2bcd.v
  C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/new/boundary_ball.v
  C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/new/bram_Opt.v
  C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/new/debounce.v
  C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/new/freq_div.v
  C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/new/game.v
  C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/new/give_directions.v
  C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/new/life.v
  C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/new/moosze.v
  C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/new/player_on_module.v
  C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/new/vga_ctrl.v
  C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/new/top.v
}
read_ip -quiet c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0.xci
set_property used_in_implementation false [get_files -all c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_ooc.xdc]

read_ip -quiet c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci
set_property used_in_implementation false [get_files -all c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]

read_ip -quiet c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/instr_screen/instr_screen.xci
set_property used_in_implementation false [get_files -all c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/instr_screen/instr_screen_ooc.xdc]

read_ip -quiet c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/lives/lives.xci
set_property used_in_implementation false [get_files -all c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/lives/lives_ooc.xdc]

read_ip -quiet c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/blk_mem_gen_2/blk_mem_gen_2.xci
set_property used_in_implementation false [get_files -all c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/blk_mem_gen_2/blk_mem_gen_2_ooc.xdc]

read_ip -quiet c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/blk_mem_gen_1/blk_mem_gen_1.xci
set_property used_in_implementation false [get_files -all c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/blk_mem_gen_1/blk_mem_gen_1_ooc.xdc]

read_ip -quiet c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/blk_mem_gen_3/blk_mem_gen_3.xci
set_property used_in_implementation false [get_files -all c:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/sources_1/ip/blk_mem_gen_3/blk_mem_gen_3_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/constrs_1/new/cons.xdc
set_property used_in_implementation false [get_files C:/Users/Aamir/Desktop/project_versions/basePro_bramS2/basePro_bramS2.srcs/constrs_1/new/cons.xdc]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top top -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
