#include "Vtop___024root.h"
#include "Vtop.h"
#include "control.h"

/* BIN loader borrowed from SimH */
int sim_bin_getc(FILE *fi, uint32_t *newf) {
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

int sim_load_bin(FILE *fi, uint16_t *M) {
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

void load_core(const char *fname, uint16_t *ram) {
	printf("loading %s...", fname);
	FILE *fp = fopen(fname, "rb");
	if (fp == NULL) {
		printf("error: could not open file\n");
		exit(-1);
	}
	int retval = sim_load_bin(fp, ram);
	if (retval < 0) {
		printf("error: failure %d reading paper tape\n", retval);
		exit(-1);
	}
	fclose(fp);
	printf("done\n");
}

int do_test(Vtop *top, const char *fname, int start_addr, int init_sr, vluint64_t main_time, vluint64_t load_time) {
    // check to see if we're still running
    if (main_time == load_time) {
        if (!top->run) {
            //printf("already halted (failure?)\n");
            return WAS_HALTED;
        } else {
            top->stop = 1;
            return WAS_RUNNING;
        }
    }

    // load new paper tape
    if (main_time == (load_time + 10000)) {
        load_core(fname, (uint16_t *) &top->rootp->top__DOT__core_mem__DOT__ram[0]);
        top->sr = start_addr;
    }

    // load the address
    if (main_time > (load_time + 10000) && main_time < (load_time + 15000))
        top->load_addr = 1;

    // set sr
    if (main_time == (load_time + 15000)) {
        printf("running...\n");
        top->sr = init_sr;
    }

    // and run it!
    if (main_time == (load_time + 15500))
        top->start = 1;

    return 0;
}

