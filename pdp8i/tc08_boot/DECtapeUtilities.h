/*
 *	PDP-8/E Simulator
 *
 *	Copyright © 1994-2020 Bernhard Baehr
 *
 *	DECtapeUtilities.h - Utilities to access a DECtape and DECtape cells
 *
 *	This file is part of PDP-8/E Simulator.
 *
 *	PDP-8/E Simulator is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


// DECtape constants
#define DECTAPE_LINES_PER_WORD          4               // 12-bit word size in lines
#define DECTAPE_WORDS_PER_BLOCK         129             // block size in 12-bit words
#define DECTAPE_BLOCKS_PER_TAPE         1474            // tape size in blocks
#define DECTAPE_CAPACITY		(DECTAPE_BLOCKS_PER_TAPE * DECTAPE_WORDS_PER_BLOCK)
#define DECTAPE_LENGHT_IN_FOOT		260
#define DECTAPE_INCH_PER_FOOT		12
#define DECTAPE_LINES_PER_INCH		350
#define DECTAPE_TOTAL_LINES		(DECTAPE_LENGHT_IN_FOOT * DECTAPE_INCH_PER_FOOT * DECTAPE_LINES_PER_INCH)
#define DECTAPE_LINES_PER_CELL		6
#define DECTAPE_TOTAL_CELLS		(DECTAPE_TOTAL_LINES / DECTAPE_LINES_PER_CELL)
#define DECTAPE_ENDZONE_FOOTS		10
#define DECTAPE_ENDZONE_CELLS		(DECTAPE_ENDZONE_FOOTS * DECTAPE_INCH_PER_FOOT * DECTAPE_LINES_PER_INCH / DECTAPE_LINES_PER_CELL)
#define DECTAPE_ENDZONE_SYNC_CELLS	200

#define DECTAPE_START_STOP_INCHES	8	// DEC-08-I2AB-D DECtape Control Unit Type TC01 Instruction Manual (April 1968), page 1-4: Start and stop distances are approximately 8 in.
#define DECTAPE_START_LINES		(DECTAPE_START_STOP_INCHES * DECTAPE_LINES_PER_INCH - DECTAPE_LINES_PER_CELL)	// start takes two cells less than stop, so after startup in reverse direction,
#define DECTAPE_STOP_LINES		(DECTAPE_START_STOP_INCHES * DECTAPE_LINES_PER_INCH + DECTAPE_LINES_PER_CELL)	// the mark track window is already synced when the tape passes the stop position
#define DECTAPE_START_TIME		150000		// 150.000 microseconds = 150 ms
#define DECTAPE_STOP_TIME		100000		// 100.000 microseconds = 100 ms
#define DECTAPE_TURNAROUND_TIME		(DECTAPE_START_TIME + DECTAPE_STOP_TIME)	// correctly, 200 ms +/- 50 ms
#define DECTAPE_SPEED_INCHES_PER_SECOND	93
#define DECTAPE_LINES_PER_SECOND	(DECTAPE_SPEED_INCHES_PER_SECOND * DECTAPE_LINES_PER_INCH)
#define DECTAPE_USEC_PER_LINE		31		// 93 inch/sec * 350 lines/inch = 32550 lines/sec => 1/32550 sec/line = 30,72 usec/line
							// TC08 Maintenance Manual DEC-08-H3DA-D p. 1-1: Individual 12-bit words which are assembled by the TC08 control unit arrive at the computer approximately every 132 microseconds.

// Bits in a 4-bit DECtape line
#define MARK_BIT			010
#define DATA_BITS			007

// Mark Track Codes, see DEC-08-H3DA-D TC08 DECtape Controller Maintenance Manual, June 1970, figure 2-3, page 2-5
#define MARK_END			022
#define MARK_END_REVERSE		055
#define MARK_INTERBLOCK_SYNC		025
#define MARK_BLOCK			026
#define MARK_BLOCK_REVERSE		045
#define MARK_GUARD			051
#define MARK_GUARD_REVERSE		032
#define MARK_LOCK			010
#define MARK_LOCK_REVERSE		073
#define MARK_PPC			073
#define MARK_PPC_REVERSE		010
#define MARK_FINAL			073
#define MARK_FINAL_REVERSE		010
#define MARK_PREFINAL			073
#define MARK_PREFINAL_REVERSE		010
#define MARK_DATA			070


typedef struct {
	unsigned char byte0, byte1, byte2;
} DECtapeCell;


extern unsigned char getMark (DECtapeCell *p);						// returns or sets 6-bit mark of the cell
extern unsigned char getObverseComplementMark (DECtapeCell *p);
extern void setMark (DECtapeCell *p, unsigned char mark);
extern void setMarkAndData (DECtapeCell *p, unsigned char mark, unsigned int data);

extern unsigned char getLine (DECtapeCell *p, unsigned line);				// returns or sets a 4-bit line including mark bit (0 <= line < DECTAPE_TOTAL_LINES)
extern void setLine (DECtapeCell *p, unsigned line, unsigned char linedata);

extern unsigned char getLineBackward (DECtapeCell *p, unsigned line, int backward);	// returns a 4-bit line optionally inverted (for backward tape reading)

extern unsigned char getDataLine (DECtapeCell *p, unsigned line);			// returns or sets a 3-bit data line without the mark bit (0 <= line < DECTAPE_TOTAL_LINES)
extern void setDataLine (DECtapeCell *p, unsigned line, unsigned char linedata);

extern unsigned int getData (DECtapeCell *p);						// returns or sets 18-bit data word
extern void setData (DECtapeCell *p, unsigned int data);

extern unsigned short getWord0 (DECtapeCell *p);					// returns or sets first 12-bit word of the two cells p points to
extern void setWord0 (DECtapeCell *p, unsigned short word);

extern unsigned short getWord1 (DECtapeCell *p);					// returns or sets second 12-bit word of the two cells p points to
extern void setWord1 (DECtapeCell *p, unsigned short word);

extern unsigned short getWord2 (DECtapeCell *p);					// returns or sets third 12-bit word of the two cells p points to
extern void setWord2 (DECtapeCell *p, unsigned short word);

extern unsigned char obverseComplement6Bit (unsigned short byte);			// obverse complement of a 6-bit byte
extern unsigned short obverseComplement (unsigned short word);				// obverse complement of a 12-bit word
