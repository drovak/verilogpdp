#include <stdio.h>
#include <stdlib.h>
#include <memory>
#include <verilated.h>
#include <unistd.h>
#include <time.h>
#include "verilated_vcd_c.h"
#include "Vtop.h"
#include "control.h"

vluint64_t main_time = 0;

int did_print = 0;
int did_hlt_msg = 0;

const char *bin_name = NULL;
int start_addr = 0200;
int init_sr = 0200;
unsigned long long int runtime = -1;
unsigned long long int logtime = -1;

clock_t start, end;

int main(int argc, char** argv, char** env) {
    start = clock();
    if (false && argc && argv && env) {}

    Verilated::debug(0);
    Verilated::randReset(2);
    Verilated::traceEverOn(true);
    Verilated::commandArgs(argc, argv);

    Vtop *top = new Vtop;
#if VM_TRACE
	VerilatedVcdC* tfp = nullptr;
	const char* flag = Verilated::commandArgsPlusMatch("trace");
    if (flag && 0 == strcmp(flag, "+trace")) {
		tfp = new VerilatedVcdC;
		top->trace(tfp, 99);
		tfp->open("logs/trace.vcd");
	}
#endif

    int opt;
    while ((opt = getopt(argc, argv, "b:s:r:t:l:")) != -1) {
        switch (opt) {
        case 'b': // bin file to load
            bin_name = optarg;
            break;
        case 's': // starting address
            sscanf(optarg, "%o", &start_addr);
            break;
        case 'r': // initial switch register
            sscanf(optarg, "%o", &init_sr);
            break;
        case 't': // max runtime
            sscanf(optarg, "%llu", &runtime);
            break;
        case 'l': // time to start logging
            sscanf(optarg, "%llu", &logtime);
            break;
        default: break;
        }
    }

    if (bin_name == NULL) {
        printf("error: no bin file specified\n");
        exit(-1);
    }
    if (start_addr < 0 || start_addr > 07777) {
        printf("error: invalid starting address\n");
        exit(-1);
    }
    if (init_sr < 0 || init_sr > 07777) {
        printf("error: invalid switch register setting\n");
        exit(-1);
    }
    if (runtime < 0)
        printf("testing %s with SA=%o and SR=%o\n", bin_name, start_addr, init_sr);
    else
        printf("testing %s with SA=%o and SR=%o for %llu ns\n", bin_name, start_addr, init_sr, runtime);
#if VM_TRACE
    if (logtime > 0)
        printf("logging enabled at %llu ns\n", logtime);
    else
        printf("logging enabled at 0 ns\n");
#else
    printf("logging disabled\n");
#endif

    top->clk = 0;
	top->rst = 1;
	top->start = 0;
	top->stop = 0;
	top->cont = 0;
	top->dep = 0;
	top->dfsr = 0;
	top->exam = 0;
	top->ifsr = 0;
	top->load_addr = 0;
	top->sing_inst = 0;
	top->sing_step = 0;
	top->sr = 0; 
	top->step = 0;

	top->eval();

	// set core to zero
	for (int i = 0; i < 32768; i++)
		top->top__DOT__pdp__DOT__core_mem__DOT__ram[i] = 0;
	
	VL_PRINTF("starting simulation...\n");
    uint64_t i = 0;

    while ((runtime < 0) || (main_time < runtime)) {
		// disable reset after a bit
		if (main_time > 5000)
			top->rst = 0;

		// and switch stop off
        if (!top->run)
			top->stop = 0;

		// default switch positions
		top->load_addr = 0;
		top->dep = 0;
		top->exam = 0;
        if (top->run) {
            top->start = 0;
            top->cont = 0;
        }

        int run_status;

        run_status = do_test(top, bin_name, start_addr, init_sr, main_time, 15000);

        // print status when halted
        if (main_time > 36000 && !top->run && !did_hlt_msg) {
            did_hlt_msg = 1;
            VL_PRINTF("\nhalted at time %" VL_PRI64 "d ns\n", main_time);
            printf("pc: %o lac: %o ma: %o mb: %o mq: %o sc: %o if: %o df: %o\n\n", 
                top->pc, top->lac, top->ma, top->mb, top->mq, top->sc, top->instf, top->dataf);
            break;
        } else if (top->run) {
            did_hlt_msg = 0;
        }

        // has a character been sent?
		if (!top->top__DOT__pdp__DOT__ef02__DOT__load && !did_print) {
			did_print = 1;
            if ((top->lac & 0177) == 07) 
                printf("\033[31;1m[ding!]\033[0m"); // bell
            printf("%c", top->lac & 0177); // print it
			fflush(stdout);
		} else if (top->top__DOT__pdp__DOT__ef02__DOT__load) {
			did_print = 0;
		}

		for (int clk = 0; clk < 2; clk++)
		{
			main_time += 5;
#if VM_TRACE
			if (tfp && (main_time > logtime))
				tfp->dump(10*i + 5*clk);
#endif
			top->clk = !top->clk;
			top->eval();
		}
        i++;
    }

#if VM_TRACE
	if (tfp)
		tfp->close();
#endif

    top->final();

    end = clock();
    double elapsed = (double) (end - start) / CLOCKS_PER_SEC;
    double speed = (double) main_time / elapsed;

    VL_PRINTF("\nexiting at time %" VL_PRI64 "d ns\n", main_time);
    VL_PRINTF("elapsed time: %.1f seconds ", elapsed);
    if (speed >= 1e9)
        VL_PRINTF("(%.1f seconds per second)\n", speed / 1e9);
    else if (speed >= 1e6)
        VL_PRINTF("(%.1f milliseconds per second)\n", speed / 1e6);
    else if (speed >= 1e3)
        VL_PRINTF("(%.1f microseconds per second)\n", speed / 1e3);
    else
        VL_PRINTF("(%.1f nanoseconds per second)\n", speed);

    exit(0);
}
