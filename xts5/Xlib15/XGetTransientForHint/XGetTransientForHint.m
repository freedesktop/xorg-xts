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

Copyright (c) Applied Testing and Technology, Inc. 1995
All Rights Reserved.

>># Project: VSW5
>># 
>># File: xts5/Xlib15/XGetTransientForHint/XGetTransientForHint.m
>># 
>># Description:
>># 	Tests for XGetTransientForHint()
>># 
>># Modifications:
>># $Log: gttrnsntfr.m,v $
>># Revision 1.2  2005-11-03 08:42:49  jmichael
>># clean up all vsw5 paths to use xts5 instead.
>>#
>># Revision 1.1.1.2  2005/04/15 14:05:20  anderson
>># Reimport of the base with the legal name in the copyright fixed.
>>#
>># Revision 8.0  1998/12/23 23:33:53  mar
>># Branch point for Release 5.0.2
>>#
>># Revision 7.0  1998/10/30 22:55:47  mar
>># Branch point for Release 5.0.2b1
>>#
>># Revision 6.0  1998/03/02 05:25:15  tbr
>># Branch point for Release 5.0.1
>>#
>># Revision 5.0  1998/01/26 03:21:48  tbr
>># Branch point for Release 5.0.1b1
>>#
>># Revision 4.1  1996/05/09 00:28:49  andy
>># Corrected Xatom include
>>#
>># Revision 4.0  1995/12/15  09:09:06  tbr
>># Branch point for Release 5.0.0
>>#
>># Revision 3.1  1995/12/15  01:10:50  andy
>># Prepare for GA Release
>>#
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
>>TITLE XGetTransientForHint Xlib15
Status
XGetTransientForHint(display, w, prop_window_return)
Display	*display = Dsp;
Window	w = DRW(Dsp);
Window	*prop_window_return = &propwindow;
>>EXTERN
#include "X11/Xatom.h"
Window	propwindow;
>>ASSERTION Good A
When the WM_TRANSIENT_FOR property is set for the window
.A w ,
and is format 32, length 1 element and of type
.S WINDOW ,
then a call to xname returns the property value in the
.A prop_window_return
argument and returns non-zero.
>>STRATEGY
Create a window with XCreateWindow.
Set the WM_TRANSIENT_FOR property using XSetTransientForHint.
Obtain the value of the WM_TRANSIENT_FOR property using XGetTransientForHint.
Verify that the call did not return False.
Verify that the value was correct.
>>CODE
Status		status;
Window		win, twin;
Window		rwin = (Window) -1;
XVisualInfo	*vp;

	resetvinf(VI_WIN);
	nextvinf(&vp);
	win = makewin(display, vp);
	twin = makewin(display, vp);

	XSetTransientForHint(display, win, twin);

	w = win;
	prop_window_return = &rwin;
	status = XCALL;

	if(status == False) {
		report("XGetTransientForHint() returned False.");
		FAIL;
	} else
		CHECK;

	if(rwin != twin) {
		report("The value of the WM_TRANSIENT_FOR property was %lx instead of %lx.", (long) rwin, (long) twin);
		FAIL;
	} else
		CHECK;

	CHECKPASS(2);

>>ASSERTION Good A
When the WM_TRANSIENT_FOR property is not set for the window
.A w ,
or is format other than 32, length < 1 element or of type other than
.S WINDOW ,
then a call to xname returns zero. 
>>STRATEGY
Create a window with XCreateWindow.
Obtain the value of the unset WM_TRANSIENT_FOR property with XGetWMHints.
Verify that the call returned False.

Create a window with XCreateWindow.
Set the WM_TRANSIENT_FOR property with format 16 and type WINDOW and size 1 using XChangeProperty.
Obtain the value of the WM_TRANSIENT_FOR property with XGetWMHints.
Verify that the call returned False.

Create a window with XCreateWindow.
Set the WM_TRANSIENT_FOR property with format 32 type STRING and size 1 using XChangeProperty.
Obtain the value of the WM_TRANSIENT_FOR property with XGetWMHints.
Verify that the call returned False.

Create a window with XCreateWindow.
Set the WM_TRANSIENT_FOR property with format 32 type WINDOW and size 0 using XChangeProperty.
Obtain the value of the WM_TRANSIENT_FOR property with XGetWMHints.
Verify that the call returned False.
>>CODE
Status		status;
XVisualInfo	*vp;
Window		pwin;

	resetvinf(VI_WIN);
	nextvinf(&vp);

	prop_window_return = &pwin;
	pwin = makewin(display, vp);	
	w = makewin(display, vp);

/* Property unset */

	status = XCALL;

	if(status != False) {
		report("%s() did not return False when the WM_TRANSIENT_FOR property was not set.", TestName);
		FAIL;
	} else
		CHECK;

	w = makewin(display, vp);

/* Format 16 */
	XChangeProperty(display, w, XA_WM_TRANSIENT_FOR, XA_WINDOW, 16, PropModeReplace, (unsigned char *) &pwin, 1);

	status = XCALL;

	if(status != False) {
		report("%s() did not return False when the WM_TRANSIENT_FOR property format was 16.", TestName);
		FAIL;
	} else
		CHECK;

	w = makewin(display, vp);

/*  Type STRING */
	XChangeProperty(display, w, XA_WM_TRANSIENT_FOR, XA_STRING, 32, PropModeReplace, (unsigned char *) &pwin, 1);

	status = XCALL;

	if(status != False) {
		report("%s() did not return False when the WM_TRANSIENT_FOR property type was STRING.", TestName);
		FAIL;
	} else
		CHECK;

	w = makewin(display, vp);

/* No elements = 0 */
	XChangeProperty(display, w, XA_WM_TRANSIENT_FOR, XA_WINDOW, 32, PropModeReplace, (unsigned char *) &pwin, 0);

	status = XCALL;

	if(status != False) {
		report("%s() did not return False when the WM_TRANSIENT_FOR property size  was 0.", TestName);
		FAIL;
	} else
		CHECK;

	CHECKPASS(4);


>>ASSERTION Bad A
.ER BadWindow
>># Kieron	Completed	Review
