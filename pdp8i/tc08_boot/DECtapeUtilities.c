/*
 *	PDP-8/E Simulator
 *
 *	Copyright © 1994-2020 Bernhard Baehr
 *
 *	DECtapeUtilities.c - Utilities to access a DECtape and DECtape cells
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


#include "DECtapeUtilities.h"


/*
 * Data in a DECtapeCell:
 *
 * m0..m5 = mark
 * d0..d17 = 18-bit data
 * w0..w11, x0..x11, y0..y11 = 12-bit words
 * l0..l5 = 6 lines of the DECtape cell
 *
 * DECtapeCell 0:
 * byte0: m0  l0  l0  l0  m1  l1  l1  l1
 *            w0  w1  w2      w3  w4  w5
 *            d0  d1  d2      d3  d4  d5
 * byte1: m2  l2  l2  l2  m3  l3  l3  l3
 *            w6  w7  w8      w9 w10 w11
 *            d6  d7  d8      d9 d10 d11
 * byte2: m4  l4  l4  l4  m5  l5  l5  l5
 *            x0  x1  x2      x3  x4  x5
 *           d12 d13 d14     d15 d16 d17
 *
 * DECtapeCell 1:
 * byte0: m0  l0  l0  l0  m1  l1  l1  l1
 *            x6  x7  x8      x9 x10 x11
 *            d0  d1  d2      d3  d4  d5
 * byte1: m2  l2  l2  l2  m3  l3  l3  l3
 *            y0  y1  y2      y3  y4  y5
 *            d6  d7  d8      d9 d10 d11
 * byte2: m4  l4  l4  l4  m5  l5  l5  l5
 *            y6  y7  y8      y9 y10 y11
 *           d12 d13 d14     d15 d16 d17
 */


unsigned char getMark (DECtapeCell *p)
{
	return ((p->byte0 >> 2) & 040) | ((p->byte0 << 1) & 020) | ((p->byte1 >> 4) & 010) | ((p->byte1 >> 1) & 004) | ((p->byte2 >> 6) & 002) | ((p->byte2 >> 3) & 001);
}


unsigned char getObverseComplementMark (DECtapeCell *p)
{
	unsigned char mark = ((p->byte0 >> 2) & 040) | ((p->byte0 << 1) & 020) | ((p->byte1 >> 4) & 010) | ((p->byte1 >> 1) & 004) | ((p->byte2 >> 6) & 002) | ((p->byte2 >> 3) & 001);
	unsigned char obverseComplementMark = 0;
	for (int i = 0; i < DECTAPE_LINES_PER_CELL; i++) {
		obverseComplementMark = (unsigned char) (obverseComplementMark << 1) | ((mark & 1) ^ 1);
		mark >>= 1;
	}
	return obverseComplementMark;
}


void setMark (DECtapeCell *p, unsigned char mark)
{
	p->byte0 = (p->byte0 & 0167) | ((mark << 2) & 0200) | ((mark >> 1) & 0010);
	p->byte1 = (p->byte1 & 0167) | ((mark << 4) & 0200) | ((mark << 1) & 0010);
	p->byte2 = (p->byte2 & 0167) | ((mark << 6) & 0200) | ((mark << 3) & 0010);
}


void setMarkAndData (DECtapeCell *p, unsigned char mark, unsigned int data)
{
	p->byte0 = ((data >> 11) & 0160) | ((data >> 12) & 0007) | ((mark << 2) & 0200) | ((mark >> 1) & 0010);
	p->byte1 = ((data >>  5) & 0160) | ((data >>  6) & 0007) | ((mark << 4) & 0200) | ((mark << 1) & 0010);
	p->byte2 = ((data <<  1) & 0160) | ( data        & 0007) | ((mark << 6) & 0200) | ((mark << 3) & 0010);
}


unsigned char getLine (DECtapeCell *p, unsigned line)
{
	unsigned char byte = ((unsigned char *) p)[line >> 1];
	return (line & 1) ? (byte & 017) : (byte >> 4);
}


