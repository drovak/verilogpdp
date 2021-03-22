/*
 * dectape_decode.c
 *
 * Copyright 2001 Eric Smith <eric@brouhaha.com>
 *
 * $Id: dectape_decode.c,v 1.8 2001/02/02 23:36:18 eric Exp eric $
 *
 * This program decodes a raw DECtape image.  The input file is a stream
 * of bytes in either David Gesswein's format or Eric Smith's format.
 * 
 * In David Gesswein's format, each byte contains one four-bit DECtape
 * sample in the form ----210M, where the high four bits ("-") are don't
 * cares (normally zero).
 *
 * In Eric Smith's format, each byte contains two four-bit DECtape samples.
 * The most significant four bits precede the least significant, i.e.,
 * they are from nearer the beginning of the tape.  The byte looks like:
 * M210M210
 * ^^^^     first sample
 *     ^^^^ second sample
 *
 * It is assumed that the DECtape contains a series of blocks consecutively
 * numbered starting from 0, and all having the same size.  The block size
 * and count will be written to stderr.
 *
 * The output file will consist of the contents of all the blocks, with
 * no block separator or indication.  Four data modes are supported: 
 *
 * 12-bit:  each 12-bit word will be written in two bytes of output,
 *          padded with four zero bits.  The last 12-bit word of the
 *          block will be dropped per OS-8 convention.
 * 16-bit:  each 16-bit word will be written in two bytes of output.
 * 18-bit:  each 18-bit word will be written in three bytes of output,
 *          padded with six zero bits.
 * 36-bit:  each 36-bit word will be written in five bytes of output,
 *          padded with four zero bits.
 *
 * References:
 *
 *     U.S. Patent 3,387,293
 *     Bidirectional Retrieval of Magnetically Recorded Data
 *     T. C. Stockebrand, inventor
 *
 *     TC11 DECtape System Manual
 *     DEC-11-HTCB-D
 *     Digital Equipment Corporation
 *
 *     TC11 DECtape System Engineering Drawings
 *     DEC-11-HTCA-D
 *     Digital Equipment Corporation
 *
 * Scans of these documents may be found at
 *     http://www.brouhaha.com/~eric/retrocomputing/dec/dectape/
 *
 * Thanks to:
 *     David Gesswein for supplying raw images for testing
 *     Al Kossow for scanning the TC11 documents
 *
 * Modifications by bernhard.baehr@gmx.de, June 2020, marked with bb comments:
 * - added -bb format: like -es, but with the two four-bits DECtape lines
 *   in a byte swapped
 * - added -129 option: don't drop the 129th 12-bit word in the 12-bit ouput
 *   format
 */


#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>


char *progname;


void print_usage (FILE *f)
{
  fprintf (f, "Usage: %s [options] infile outfile\n", progname);
  fprintf (f, "    -12  12-bit format\n"
	      "    -16  16-bit format (default)\n"
	      "    -18  18-bit format\n"
	      "    -36  18-bit format\n"
	      "    -es  Eric's raw DECtape image format (default)\n"
	      "    -dg  David Gesswein's raw DECtape image format\n"
/* bb */      "    -bb  Like -es, but DECtape lines in a byte swapped\n"
/* bb */      "    -129 Ouput 129 words (default 128) for the 12-bit format\n"
	   );
}


void fatal (int retval, char *fmt, ...) __attribute__ ((noreturn));

void fatal (int retval, char *fmt, ...)
{
  va_list ap;

  if (fmt)
    {
      fprintf (stderr, "%s: ", progname);
      va_start (ap, fmt);
      vfprintf (stderr, fmt, ap);
      va_end (ap);
    }
  if (retval == 1)
    print_usage (stderr);
  exit (retval);
}


typedef unsigned char boolean;
#define false 0
#define true 1

typedef unsigned char u8;
typedef unsigned int u32;


FILE *outfile;
int data_mode = 16;
int output_128_12bit_words = 1;		/* bb */


#define ES_INPUT_FORMAT 1  /* two lines per input byte */
#define DG_INPUT_FORMAT 2  /* one line per input byte, mark in LSB */
#define BB_INPUT_FORMAT 3  /* like ES, but with swapped nibbles */ /* bb */



/*
 * write the data from two frames to the output file
 *
 * In 12-bit format, the last 12-bit word of the 129-word
 * block is normally discarded, leaving 128 data words.
 */
