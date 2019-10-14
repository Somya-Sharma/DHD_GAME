onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+instr_screen -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.instr_screen xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {instr_screen.udo}

run -all

endsim

quit -force
