#include <stdio.h>
#include <stdlib.h>
#include <memory>
#include <verilated.h>
#include <unistd.h>
#include <time.h>
#include <termio.h>
#include <ctype.h>
#include <signal.h>
#include "verilated_vcd_c.h"
#include "Vtop.h"
#include "control.h"

// prints time and octal value of character received for debugging
//#define VERBOSE_PRINT

vluint64_t main_time = 0;
vluint64_t cycle_count = 0;

int did_hlt_msg = 0;
int do_tx = 0;
int old_run = 0;
int old_tp4 = 0;
int old_tp3 = 0;
int started = 0;
int old_dt_ef = 0;

const char *bin_name = NULL;
int start_addr = 0200;
int init_sr = 0200;
unsigned long long int runtime = 0;
unsigned long long int logtime = 0;
unsigned long long int max_cycles = 0;

clock_t t_start, t_end;

int ignore_stdin = 0;
char buf;

struct termios old_term, new_term;

uint16_t *mem;

uint16_t old_7755 = ~0;

void restore_term() {
    if (tcsetattr(STDIN_FILENO, TCSANOW, &old_term) < 0) {
        perror("tcsetattr");
        exit(1);
    }
}

void status(Vtop *top) {
    VL_PRINTF("[time: %" VL_PRI64 "d ns  ", main_time);
    VL_PRINTF("cycle count: %" VL_PRI64 "d  ", cycle_count);
    printf("pc: %04o lac: %05o ma: %04o mb: %04o mq: %04o sc: %02o if: %o df: %o]\n", 
        top->pc, top->lac, top->ma, top->mb, top->mq, top->sc, top->instf, top->dataf);
}

int main(int argc, char** argv, char** env) {
    t_start = clock();
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

    if (tcgetattr(STDIN_FILENO, &old_term) < 0) {
        perror("tcgetattr");
        exit(1);
    }

    // raw and no echo
    new_term = old_term;
    new_term.c_lflag &= ~ICANON;
    new_term.c_lflag &= ~ECHO;
    new_term.c_cc[VMIN] = 0;
    new_term.c_cc[VTIME] = 0;

    if (tcsetattr(STDIN_FILENO, TCSANOW, &new_term) < 0) {
        perror("tcsetattr");
        exit(1);
    }

    int opt;
    while ((opt = getopt(argc, argv, "b:s:r:t:l:ic:")) != -1) {
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
        case 'i': // ignore stdin
            ignore_stdin = 1;
            break;
        case 'c': // max cycles
            sscanf(optarg, "%llu", &max_cycles);
            break;
        default: break;
        }
    }

    if (bin_name == NULL) {
        printf("error: no bin file specified\n");
        restore_term();
        exit(-1);
    }
    if (start_addr < 0 || start_addr > 07777) {
        printf("error: invalid starting address\n");
        restore_term();
        exit(-1);
    }
    if (init_sr < 0 || init_sr > 07777) {
        printf("error: invalid switch register setting\n");
        restore_term();
        exit(-1);
    }
    if (runtime == 0)
        printf("testing %s with SA=%o and SR=%o\n", bin_name, start_addr, init_sr);
    else
        printf("testing %s with SA=%o and SR=%o for %llu ns\n", bin_name, start_addr, init_sr, runtime);
#if VM_TRACE
    printf("logging enabled at %llu ns\n", logtime);
#else
    printf("logging disabled\n");
