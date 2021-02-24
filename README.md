# verilogpdp
Synthesizable Verilog implementations from original schematics of Digital
Equipment Corporation PDP series of computers

## Changelog:  
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

Currently features an incomplete PDP-8/I implementation. Very much a
work-in-progress. 

## Requirements:
Verilator to simulate the model, and GTKWave to view the results.

## Usage:
Just type `make` within the `pdp8i` directory to build and run the model. Then,
open the results under `logs` with GTKWave. You may also type `make notrace` to
prevent logging, which slows down the model tremendously and can generate,
given enough time, some quite large files. It takes about 5 minutes to run the
second MAINDEC until the bell sounds, indicating 40 successful program loops.
The resulting log file was 2 GB. I recommend running with `notrace` if you don't
need to log every single signal, and if you do need to log every signal, I'd
recommend running for less time. The `Makefile` controls which tests are run,
so you may wish to pick which one to run beforehand.

## Acknowledgements:
A big *thank you* to Vince Slyngstad, for his high-quality redrawn schematics,
and patience through debugging the model. This project would not be possible
without him and his tireless efforts. The schematic used for this model so far
comes from http://svn.so-much-stuff.com/svn/trunk/Eagle/projects/DEC/PDP8I/

His site has many other wonderful nuggets of information, so please check it
out: https://so-much-stuff.com/pdp8/index.php