void output_data (int data1, int data2, int last)
{
  unsigned char c [6];
  switch (data_mode)
    {
    case 12:
      c [1] = data1 >> 14;
      c [0] = (data1 >> 6) & 0xff;
      c [3] = (data1 >> 2) & 0x0f;
      c [2] = ((data1 & 0x03) << 6) + (data2 >> 12);
      c [5] = (data2 >> 8) & 0x0f;
      c [4] = data2 & 0xff;
      if (last)
	fwrite (& c [0], 1, 4, outfile);
      else
	fwrite (& c [0], 1, 6, outfile);
      break;
    case 16:
      /* high two bits of each frame ignored */
      c [0] = data1 & 0xff;
      c [1] = (data1 >> 8) & 0xff;
      c [2] = data2 & 0xff;
      c [3] = (data2 >> 8) & 0xff;
      fwrite (& c [0], 1, 4, outfile);
      break;
    case 18:
      c [0] = data1 & 0xff;
      c [1] = (data1 >> 8) & 0xff;
      c [2] = (data1 >> 16) & 0x03;
      c [3] = data2 & 0xff;
      c [4] = (data2 >> 8) & 0xff;
      c [5] = (data2 >> 16) & 0x03;
      fwrite (& c [0], 1, 6, outfile);
      break;
    case 36:
      c [0] = data2 & 0xff;
      c [1] = (data2 >> 8) & 0xff;
      c [2] = ((data1 & 0x3f) << 2) + ((data2 >> 16) & 3);
      c [3] = (data1 >> 6) & 0xff;
      c [4] = (data1 >> 14) & 0xff;
      fwrite (& c [0], 1, 5, outfile);
      break;
    }
}


#define MAX_TAPE_LINES 1500000

u8 tape_lines [MAX_TAPE_LINES];
u32 tape_line_count;
u32 head;


int checksum;
int bad_checksum_count;


#define RD_BUF_SIZE 1024

void read_raw_tape (char *fn, int input_format)
{
  FILE *f;
  u32 l;
  u8 buf [RD_BUF_SIZE];
  u8 *p;

  f = fopen (fn, "rb");
  if (! f)
    fatal (2, "error opening tape image file\n");

  for (;;)
    {
      p = & buf [0];
      l = fread (p, 1, RD_BUF_SIZE, f);
      if (l < 0)
	fatal (2, "read error on tape image file\n");
      if (l == 0)
	break;
      while (l--)
	{
	  switch (input_format)
	    {
	    case ES_INPUT_FORMAT:
	      /* My format, two lines per byte, least significant
		 first, mark in MSB of nybble */
	      tape_lines [tape_line_count++] = (*p) & 0x0f;
	      tape_lines [tape_line_count++] = ((*p) >> 4) & 0x0f;
	      p++;
	      break;
	    case DG_INPUT_FORMAT:
	      /* David Gesswein's raw DECtape image format, one line per byte,
		 mark in LSB */
	      tape_lines [tape_line_count++] = ((((*p) & 1) << 3) |
						(((*p) >> 1) & 7));
	      p++;
	      break;
/* bb */    case BB_INPUT_FORMAT:
/* bb */      /* Like ES_INPUT_FORMAT, two lines per byte, first line in */
/* bb */      /* most significant bits, mark in MSB of nybble */
/* bb */      tape_lines [tape_line_count++] = ((*p) >> 4) & 0x0f;
/* bb */      tape_lines [tape_line_count++] = (*p) & 0x0f;
/* bb */      p++;
/* bb */      break;
	    }
	}
    }
  fclose (f);
}


int obverse_complement_mark (int m)
{
  int i;
  int oc = 0;
  for (i = 0; i < 6; i++)
    {
      oc <<= 1;
      oc |= ! (m & 1);
      m >>= 1;
    }
  return (oc);
}


int obverse_complement_data (int d)
{
  int i;
  int oc = 0;
  for (i = 0; i < 6; i++)
    {
      oc <<= 3;
      oc |= ((d & 7) ^ 7);
      d >>= 3;
    }
  return (oc);
}


/*
 * get an 18-bit frame of data from the current tape location
 */
int get_data_frame (int check)
{
  int i;
  int data = 0;

  if ((head + 5) > tape_line_count)
    fatal (2, "flapped the tape getting a data frame\n");

  for (i = 0; i < 6; i++)
    data = (data << 3) + (tape_lines [head + i] & 7);

  if (check)
    {
      checksum ^= ((data >> 12) & 077);
      checksum ^= ((data >> 6) & 077);
      checksum ^= (data & 077);
    }

  return (data);
}


