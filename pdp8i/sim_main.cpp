#include <stdlib.h>
#include <memory>
#include <verilated.h>
#include "verilated_vcd_c.h"
#include "Vtop.h"

vluint64_t main_time = 0;

/* BIN loader borrowed from SimH */
int sim_bin_getc (FILE *fi, uint32_t *newf) {
	int c, rubout;

	rubout = 0;                                             /* clear toggle */
	while ((c = getc (fi)) != EOF) {                        /* read char */
		if (rubout)                                         /* toggle set? */
			rubout = 0;                                     /* clr, skip */
		else if (c == 0377)                                 /* rubout? */
			rubout = 1;                                     /* set, skip */
		else if (c > 0200)                                  /* channel 8 set? */
			*newf = (c & 070) << 9;                         /* change field */
		else return c;                                      /* otherwise ok */
		}
	return EOF;
}

int sim_load_bin (FILE *fi, uint16_t *M) {
	int hi, lo, wd, csum, t;
	uint32_t field, newf, origin;
	int sections_read = 0;

	for (;;) {
		csum = origin = field = newf = 0;                   /* init */
		do {                                                /* skip leader */
			if ((hi = sim_bin_getc (fi, &newf)) == EOF) {
				if (sections_read != 0)
					return 0;
				else
					return -1;
			}
		} while ((hi == 0) || (hi >= 0200));
		for (;;) {                                          /* data blocks */
			if ((lo = sim_bin_getc(fi, &newf)) == EOF)      /* low char */
				return -1;
			wd = (hi << 6) | lo;                            /* form word */
			t = hi;                                         /* save for csum */
			if ((hi = sim_bin_getc(fi, &newf)) == EOF)      /* next char */
				return -1;
			if (hi == 0200) {                               /* end of tape? */
				if ((csum - wd) & 07777)                    /* valid csum? */
					return -2;
				sections_read++;
				break;
			}
			csum = csum + t + lo;                           /* add to csum */
			if (wd > 07777)                                 /* chan 7 set? */
				origin = wd & 07777;                        /* new origin */
			else {                                          /* no, data */
				M[field | origin] = wd;
				origin = (origin + 1) & 07777;
			}
			field = newf;                                   /* update field */
		}
	}
	return -4;
}

uint16_t *ram;
int did_print = 0;

void load_core(const char *fname) {
	printf("loading %s...", fname);
	FILE *fp = fopen(fname, "rb");
	if (fp == NULL) {
		printf("error: could not open file\n");
		exit(-1);
	}
	int retval = sim_load_bin (fp, ram);
	if (retval < 0) {
		printf("error: failure %d reading paper tape\n", retval);
		exit(-1);
	}
	fclose(fp);
	printf("done\n");
}

int main(int argc, char** argv, char** env) {
    if (false && argc && argv && env) {}

    Verilated::debug(0);
    Verilated::randReset(2);
    Verilated::traceEverOn(true);
    Verilated::commandArgs(argc, argv);

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
	top->start = 0;
	top->stop = 1; // make sure the machine is halted on power-up
	top->cont = 0;
	top->dep = 0;
	top->dfsr = 0;
	top->exam = 0;
	top->ifsr = 0;
	top->load_addr = 0;
	top->sing_inst = 0;
	top->sing_step = 0;
	top->sr = 0; // initial SR setting
	top->step = 0;

	top->eval();

	ram = (uint16_t *) top->top__DOT__pdp__DOT__core_mem__DOT__ram;

	// set core to zero
	for (int i = 0; i < 32768; i++)
		ram[i] = 0;
	
	// initialize core with paper tape
	load_core("maindec-8i-d01c-pb.bin");

	VL_PRINTF("running...\n");
#if VM_TRACE
    for (int i = 0; i < 1000000; i++)
#else
	for (;;)
#endif
	{
		// disable reset after a bit
		if (main_time > 2000)
			top->rst = 0;

		// and switch stop off
		if (main_time > 10000)
			top->stop = 0;

		// default switch positions
		top->load_addr = 0;
		top->dep = 0;
		top->exam = 0;
		top->start = 0;

		// set SR for start of program
		if (main_time == 10000)
			top->sr = 0144;

		// load the address
		if (main_time > 15000 && main_time < 25000)
			top->load_addr = 1;

		// set sr
		if (main_time == 25000)
			top->sr = 07777;

		// and run it!
		if (main_time > 25000 && main_time < 35000)
			top->start = 1;

		// check to see if we're still running
		if (main_time == 3400000) {
			if (!top->run) {
				printf("test failed\n");
				//return -1;
			} else
				printf("test passed\n");
		}

		// halt it 
		if (main_time > 3400000 && main_time < 3410000) {
			top->stop = 1;
		}

		// load new paper tape
		if (main_time == 3410000) {
			//load_core("maindec-8i-d02b-pb.bin");
			load_core("hello.bin");
			top->sr = 0200;
		}

		// load the address
		if (main_time > 3415000 && main_time < 3425000)
			top->load_addr = 1;

		// set sr
		if (main_time == 3425000) {
			printf("running...\n");
			top->sr = 05000;
		}

		// and run it!
		if (main_time > 3425000 && main_time < 3435000)
			top->start = 1;

		if (main_time > 3435000 && !top->run) {
			VL_PRINTF("\nhalted at time %" VL_PRI64 "d\n", main_time);
			printf("pc: %o lac: %o ma: %o mb: %o mq: %o sc: %o if: %o df: %o\n", 
				top->pc, top->lac, top->ma, top->mb, top->mq, top->sc, top->instf, top->dataf);
			return 0;
		}

		if (!top->top__DOT__pdp__DOT__ef02__DOT__load && !did_print) {
			did_print = 1;
			printf("%c", top->lac & 0177);
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
    }

#if VM_TRACE
	if (tfp)
		tfp->close();
#endif

    top->final();

    exit(0);
}
