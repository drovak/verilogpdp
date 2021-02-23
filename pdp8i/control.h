#define WAS_RUNNING -1
#define WAS_HALTED -2

int sim_bin_getc(FILE *fi, uint32_t *newf);
int sim_load_bin(FILE *fi, uint16_t *M);
void load_core(const char *fname, uint16_t *ram);
int do_test(Vtop *top, const char *fname, int start_addr, int init_sr, vluint64_t main_time, vluint64_t load_time);