int get_mark (void)
{
  int i;
  int mark = 0;

  if ((head + 5) > tape_line_count)
    fatal (2, "flapped the tape getting a mark frame\n");

  for (i = 0; i < 6; i++)
    mark = (mark << 1) + ((tape_lines [head + i] >> 3) & 1);

  return (mark);
}


#define SYNC 1
#define MK_BLK_MK 2
#define MK_BLK_SYNC 3
#define MK_BLK_START 4
#define MK_DATA 5
#define MK_BLK_END 6
#define MK_END 7


/*
 * find the next significant mark track code, and leave the head
 * positioned at its start
 */
int mark_track_decode (void)
{
  int i;
  int mark;
  while ((head + 8) <= tape_line_count)
    {
      mark = 0;
      for (i = 0; i < 8; i++)
	mark = (mark << 1) + ((tape_lines [head + i] >> 3) & 1);
      switch (mark)
	{
#if 0
	case 0125:
	case 0325:
	  head += 2;
	  return (SYNC);
#endif
	case 0126:
	  head += 2;
	  return (MK_BLK_MK);
	case 0232:
	  head += 2;
	  return (MK_BLK_SYNC);
	case 0010:
	case 0210:
	  head += 2;
	  return (MK_BLK_START);
	case 0070:
	  head += 2;
	  return (MK_DATA);
	case 0073:
	case 0373:
	  head += 2;
	  return (MK_BLK_END);
	case 0351:
	  head += 2;
	  return (MK_BLK_SYNC);
	case 0222:
	  head += 2;
	  return (MK_END);
	}
      head++;
    }
  fatal (2, "flapped the tape searching for a mark\n");
}


/* returns true at end of tape */
boolean read_block (int *block_number, int *block_length)
{
  int code;
  int block, rev_block;
  int len;
  int i;
  int data [2];

  for (;;)
    {
      code = mark_track_decode ();
      if (code == MK_END)
	return (true);
      if (code == MK_BLK_MK)
	break;
    }

  block = get_data_frame (0);
  *block_number = block;

  *block_length = 0;  /* assume error */

  head += 6;

  /* get reverse guard (032) */
  code = get_mark ();
  if (code != 032)
    {
      fprintf (stderr, "bad block format, reverse guard not found\n");
      return (false);
    }
  head += 6;

  /* get reverse lock (010) */
  code = get_mark ();
  if (code != 010)
    {
      fprintf (stderr, "bad block format, reverse lock not found\n");
      return (false);
    }
  head += 6;

  /* get reverse check (010) */
  code = get_mark ();
  if (code != 010)
    {
      fprintf (stderr, "bad block format, reverse check not found\n");
      return (false);
    }
  checksum = get_data_frame (0) & 077;
  head += 6;

  /* get first two words (010) */
  for (i = 0; i < 2; i++)
    {
      code = get_mark ();
      if (code != 010)
	{
	  fprintf (stderr, "bad block format, first two words not found, code %02o, expected %02o\n", code, 010);
	  return (false);
	}
      data [i] = get_data_frame (1);
      head += 6;
    }
  output_data (data [0], data [1], 0);
  len = 2;

  /* get pairs of intermediate words (070) */

  for (;;)
    {
      code = get_mark ();
      if (code == 073)
	break;
      if (code != 070)
	{
	  fprintf (stderr, "bad block format, intermediate data words not found, code %02o, expected %02o\n", code, 070);
	  return (false);
	}
      data [0] = get_data_frame (1);
      head += 6;

      code = get_mark ();
      if (code == 073)
	{
	  fprintf (stderr, "bad block format, odd length\n");
	  break;
	}
      if (code != 070)
	{
	  fprintf (stderr, "bad block format, intermediate data words not found, code %02o, expected %02o\n", code, 070);
	  return (false);
	}
      data [1] = get_data_frame (1);
      head += 6;

      output_data (data [0], data [1], 0);
      len += 2;
    }

  /* get last two data words (073) */
  for (i = 0; i < 2; i++)
    {
      code = get_mark ();
      if (code != 073)
	{
	  fprintf (stderr, "bad block format, last two words not found, code %02o, expected %02o\n", code, 073);
	  return (false);
	}
      data [i] = get_data_frame (1);
      head += 6;
    }
  output_data (data [0], data [1], /* 1 */ output_128_12bit_words /* bb */);
  len += 2;

  /* get forward check (073) */
  code = get_mark ();
  if (code != 073)
    {
      fprintf (stderr, "bad block format, forward check not found\n");
      return (false);
    }
  checksum ^= (get_data_frame (0) >> 12);
  head += 6;

  /* verify checksum here */
  if (checksum != 077)
    {
      bad_checksum_count++;
      fprintf (stderr, "bad checksum\n");
    }

  /* get forward lock (073) */
  code = get_mark ();
  if (code != 073)
    {
      fprintf (stderr, "bad block format, forward lock not found\n");
      return (false);
    }
  head += 6;

  /* get forward guard (051) */
  code = get_mark ();
  if (code != 051)
    {
      fprintf (stderr, "bad block format, forward guard not found\n");
      return (false);
    }
  head += 6;

  /* get reverse block number (045) */
  code = get_mark ();
  if (code != 045)
    {
      fprintf (stderr, "bad block format, reverse block number not found\n");
      return (false);
    }
  rev_block = get_data_frame (0);
  head += 6;
  /* compare reverse block number to forward */
  if (block != obverse_complement_data (rev_block))
    printf ("block number mismatch: block %06o, rev block %06o\n",
	    block, rev_block);

  /* get extension (025) */
  code = get_mark ();
  if (code != 025)
    {
      fprintf (stderr, "bad block format, extension not found\n");
      return (false);
    }
  head += 6;

  *block_length = len;

  return (false);
}