unsigned char getLineBackward (DECtapeCell *p, unsigned line, int backward)
{
	unsigned char byte = ((unsigned char *) p)[line >> 1];
	if (backward)
		byte = ~byte;
	return (line & 1) ? (byte & 017) : (byte >> 4);
}


void setLine (DECtapeCell *p, unsigned line, unsigned char linedata)
{
	unsigned char *byte = ((unsigned char *) p) + (line >> 1);
	*byte = (line & 1) ? ((*byte & 0360) | (linedata & 017)) : (unsigned char) ((linedata << 4) | (*byte & 017));
}


unsigned char getDataLine (DECtapeCell *p, unsigned line)
{
	unsigned char byte = ((unsigned char *) p)[line >> 1];
	return (line & 1) ? (byte & 07) : ((byte >> 4) & 07);
}


void setDataLine (DECtapeCell *p, unsigned line, unsigned char linedata)
{
	unsigned char *byte = ((unsigned char *) p) + (line >> 1);
	*byte = (line & 1) ? ((*byte & 0370) | (linedata & 07)) : (((linedata << 4) & 0160) | (*byte & 0217));
}


unsigned int getData (DECtapeCell *p)
{
	return ((p->byte0 & 0160) << 11) | ((p->byte0 & 07) << 12) | ((p->byte1 & 0160) << 5) | ((p->byte1 & 07) << 6) | ((p->byte2 & 0160) >> 1) | (p->byte2 & 07);
}


void setData (DECtapeCell *p, unsigned int data)
{
	p->byte0 = ((data >> 11) & 0160) | ((data >> 12) & 0007) | (p->byte0 & 0210);
	p->byte1 = ((data >>  5) & 0160) | ((data >>  6) & 0007) | (p->byte1 & 0210);
	p->byte2 = ((data <<  1) & 0160) | ( data        & 0007) | (p->byte2 & 0210);
}


unsigned short getWord0 (DECtapeCell *p)
{
	return (unsigned short) (((p->byte0 & 0160) << 5) | ((p->byte0 & 07) << 6) | ((p->byte1 & 0160) >> 1) | (p->byte1 & 07));
}


void setWord0 (DECtapeCell *p, unsigned short word)
{
	p->byte0 = ((word >> 5) & 0160) | ((word >> 6) & 0007) | (p->byte0 & 0210);
	p->byte1 = ((word << 1) & 0160) | ( word       & 0007) | (p->byte1 & 0210);
}


unsigned short getWord1 (DECtapeCell *p)
{
	return (unsigned short) (((p->byte2 & 0160) << 5) | ((p->byte2 & 07) << 6) | (((p+1)->byte0 & 0160) >> 1) | ((p+1)->byte0 & 07));
}


void setWord1 (DECtapeCell *p, unsigned short word)
{
	p    ->byte2 = ((word >> 5) & 0160) | ((word >> 6) & 0007) | (p    ->byte2 & 0210);
	(p+1)->byte0 = ((word << 1) & 0160) | ( word       & 0007) | ((p+1)->byte0 & 0210);
}


unsigned short getWord2 (DECtapeCell *p)
{
	p++;
	return (unsigned short) (((p->byte1 & 0160) << 5) | ((p->byte1 & 07) << 6) | ((p->byte2 & 0160) >> 1) | (p->byte2 & 07));
}


void setWord2 (DECtapeCell *p, unsigned short word)
{
	p++;
	p->byte1 = ((word >> 5) & 0160) | ((word >> 6) & 0007) | (p->byte1 & 0210);
	p->byte2 = ((word << 1) & 0160) | ( word       & 0007) | (p->byte2 & 0210);
}


unsigned char obverseComplement6Bit (unsigned short byte)
{
	byte ^= 077;
	return (unsigned char) (((byte & 070) >> 3) | ((byte & 07) << 3));
}


unsigned short obverseComplement (unsigned short word)
{
	word ^= 07777;
	return (unsigned short) (((word >> 9) & 07) | ((word >> 3) & 070) | ((word & 070) << 3) | ((word & 07) << 9));
}
