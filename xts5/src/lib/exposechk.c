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
* Copyright Applied Testing and Technology Inc. 1995
* All rights reserved
*
* Project: VSW5
*
* File:	xts5/src/lib/exposechk.c
*
* Description:
*	Exposure support routines
*
* Modifications:
* $Log: exposechk.c,v $
* Revision 1.2  2005-11-03 08:42:01  jmichael
* clean up all vsw5 paths to use xts5 instead.
*
* Revision 1.1.1.2  2005/04/15 14:05:10  anderson
* Reimport of the base with the legal name in the copyright fixed.
*
* Revision 8.0  1998/12/23 23:24:35  mar
* Branch point for Release 5.0.2
*
* Revision 7.0  1998/10/30 22:42:45  mar
* Branch point for Release 5.0.2b1
*
* Revision 6.0  1998/03/02 05:16:59  tbr
* Branch point for Release 5.0.1
*
* Revision 5.0  1998/01/26 03:13:32  tbr
* Branch point for Release 5.0.1b1
*
* Revision 4.1  1996/01/25 01:57:14  andy
* Portability improvements from DEPLOY tools
*
* Revision 4.0  1995/12/15  08:42:17  tbr
* Branch point for Release 5.0.0
*
* Revision 3.1  1995/12/15  00:39:30  andy
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
#include	"xtestlib.h"

/*
 * Set up a window for testing exposure processing.  This routine
 * is called first, the window is then covered and exposed.
 */
void
setforexpose(disp, w)
Display	*disp;
Window	w;
{
	/*
	 * Ensure that the background is set.  The whole screen is drawn
	 * on.
	 */
	XSetWindowBackground(disp, w, W_BG);
	dset(disp, w, W_FG);
}

/*
 * Take the given window and use any Expose events in the queue
 * to redraw exposed parts of the window.
 * The fields in the events are checked at the same time.
 * Returns False if the Expose events fields (other than the position/size
 * fields) are incorrect.
 */
Status
exposefill(disp, w)
Display	*disp;
Window	w;
{
XEvent	ev;
XExposeEvent	good;
XExposeEvent	*ep;
GC	gc;
struct	area	area;
int 	lastcount = 0;

	good.type = Expose;
	good.serial = 0;
	good.send_event = False;
	good.display = disp;
	good.window = w;

	gc = makegc(disp, w);

	/*
	 * Mimic the action of a client - redraw the areas that get
	 * Expose events.  Then checking that the window is complete
	 * verifies that either expose events were received or that
	 * the contents were restored from backing store.
	 */
	while (XCheckTypedWindowEvent(disp, w, Expose, &ev)) {

		ep = (XExposeEvent*)&ev;

		debug(2, "Expose (%d,%d) %dx%d", ep->x, ep->y, ep->width, ep->height);

		/*
		 * This is for interest.  Check that the exposed area is currently
		 * background.  The spec does not seem to disallow overlapping
		 * expose areas.
		 */
		setarea(&area, ep->x, ep->y, ep->width, ep->height);
		if (!checkarea(disp, w, &area, W_BG, W_BG, CHECK_IN|CHECK_DIFFER))
			trace("Exposed area was not all background");

		/*
		 * Fill in the exposed area.
		 */
		XFillRectangle(disp, w, gc, ep->x, ep->y, ep->width, ep->height);

		/*
		 * Check the count field.
		 * NOTE: Not clear what the spec really means here.
		 * I am expecting a series of contiguous sequences counting
		 * down to zero.
		 */
		if (lastcount == 0) {
			lastcount = ep->count;
			good.count = ep->count;
		} else {
			good.count = --lastcount;
		}

		/* Check other event fields */
		good.x = ep->x;
		good.y = ep->y;
		good.width = ep->width;
		good.height = ep->height;

		if (checkevent((XEvent*)&good, (XEvent*)ep)) {
			trace("Checkevent failed");
			return(False);
		}
	}
	return(True);
}

/*
 * Check that either enough expose events were received to
 * restore the window, or that the window has been restored from backing
 * store.  The field in the events are checked at the same time.
 * This routine may produce error messages and files.
 */
Status
exposecheck(disp, w)
Display	*disp;
Window	w;
{

	if (exposefill(disp, w) == False)
		return(False);
	return checkarea(disp, w, (struct area *)0, W_FG, W_FG, CHECK_ALL);
}

/*
 * Verify that the window has been restored to the original pattern
 * drawn in setforexpose().  This routine produces a status return only -
 * no error messages or error files are produced.
 */
Status
expose_test_restored(disp, w)
Display	*disp;
Window	w;
{
	return checkarea(disp, w, (struct area *)0, W_FG, W_FG, CHECK_ALL|CHECK_DIFFER);
}
