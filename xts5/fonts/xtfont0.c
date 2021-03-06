/*
Copyright (c) 2005 X.Org Foundation L.L.C.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
/*
*
* Copyright (c) Applied Testing and Technology, Inc. 1995
* All Rights Reserved.
*
* Project:     VSW5
*
* File:        xts5/fonts/xtfont0.c
*
* Description:
*	VSW test font
*
* Modifications:
* $Log: xtfont0.c,v $
* Revision 1.2  2005-11-03 08:42:00  jmichael
* clean up all vsw5 paths to use xts5 instead.
*
* Revision 1.1.1.2  2005/04/15 14:05:06  anderson
* Reimport of the base with the legal name in the copyright fixed.
*
* Revision 8.0  1998/12/23 23:22:50  mar
* Branch point for Release 5.0.2
*
* Revision 7.0  1998/10/30 22:40:49  mar
* Branch point for Release 5.0.2b1
*
* Revision 6.0  1998/03/02 05:15:24  tbr
* Branch point for Release 5.0.1
*
* Revision 5.0  1998/01/26 03:11:56  tbr
* Branch point for Release 5.0.1b1
*
* Revision 4.1  1996/01/25 02:01:11  andy
* Portability improvements from DEPLOY tools
*
* Revision 4.0  1995/12/15  08:37:41  tbr
* Branch point for Release 5.0.0
*
* Revision 3.1  1995/12/15  00:33:33  andy
* Prepare for GA Release
*
*/

/*
Portions of this software are based on Xlib and X Protocol Test Suite.
We have used this material under the terms of its copyright, which grants
free use, subject to the conditions below.  Note however that those
portions of this software that are based on the original Test Suite have
been significantly revised and that all such revisions are copyright (c)
1995 Applied Testing and Technology, Inc.  Insomuch as the proprietary
revisions cannot be separated from the freely copyable material, the net
result is that use of this software is governed by the ApTest copyright.

Copyright (c) 1990, 1991  X Consortium

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
X CONSORTIUM BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of the X Consortium shall not be
used in advertising or otherwise to promote the sale, use or other dealings
in this Software without prior written authorization from the X Consortium.

Copyright 1990, 1991 by UniSoft Group Limited.

Permission to use, copy, modify, distribute, and sell this software and
its documentation for any purpose is hereby granted without fee,
provided that the above copyright notice appear in all copies and that
both that copyright notice and this permission notice appear in
supporting documentation, and that the name of UniSoft not be
used in advertising or publicity pertaining to distribution of the
software without specific, written prior permission.  UniSoft
makes no representations about the suitability of this software for any
purpose.  It is provided "as is" without express or implied warranty.
 */

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include	"xtest.h"
#include	"X11/Xlib.h"
#include	"X11/Xutil.h"
#include	"X11/Xatom.h"