int main (int argc, char *argv[])
{
  char *infn = NULL;
  char *outfn = NULL;
  int block_number, block_length;
  int exp_blk = 0;
  int exp_len = 0;
  int block_count = 0;
  int input_format = ES_INPUT_FORMAT;

  fprintf (stderr, "DECtape raw image decoder, Copyright 2001 Eric Smith <eric@brouhaha.com>\n");

  progname = argv [0];

  while (++argv, --argc)
    {
      if (argv [0][0] == '-')
	{
	  if (strcmp (argv [0], "-12") == 0)
	    data_mode = 12;
	  else if (strcmp (argv [0], "-16") == 0)
	    data_mode = 16;
	  else if (strcmp (argv [0], "-18") == 0)
	    data_mode = 18;
	  else if (strcmp (argv [0], "-36") == 0)
	    data_mode = 36;
	  else if (strcmp (argv [0], "-es") == 0)
	    input_format = ES_INPUT_FORMAT;
	  else if (strcmp (argv [0], "-dg") == 0)
	    input_format = DG_INPUT_FORMAT;
/* bb */  else if (strcmp (argv [0], "-bb") == 0)
/* bb */    input_format = BB_INPUT_FORMAT;
/* bb */  else if (strcmp (argv [0], "-129") == 0)
/* bb */    output_128_12bit_words = 0;	
	  else
	    fatal (1, "unrecognized option '%s'\n", argv [0]);
	}
      else
	{
	  if (! infn)
	    infn = argv [0];
	  else if (! outfn)
	    outfn = argv [0];
	  else
	    fatal (1, "too many filenames\n");
	}
    }

  if (! outfn)
    fatal (1, "not enough filenames\n");

  read_raw_tape (infn, input_format);

  /* KVO */

  outfile = fopen(outfn, "w");
  if (!outfile)
    fatal(3, "error opening output file\n");

  for (int i = 0; i < tape_line_count; i++)
    fprintf(outfile, "%x\n", tape_lines[i]);

  fclose(outfile);
  exit(0);

  /* KVO */

  outfile = fopen (outfn, "wb");
  if (! outfile)
    fatal (3, "error opening output file\n");

  head = 0;

  for (;;)
    {
      if (read_block (& block_number, & block_length))
	break;
      block_count++;
      if ((exp_blk != block_number) ||
	  (exp_len != block_length))
	{
	  fprintf (stderr, "block %d length %d 18-bit words", block_number, block_length);
	  if (data_mode != 18)
	    fprintf (stderr, " = %d %d-bit words",
		     (data_mode == 16) ? block_length : (block_length * 18) / data_mode,
		     data_mode);
	  fprintf (stderr, "\n");
	}
      exp_len = block_length;
      exp_blk = block_number + 1;
    }

  fclose (outfile);
  fprintf (stderr, "%d blocks\n", block_count);
  fprintf (stderr, "%d bad checksums\n", bad_checksum_count);
  exit (0);
}
