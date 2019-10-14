onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib lives_opt

do {wave.do}

view wave
view structure
view signals

do {lives.udo}

run -all

quit -force
