# verilogpdp
Synthesizable Verilog implementations from original schematics of Digital Equipment Corporation PDP series of computers

Currently features an incomplete PDP-8/I implementation. Very much a work-in-progress. 
No TTY interface implemented yet, among other things.

Requirements: Verilator to simulate the model, and GTKWave to view the results.

Just type `make` within the `pdp8i` directory to build and run the model. Then, open the results under `logs` with GTKWave.

A big *thank you* to Vince Slyngstad, for his high-quality redrawn schematics, and patience through
debugging the model. This project would not be possible without him and his tireless efforts. The schematic
used for this model so far comes from http://svn.so-much-stuff.com/svn/trunk/Eagle/projects/DEC/PDP8I/

His site has many other wonderful nuggets of information, so please check it out: https://so-much-stuff.com/pdp8/index.php