static XCharStruct perchar[] = {
	{0, 10, 10, 10, 0, 0},	/* 1 */
	{0, 10, 2, 10, 0, 0},	/* 2 */
	{0, 0, 0, 0, 0, 0},	/* 3 */
	{5, 25, 4, 13, -2, 0},	/* 4 */
	{0, 0, 0, 0, 0, 0},	/* 5 */
	{0, 0, 0, 0, 0, 0},	/* 6 */
	{0, 0, 0, 0, 0, 0},	/* 7 */
	{0, 0, 0, 0, 0, 0},	/* 8 */
	{0, 0, 0, 0, 0, 0},	/* 9 */
	{0, 0, 0, 0, 0, 0},	/* 10 */
	{0, 0, 0, 0, 0, 0},	/* 11 */
	{0, 0, 0, 0, 0, 0},	/* 12 */
	{0, 0, 0, 0, 0, 0},	/* 13 */
	{0, 0, 0, 0, 0, 0},	/* 14 */
	{0, 0, 0, 0, 0, 0},	/* 15 */
	{0, 0, 0, 0, 0, 0},	/* 16 */
	{0, 0, 0, 0, 0, 0},	/* 17 */
	{0, 0, 0, 0, 0, 0},	/* 18 */
	{0, 0, 0, 0, 0, 0},	/* 19 */
	{0, 0, 0, 0, 0, 0},	/* 20 */
	{0, 0, 0, 0, 0, 0},	/* 21 */
	{0, 0, 0, 0, 0, 0},	/* 22 */
	{0, 0, 0, 0, 0, 0},	/* 23 */
	{0, 0, 0, 0, 0, 0},	/* 24 */
	{0, 0, 0, 0, 0, 0},	/* 25 */
	{0, 0, 0, 0, 0, 0},	/* 26 */
	{0, 0, 0, 0, 0, 0},	/* 27 */
	{0, 0, 0, 0, 0, 0},	/* 28 */
	{0, 0, 0, 0, 0, 0},	/* 29 */
	{0, 0, 0, 0, 0, 0},	/* 30 */
	{0, 0, 0, 0, 0, 0},	/* 31 */
	{0, 0, 0, 0, 0, 0},	/* 32 */
	{0, 0, 0, 0, 0, 0},	/* 33 */
	{0, 0, 0, 0, 0, 0},	/* 34 */
	{0, 0, 0, 0, 0, 0},	/* 35 */
	{0, 0, 0, 0, 0, 0},	/* 36 */
	{0, 0, 0, 0, 0, 0},	/* 37 */
	{0, 0, 0, 0, 0, 0},	/* 38 */
	{0, 0, 0, 0, 0, 0},	/* 39 */
	{0, 0, 0, 0, 0, 0},	/* 40 */
	{0, 0, 0, 0, 0, 0},	/* 41 */
	{0, 0, 0, 0, 0, 0},	/* 42 */
	{0, 0, 0, 0, 0, 0},	/* 43 */
	{0, 0, 0, 0, 0, 0},	/* 44 */
	{0, 0, 0, 0, 0, 0},	/* 45 */
	{0, 0, 0, 0, 0, 0},	/* 46 */
	{0, 0, 0, 0, 0, 0},	/* 47 */
	{0, 0, 0, 0, 0, 0},	/* 48 */
	{0, 0, 0, 0, 0, 0},	/* 49 */
	{0, 0, 0, 0, 0, 0},	/* 50 */
	{0, 0, 0, 0, 0, 0},	/* 51 */
	{0, 0, 0, 0, 0, 0},	/* 52 */
	{0, 0, 0, 0, 0, 0},	/* 53 */
	{0, 0, 0, 0, 0, 0},	/* 54 */
	{0, 0, 0, 0, 0, 0},	/* 55 */
	{0, 0, 0, 0, 0, 0},	/* 56 */
	{0, 0, 0, 0, 0, 0},	/* 57 */
	{0, 0, 0, 0, 0, 0},	/* 58 */
	{0, 0, 0, 0, 0, 0},	/* 59 */
	{0, 0, 0, 0, 0, 0},	/* 60 */
	{0, 0, 0, 0, 0, 0},	/* 61 */
	{0, 0, 0, 0, 0, 0},	/* 62 */
	{0, 0, 0, 0, 0, 0},	/* 63 */
	{0, 0, 0, 0, 0, 0},	/* 64 */
	{0, 0, 0, 0, 0, 0},	/* 65 */
	{0, 0, 0, 0, 0, 0},	/* 66 */
	{0, 0, 0, 0, 0, 0},	/* 67 */
	{1, 10, 10, 8, 3, 0},	/* 68 */
};
static XFontProp props[] = {
	{XA_COPYRIGHT, 0},
	{XA_MIN_SPACE, 3},
	{XA_NORM_SPACE, 5},
	{XA_RESOLUTION, 100},
	{XA_UNDERLINE_POSITION, 2},
};

char	*xtfont0cpright = "Public domain font.  Share and enjoy.";

XFontStruct xtfont0 = {
	(XExtData*)0,
	(Font)0,
	FontLeftToRight,	/* direction */
	1,	/* min_byte2 */
	68,	/* max_byte2 */
	0,	/* min_byte1 */
	0,	/* max_byte1 */
	0,	/* all chars exist */
	0,	/* default char */
	5,	/* n_properties */
	props,
	{0, 10, 2, 8, -2, 0},
	{5, 25, 10, 13, 3, 0},
	perchar,
	20,	/* font ascent */
	3,	/* font descent */
};
