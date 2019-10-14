onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib instr_screen_opt

do {wave.do}

view wave
view structure
view signals

do {instr_screen.udo}

run -all

quit -force
