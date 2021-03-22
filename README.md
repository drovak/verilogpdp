# verilogpdp
Synthesizable Verilog implementations from original schematics of Digital
Equipment Corporation PDP series of computers

Currently features a PDP-8/I implementation. Very much a work-in-progress. 

## Changelog:  
- 20210322 KVO: Added TC08/TU55 support. Now boots OS/8!!
- 20210302 KVO: Added TTY input support. Currently configured as loopback for
test purposes. Slowed baud rate clock to 230.4k. Added "ctrl-e" to print status
of PDP-8 while running. Now runs FOCAL-69! Added support for counting machine cycles 
and support for halting after some number of machine cycles.
- 20210227 KVO: Passing CPU and EAE MAINDECs; see results in `successful_run.txt`.
Cleaned up Makefile a bit.
- 20210226 KVO: Design speed is back to 100 MHz to lengthen minimum pulses and
to make glitch detection easier for the SN7474 model. SN7474 captures data from
two master clock cycles previous, and requires two consecutive asserted signals
on the asynchronous clear and preset inputs to activate. Appears to pass 
MAINDECs 8I-D01C, 8I-D02B, 8I-D0AA, 8I-D0BA, 08-D04B, 08-D05B, and 08-D07B.
- 20210224 KVO: Removed power pins from M310. Changed default M452 baudrate to
significantly higher value to speed up simulation. Fixed `EAE_RUN` signal in
main netlist so that EAE now starts correctly. SN7474 now captures data from
previous clock edge to fix edge case of data/clock changing simultaneously.
Added command line parser to `sim_main.cpp` along with timing information. 
Now can start logging at a specific time to reduce log file size and increase
simulation speed. Changed design clock speed from 100 MHz to 20 MHz to further
increase simulation speed (not well tested yet).
- 20210222 KVO: Added TTY output support. Passes MAINDEC-8I-D01C and
MAINDEC-8I-D02B! Also prints "hello world" after running both MAINDECs
for a bit. Cleaned up test suite. Extended power-on reset pulse. Refactored
test control code.

## Requirements:
Verilator to simulate the model, and optionally GTKWave to view the results.

## Usage:
To boot OS/8 with the TC08/TU55, just type `make`. After several minutes, a dot
prompt will appear. It's interactive, but be forewarned: the simulation is typically
around 1/1000 of original speed. To print the directory listing takes about an hour
on my computer.

Other targets are available as well; read the `Makefile` to see what you can run.
When running with logging, a log file will appear under `logs`. Logging can increase
runtime and generate very large files, so beware!

## Acknowledgements:
A big *thank you* to Vince Slyngstad, for his high-quality redrawn schematics,
and patience through debugging the model. This project would not be possible
without him and his tireless efforts. The schematic used for this model so far
comes from http://svn.so-much-stuff.com/svn/trunk/Eagle/projects/DEC/PDP8I/

His site has many other wonderful nuggets of information, so please check it
out: https://so-much-stuff.com/pdp8/index.php
