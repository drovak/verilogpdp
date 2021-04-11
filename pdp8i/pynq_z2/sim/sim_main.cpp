#include <memory>
#include <verilated.h>
#include "verilated_vcd_c.h"
#include "Vtop.h"

vluint64_t main_time = 0;

double sc_time_stamp() {
    return main_time;  // Note does conversion to real, to match SystemC
}

int main(int argc, char** argv, char** env) {
    if (false && argc && argv && env) {}

    // Set debug level, 0 is off, 9 is highest presently used
    // May be overridden by commandArgs
    Verilated::debug(0);

    // Randomization reset policy
    // May be overridden by commandArgs
    Verilated::randReset(2);

    // Verilator must compute traced signals
    Verilated::traceEverOn(true);

    // Pass arguments so Verilated code can see them, e.g. $value$plusargs
    // This needs to be called before you create any model
    Verilated::commandArgs(argc, argv);

    // Construct the Verilated model, from Vtop.h generated from Verilating "top.v"
    // Using unique_ptr is similar to "Vtop* top = new Vtop" then deleting at end
    const std::unique_ptr<Vtop> top{new Vtop};
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
    top->ion = 1;
    top->pause = 0;
    top->run = 1;
    top->inst_and = 1;
    top->inst_tad = 0;
    top->inst_isz = 0;
    top->inst_dca = 0;
    top->inst_jms = 0;
    top->inst_jmp = 0;
    top->inst_iot = 0;
    top->inst_opr = 0;
    top->state_fetch = 1;
    top->state_defer = 0;
    top->state_execute = 0;
    top->state_word_count = 0;
    top->state_cur_addr = 0;
    top->state_break = 0;
    top->dataf = 5;
    top->instf = 2;
    top->pc = 01234;
    top->ma = 04321;
    top->mb = 05555;
    top->lac = 016243;
    top->sc = 013;
    top->mq = 02222;


	VL_PRINTF("running...\n");
    for (int i = 0; i < 10000000; i++)
	{
        if (main_time > 20)
            top->rst = 0;

		for (int clk = 0; clk < 2; clk++)
		{
			main_time += 5;
#if VM_TRACE
			if (tfp)
				tfp->dump(10*i + 5*clk);
#endif
			top->clk = !top->clk;

            if (top->sw_row == 6)
                top->col = 03777;
            else if (top->sw_row == 5)
                top->col = 05777;
            else if (top->sw_row == 3)
                top->col = 06777;
            else
                top->col = 07777;

			top->eval();
		}
    }

#if VM_TRACE
	if (tfp)
		tfp->close();
#endif

    // Final model cleanup
    top->final();

    exit(0);
}
