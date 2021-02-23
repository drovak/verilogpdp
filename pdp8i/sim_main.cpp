#include <stdlib.h>
#include <memory>
#include <verilated.h>
#include "verilated_vcd_c.h"
#include "Vtop.h"
#include "control.h"

vluint64_t main_time = 0;

int did_print = 0;
int did_hlt_msg = 0;

int main(int argc, char** argv, char** env) {
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
#if VM_TRACE
    while (main_time < 236000000)
#else
	for (;;)
#endif
	{
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

        //run_status = do_test(top, "maindec/maindec-8i-d0aa-pb.bin", 0200, 05000, main_time, 15000);
        run_status = do_test(top, "maindec/maindec-8i-d01c-pb.bin", 0144, 07777, main_time, 15000);
        if (main_time == 41000) {
            if (!top->run && top->pc == 0147 && !top->lac) {
                printf("LAC clear, continuing...\n");
                top->cont = 1;
            } else {
                printf("test failed\n");
            }
        }

        run_status = do_test(top, "maindec/maindec-8i-d02b-pb.bin", 0201, 07777, main_time, 3400000);
        if (run_status == WAS_HALTED) 
            printf("test failed\n");
        else if (run_status == WAS_RUNNING)
            printf("test passed\n");

        run_status = do_test(top, "hello/hello.bin", 0200, 07777, main_time, 220000000);
        if (run_status == WAS_HALTED) 
            printf("test failed\n");
        else if (run_status == WAS_RUNNING)
            printf("test passed\n");

        // print status when halted
        if (main_time > 36000 && !top->run && !did_hlt_msg) {
            did_hlt_msg = 1;
            VL_PRINTF("\nhalted at time %" VL_PRI64 "d\n", main_time);
            printf("pc: %o lac: %o ma: %o mb: %o mq: %o sc: %o if: %o df: %o\n\n", 
                top->pc, top->lac, top->ma, top->mb, top->mq, top->sc, top->instf, top->dataf);
            if (main_time > 220045000)
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
			if (tfp)
				tfp->dump(10*i + 5*clk);
#endif
			top->clk = !top->clk;
			top->eval();
		}
        i++;
    }

    VL_PRINTF("\nexiting at time %" VL_PRI64 "d\n", main_time);

#if VM_TRACE
	if (tfp)
		tfp->close();
#endif

    top->final();

    exit(0);
}
