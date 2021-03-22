#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <stdint.h>
#include "DECtapeUtilities.h"

uint16_t buffer[DECTAPE_CAPACITY];
DECtapeCell tape[DECTAPE_TOTAL_CELLS];

FILE *infile;
FILE *outfile;

uint16_t get_checksum(int block) {
    uint16_t cksum = 077;
    for (int i = 0; i < DECTAPE_WORDS_PER_BLOCK; i++) {
        cksum ^= buffer[DECTAPE_WORDS_PER_BLOCK*block + i];
        cksum ^= buffer[DECTAPE_WORDS_PER_BLOCK*block + i] >> 6;
    }
    return cksum & 077;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("usage: %s [in file] [out file]\n", argv[0]);
        exit(-1);
    }

    infile = fopen(argv[1], "rb");
    if (!infile) {
        printf("error opening file %s\n", argv[1]);
        exit(-1);
    }

    int words_read = fread((void *) buffer, 2, DECTAPE_CAPACITY, infile);

    fclose(infile);

    if (words_read < 0) {
        printf("error reading file %s\n", argv[1]);
        exit(-1);
    }

    if (words_read != DECTAPE_CAPACITY) {
        printf("got %d words instead of %d\n", words_read, DECTAPE_CAPACITY);
    }

    /* Borrowed from Bernhard Baehr's PDP-8/E Simulator */
    uint16_t *bp = buffer;
    DECtapeCell *tp = tape;

    uint16_t wordsInFileBlock = DECTAPE_WORDS_PER_BLOCK;	// 129 words in a block written to the DECtape file

    // for initializing the DECtape, see DEC-08-EUFB-D TC01-TUSS DECTAPE FORMATTER (April 9, 1970), 5.1 Theory, steps (a) to (k), page 6 to 9
    for (int i = 0; i < DECTAPE_ENDZONE_CELLS; i++)                         // (a) 10 ft endzone
        setMarkAndData (tp++, MARK_END_REVERSE, 0);
    for (int i = 0; i < DECTAPE_ENDZONE_SYNC_CELLS; i++)                        // (b) 200 interblock sync cells
        setMarkAndData (tp++, MARK_INTERBLOCK_SYNC, 0);
    for (int block = 0; block < DECTAPE_BLOCKS_PER_TAPE; block++) {          // 1474 blocks (steps (c) to (h))
        setMarkAndData (tp++, MARK_INTERBLOCK_SYNC, 0);                     // (c) one interblock sync cell at block start
        setMarkAndData (tp++, MARK_BLOCK, block);                       // (d) block number (in line 2-5 of the cell)
        setMarkAndData (tp++, MARK_GUARD_REVERSE, 0);                       // (d) reverse guard
        setMarkAndData (tp++, MARK_LOCK, 0);                            // (e) lock mark
        setMarkAndData (tp++, MARK_PPC_REVERSE, 0);                     // (e) reverse checksum (in line 4-5 of the cell)
        setWord0 (tp, *bp++);                                   // (e) first data word of the block for the first data cell
        setWord1 (tp, *bp++);                                   // (e) second data word of the block for the first+second data cell
        setWord2 (tp, *bp++);                                   // (e) third data word of the block for the second data cell
        setMark (tp++, MARK_FINAL_REVERSE);                         // (e) first data cell
        setMark (tp++, MARK_PREFINAL_REVERSE);                          // (e) second data cell
        for (int i = 0; i < (DECTAPE_WORDS_PER_BLOCK - 6) / 3; i++) {               // (f) 41 double cells with each three data words
            setWord0 (tp, *bp++);
            setWord1 (tp, *bp++);
            setWord2 (tp, *bp++);
            setMark (tp++, MARK_DATA);
            setMark (tp++, MARK_DATA);
        }
        setWord0 (tp, *bp++);                                   // (g) 3rd last word of the block for the 2nd last data cell
        setWord1 (tp, *bp++);                                   // (g) 2nd last word of the block for the 2nd last and last data cell
        setWord2 (tp, wordsInFileBlock == DECTAPE_WORDS_PER_BLOCK ? *bp++ : 0);         // (g) last word of the block for the last data cell
        setMark (tp++, MARK_PREFINAL);                              // (g) prefinal data cell
        setMark (tp++, MARK_FINAL);                             // (g) final data cell
        uint16_t cksum = get_checksum(block);
        setMarkAndData (tp++, MARK_PPC, cksum << 12);                       // (g) checksum (in line 0-1 of the cell)
        setMarkAndData (tp++, MARK_LOCK_REVERSE, 0);                        // (g) reverse lock
        setMarkAndData (tp++, MARK_GUARD, 0);                           // (h) guard
        setMarkAndData (tp++, MARK_BLOCK_REVERSE, (obverseComplement(block) << 6) | 077);   // (h) reverse block number (in line 0-3 of the cell)
        setMarkAndData (tp++, MARK_INTERBLOCK_SYNC, 0777777);                   // (c) one interblock sync cell at block end
    }                                               // (h) and (c) filled with 1-bits for PDP-10 compatibility with 36-bit block numbers
    for (int i = 0; i < DECTAPE_ENDZONE_SYNC_CELLS; i++)                        // (j) 200 interblock sync cells
        setMarkAndData (tp++, MARK_INTERBLOCK_SYNC, 0);
    for (int i = 0; i < DECTAPE_ENDZONE_CELLS; i++)                         // (k) 10 ft endzone
        setMarkAndData (tp++, MARK_END, 0);
    while (tp < tape + DECTAPE_TOTAL_CELLS)
        setMarkAndData (tp++, MARK_END, 0);                         // fill the remaining tape with end marks

    outfile = fopen(argv[2], "w");
    if (!outfile) {
        printf("error opening file %s\n", argv[2]);
        exit(-1);
    }

    for (int i = 0; i < DECTAPE_TOTAL_CELLS; i++)
        for (int j = 0; j < 6; j++)
            fprintf(outfile, "%x\n", getLine(&tape[i], j));

    fclose(outfile);

    return 0;
}