#endif
    mem = top->top__DOT__pdp__DOT__core_mem__DOT__ram;
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
    top->data_to_pdp = 0;
	top->data_to_pdp_strobe = 0;

	top->eval();

	// set core to zero
	for (int i = 0; i < 32768; i++)
		top->top__DOT__pdp__DOT__core_mem__DOT__ram[i] = 0;
	
	VL_PRINTF("starting simulation...\n");
    uint64_t i = 0;

    int set_halt = 0;

    for (;;) {
        // are we running for a fixed time?
        if ((runtime > 0) && (main_time >= runtime))
            break;

        // are we running for a fixed number of cycles?
        if (started && (max_cycles > 0) && (cycle_count >= max_cycles))
            break;

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
            started = 1;
            top->start = 0;
            top->cont = 0;
        }

        int run_status;

        run_status = do_test(top, bin_name, start_addr, init_sr, main_time, 15000);

        // send character if UART is ready and we aren't ignoring stdin
        if (top->data_to_pdp_ready && !do_tx) {
            if (read(STDIN_FILENO, &buf, 1) > 0) {
                if (buf == 5) // ctrl-e
                    status(top);
                else if (!ignore_stdin) {
                    if (buf == 012) buf = 015; // translate CR/LF
                    top->data_to_pdp = toupper(buf) | 0200; // mark parity
                    do_tx = 1;
                }
            }
        }

        if (do_tx) {
            do_tx = 0;
            top->data_to_pdp_strobe = 1;
        } else {
            top->data_to_pdp_strobe = 0;
        }

        // any characters to print from the PDP-8?
        if (top->data_from_pdp_strobe) {
#ifdef VERBOSE_PRINT
            VL_PRINTF("[cycle count: %" VL_PRI64 "d] %03o", cycle_count, top->data_from_pdp);
            if ((top->data_from_pdp & 0177) >= 040 && (top->data_from_pdp & 0177) < 0177)
                printf(" (%c)\n", top->data_from_pdp & 0177);
            else if ((top->data_from_pdp & 0177) == 07)
                printf(" (BEL)\n");
            else if ((top->data_from_pdp & 0177) == 011)
                printf(" (TAB)\n");
            else if ((top->data_from_pdp & 0177) == 012)
                printf(" (LF)\n");
            else if ((top->data_from_pdp & 0177) == 014)
                printf(" (FF)\n");
            else if ((top->data_from_pdp & 0177) == 015)
                printf(" (CR)\n");
            else if ((top->data_from_pdp & 0177) == 033)
                printf(" (ESC)\n");
            else
                printf("\n");
#else
            printf("%c", top->data_from_pdp & 0177);
            if ((top->data_from_pdp & 0177) == 07) 
                printf("\033[31;1m[ding!]\033[0m"); // bell
			fflush(stdout);
#endif
        }

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

        /*
        // print status on every fetch after some time
        if (main_time > 1737260890 && top->state_fetch && top->tp3 && !old_tp3) {
            VL_PRINTF("[%" VL_PRI64 "d] ", main_time);
            printf("pc: %04o lac: %05o ma: %04o mb: %04o mq: %04o sc: %02o if: %o df: %o\n", 
                top->pc, top->lac, top->ma, top->mb, top->mq, top->sc, top->instf, top->dataf);
        }
        */

        // print DECtape handler status
        if (top->state_fetch && top->tp3 && !old_tp3 && top->mem_addr == 07610) {
            VL_PRINTF("[%" VL_PRI64 "d] ", main_time);
            printf("DT handler: called from %05o fun: %04o buf: %04o rec: %04o\n", (top->dataf << 12) | ((mem[07607] - 1) & 07777),
                mem[(top->dataf << 12) | mem[07607]], mem[(top->dataf << 12) | mem[07607] + 1], mem[(top->dataf << 12) | mem[07607] + 2]);
        }

        /*
        // print break status
        if (top->state_break && top->tp3 && !old_tp3)
            VL_PRINTF("[%" VL_PRI64 "d] break: %05o = %04o\n", main_time, top->mem_addr, top->mb);
        */
        old_tp3 = top->tp3;

        // print any TC08 errors
        if (top->ef && !old_dt_ef) {
            VL_PRINTF("[%" VL_PRI64 "d] ", main_time);
            printf("dt err: ");
            if (top->mktk)
                printf("mktk ");
            if (top->end_h)
                printf("end ");
            if (top->sel)
                printf("sel ");
            if (top->par)
                printf("par ");
            if (top->tim)
                printf("tim ");
            printf("\n");
        }
        old_dt_ef = top->ef;

        // reset cycle count on start
        if (!old_run && top->run) {
            cycle_count = 0;
        }
        old_run = top->run;

        // increment cycle count at every TP4
        if (!old_tp4 && top->top__DOT__pdp__DOT__tp4) {
            cycle_count++;
        }
        old_tp4 = top->top__DOT__pdp__DOT__tp4;

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

    t_end = clock();
    double elapsed = (double) (t_end - t_start) / CLOCKS_PER_SEC;
    double speed = (double) main_time / elapsed;

    VL_PRINTF("\nexiting at time %" VL_PRI64 "d ns\n", main_time);
    VL_PRINTF("cycle count: %" VL_PRI64 "d\n", cycle_count);
    VL_PRINTF("elapsed time: %.1f seconds ", elapsed);
    if (speed >= 1e9)
        VL_PRINTF("(%.1f seconds per second)\n", speed / 1e9);
    else if (speed >= 1e6)
        VL_PRINTF("(%.1f milliseconds per second)\n", speed / 1e6);
    else if (speed >= 1e3)
        VL_PRINTF("(%.1f microseconds per second)\n", speed / 1e3);
    else
        VL_PRINTF("(%.1f nanoseconds per second)\n", speed);

    restore_term();
    exit(0);
}
