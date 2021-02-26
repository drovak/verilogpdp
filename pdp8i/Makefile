######################################################################
#
# DESCRIPTION: Verilator Example: Small Makefile
#
# This calls the object directory makefile.  That allows the objects to
# be placed in the "current directory" which simplifies the Makefile.
#
# This file ONLY is placed under the Creative Commons Public Domain, for
# any use, without warranty, 2020 by Wilson Snyder.
# SPDX-License-Identifier: CC0-1.0
#
######################################################################
# Check for sanity to avoid later confusion

ifneq ($(words $(CURDIR)),1)
 $(error Unsupported: GNU Make cannot build in directories containing spaces, build elsewhere: '$(CURDIR)')
endif

######################################################################
# Set up variables

# If $VERILATOR_ROOT isn't in the environment, we assume it is part of a
# package install, and verilator is in your path. Otherwise find the
# binary relative to $VERILATOR_ROOT (such as when inside the git sources).
ifeq ($(VERILATOR_ROOT),)
VERILATOR = verilator
else
export VERILATOR_ROOT
VERILATOR = $(VERILATOR_ROOT)/bin/verilator
endif

VERILATOR_FLAGS =
# Generate C++ in executable form
VERILATOR_FLAGS += -cc --exe
# Generate makefile dependencies (not shown as complicates the Makefile)
#VERILATOR_FLAGS += -MMD
# Optimize
VERILATOR_FLAGS += -Os -x-assign 0 --unroll-count 90000
# Multithreading doesn't really seem to improve the speed...
#VERILATOR_FLAGS += --threads 4
# Warn abount lint issues; may not want this on less solid designs
VERILATOR_FLAGS += -Wall
# Make waveforms
#VERILATOR_FLAGS += --trace
# Run Verilator in debug mode
#VERILATOR_FLAGS += --debug
# Add this trace to get a backtrace in gdb
#VERILATOR_FLAGS += --gdbbt

# Input files for Verilator
VERILATOR_INPUT = -f input.vc top.v -y modules sim_main.cpp control.cpp

# Test arguments for model
#TEST_ARGS = -b maindec/maindec-8i-d01c-pb.bin -s 0147 -r 07777 -t 3400000
#TEST_ARGS = -b maindec/maindec-8i-d02b-pb.bin -s 0201 -r 07777 -t 2200000000
TEST_ARGS = -b maindec/maindec-08-d04b-pb.bin -s 0200 -r 04000 -t 15000000000
#TEST_ARGS = -b maindec/maindec-8i-d0aa-pb.bin -s 0200 -r 05000 -t 29533500000
#TEST_ARGS = -b maindec/maindec-8i-d0ba-pb.bin -s 0201 -r 00040 -t 2000000000 -l 1130000000
#TEST_ARGS = -b nmi_test/nmi_test.bin -s 0200 -t 100000

#EXE = numactl -m 0 -C 0,1 -- obj_dir/Vtop
EXE = obj_dir/Vtop

######################################################################
default: run

run:
	@echo
	@echo "-- VERILATE ----------------"
	$(VERILATOR) $(VERILATOR_FLAGS) --trace $(VERILATOR_INPUT)

	@echo
	@echo "-- BUILD -------------------"
	$(MAKE) -j -C obj_dir -f ../Makefile_obj

	@echo
	@echo "-- RUN ---------------------"
	@rm -rf logs
	@mkdir -p logs
	$(EXE) +trace $(TEST_ARGS)

	@echo
	@echo "-- DONE --------------------"
	@echo "To see waveforms, open vlt_dump.vcd in a waveform viewer"
	@echo

######################################################################
notrace:
	@echo
	@echo "-- VERILATE ----------------"
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILATOR_INPUT)

	@echo
	@echo "-- BUILD -------------------"
	$(MAKE) -j -C obj_dir -f ../Makefile_obj

	@echo
	@echo "-- RUN ---------------------"
	$(EXE) $(TEST_ARGS)

	@echo
	@echo "-- DONE --------------------"
	@echo

######################################################################
test:
	@echo
	@echo "-- VERILATE ----------------"
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILATOR_INPUT)

	@echo
	@echo "-- BUILD -------------------"
	$(MAKE) -j -C obj_dir -f ../Makefile_obj

	@echo
	@echo "-- RUN ---------------------"
	#$(EXE) -b maindec/maindec-8i-d01c-pb.bin -s 0147 -r 07777 -t 3400000
	#$(EXE) -b maindec/maindec-8i-d02b-pb.bin -s 0201 -r 07777 -t 220000000
	#$(EXE) -b maindec/maindec-8i-d0aa-pb.bin -s 0200 -r 05000 -t 29533500000
	#$(EXE) -b maindec/maindec-8i-d0ba-pb.bin -s 0201 -r 00040 -t 520000000000
	#$(EXE) -b maindec/maindec-08-d02b-pb.bin -s 0200 -r 05000 -t 200000000
	#$(EXE) -b maindec/maindec-08-d02b-pb.bin -s 02000 -r 05000 -t 600000000
	#$(EXE) -b maindec/maindec-08-d04b-pb.bin -s 0200 -r 04000 -t 15000000000
	$(EXE) -b maindec/maindec-08-d05b-pt.bin -s 0200 -r 04000 -t 25000000000
	$(EXE) -b maindec/maindec-08-d07b-pb.bin -s 037 -r 04000 -t 25000000000


	@echo
	@echo "-- DONE --------------------"
	@echo
######################################################################
# Other targets

show-config:
	$(VERILATOR) -V

maintainer-copy::
clean mostlyclean distclean maintainer-clean::
	-rm -rf obj_dir logs *.log *.dmp *.vpd coverage.dat core
