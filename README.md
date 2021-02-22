# verilogpdp
Synthesizable Verilog implementations from original schematics of Digital Equipment Corporation PDP series of computers

Currently features an incomplete PDP-8/I implementation. Very much a work-in-progress. 
No TTY interface implemented yet, among other things.

Requirements: Verilator to simulate the model, and GTKWave to view the results.

Just type `make` within the `pdp8i` directory to build and run the model. Then, open the results under `logs` with GTKWave.
