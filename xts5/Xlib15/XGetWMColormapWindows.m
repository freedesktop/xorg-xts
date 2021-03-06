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
>># File: xts5/Xlib15/XGetWMColormapWindows.m
>># 
>># Description:
>># 	Tests for XGetWMColormapWindows()
>># 
>># Modifications:
>># $Log: gtwmclrmpw.m,v $
>># Revision 1.2  2005-11-03 08:42:49  jmichael
>># clean up all vsw5 paths to use xts5 instead.
>>#
>># Revision 1.1.1.2  2005/04/15 14:05:20  anderson
>># Reimport of the base with the legal name in the copyright fixed.
>>#
>># Revision 8.0  1998/12/23 23:33:54  mar
>># Branch point for Release 5.0.2
>>#
>># Revision 7.0  1998/10/30 22:55:49  mar
>># Branch point for Release 5.0.2b1
>>#
>># Revision 6.0  1998/03/02 05:25:17  tbr
>># Branch point for Release 5.0.1
>>#
>># Revision 5.0  1998/01/26 03:21:49  tbr
>># Branch point for Release 5.0.1b1
>>#
>># Revision 4.1  1996/05/09 00:28:52  andy
>># Corrected Xatom include
>>#
>># Revision 4.0  1995/12/15  09:09:09  tbr
>># Branch point for Release 5.0.0
>>#
>># Revision 3.1  1995/12/15  01:10:57  andy
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
>>TITLE XGetWMColormapWindows Xlib15
Status
XGetWMColormapWindows(display, w, colormap_windows_return, count_return)
Display	*display = Dsp;
Window	w = DRW(display);
Window	**colormap_windows_return = &window;
int	*count_return = &count;
>>EXTERN
#include	"X11/Xatom.h"
Window	*window;
int	count;
>>ASSERTION Good A
When the WM_COLORMAP_WINDOWS property is set on the window
.A w ,
the property is of
.M type
WINDOW, and is of
.M format
32, 
then a call to xname returns the list of window identifiers stored 
in the property, which can be freed with XFree, in the
.A colormap_windows_return
argument and the number of windows in the
.A count_return
argument and returns non-zero.
>>STRATEGY
Create a window using XCreateWindow.
Set the WM_COLORMAP_WINDOWS property using XSetWMColormapWindows.
Obtain the WM_COLORMAP_WINDOWS property using XGetWMColormapWindows.
Verify that the call did not return False.
Verify that the value of the property is correct.
Release the allocated memory using XFree.
>>CODE
Status		status;
XVisualInfo	*vp;
int		nwins = 7;
Window		pwins[7];
Window		*rwins = NULL;
Window		*wp;
int		rcnt = 0;
int		i;

	for(i=0; i<nwins; i++)
		pwins[i] = (Window) i;

	resetvinf(VI_WIN);
	nextvinf(&vp);
	w = makewin(display, vp);
	
	XSetWMColormapWindows(display, w, pwins, nwins);

	colormap_windows_return = &rwins;
	count_return = &rcnt;
	status = XCALL;

	if(status == False) {
		report("%s() returned False.", TestName);
		FAIL;
	} else
		CHECK;

	if(rcnt != nwins) {
		report("The number of elements set for the WM_COLORMAP_WINDOWS property was %d instead of %d", rcnt, nwins);
		FAIL;
	} else
		CHECK;

	if(rwins == (Window *) NULL) {
		report("The WM_COLORMAP_WINDOWS property had no associated value.");
		FAIL;
	} else {

		CHECK;
		for(i = 0, wp = rwins; i < nwins; i++, wp++)
			if( *wp != pwins[i]) {
				report("Element %d of the WM_COLORMAP_WINDOWS value was %lu instead of %lu", i+1, (long) *wp, (long) pwins[i]);
				FAIL;
			} else
				CHECK;

		XFree((char*)rwins);
	}

	CHECKPASS(nwins + 3);

>>ASSERTION Bad B 1
When the atom name \(lqWM_COLORMAP_WINDOWS\(rq cannot be interned,
then a call to xname does not set the
.A colormap_windows_return
or
.A count_return
arguments and returns zero.
>>ASSERTION Good A
When the WM_COLORMAP_WINDOWS property is not set on the window
.A w ,
or is not of
.M type
WINDOW, or is not of
.M format
32, 
then a call to xname does not set the
.A colormap_windows_return
or
.A count_return
arguments and returns zero.
>>STRATEGY
Create a window with XCreateWindow.
Insure that the name \"WM_COLOMAP_WINDOWS\" is interned using XSetWMColormapWindows.
Obtain the WM_COLORMAP_WINDOWS atom using XInternAtom.

Create a window with XCreateWindow.
Initialise the colormap_windows_return and count_return arguments.
Obtain the value of the WM_COLORMAP_WINDOWS property with XGetWMColormapWindows.
Verify that the call returned False.
Verify that colormap_windows_return and count_return arguments were unchanged.

Create a window with XCreateWindow.
Set the WM_COLORMAP_WINDOWS property with format 8 and type WINDOW using XChangeProperty.
Initialise the colormap_windows_return and count_return arguments.
Obtain the value of the WM_COLORMAP_WINDOWS property with XGetWMColormapWindows.
Verify that the call returned False.
Verify that colormap_windows_return and count_return arguments were unchanged.

Create a window with XCreateWindow.
Initialise the colormap_windows_return and count_return arguments.
Set the WM_COLORMAP_WINDOWS property with format 32 type ATOM using XChangeProperty.
Obtain the value of the WM_COLORMAP_WINDOWS property with XGetWMColormapWindows.
Verify that the call returned False.
Verify that colormap_windows_return and count_return arguments were unchanged.

>>CODE
Status		status;
Atom		xa_wm_colormap_windows;
Atom		*rat;
int		rcnt;
XVisualInfo	*vp;
Window		wdw;

	resetvinf(VI_WIN);
	nextvinf(&vp);

	colormap_windows_return = &rat;
	count_return = &rcnt;
	w = makewin(display, vp);
	
	if(XSetWMColormapWindows(display, w, &wdw, 1) == False) {
		delete("XSetWMColormapWindows() returned False.");
		return;
	} else
		CHECK;

	if( (xa_wm_colormap_windows = XInternAtom(display, "WM_COLORMAP_WINDOWS", True)) == None) {
		delete("The \"WM_COLORMAP_WINDOWS\" string was not interned.");
		return;
	} else
		CHECK;

	w = makewin(display, vp);

/* property unset */

	rat = (Atom *) -1;
	rcnt = -1;
	status = XCALL;

	if(status != False) {
		report("%s() did not return False when the WM_COLORMAP_WINDOWS property was not set.", TestName);
		FAIL;
	} else
		CHECK;

	if( rat != (Atom *) -1) {
		report("Atom list pointer variable was updated when the WM_COLORMAP_WINDOWS property was not set.");
		FAIL;
	} else
		CHECK;

	if( rcnt != -1) {
		report("Atom count variable was updated when the WM_COLORMAP_WINDOWS property was not set.");
		FAIL;
	} else
		CHECK;

	w = makewin(display, vp);

/* format 8 */
 	XChangeProperty(display, w, xa_wm_colormap_windows, XA_WINDOW, 8, PropModeReplace, (unsigned char *) &wdw, 1);

	rat = (Atom *) -1;
	rcnt = -1;
	status = XCALL;

	if(status != False) {
		report("%s() did not return False when the WM_COLORMAP_WINDOWS property had format 8.", TestName);
		FAIL;
	} else
		CHECK;

	if( rat != (Atom *) -1) {
		report("Atom list pointer variable was updated when the WM_COLORMAP_WINDOWS property had format 8.");
		FAIL;
	} else
		CHECK;

	if( rcnt != -1) {
		report("Atom count variable was updated when the WM_COLORMAP_WINDOWS property had format 8.");
		FAIL;
	} else
		CHECK;

	w = makewin(display, vp);

/* type  ATOM */
 	XChangeProperty(display, w, xa_wm_colormap_windows, XA_ATOM, 32, PropModeReplace, (unsigned char *) &wdw, 1);

	rat = (Atom *) -1;
	rcnt = -1;
	status = XCALL;

	if(status != False) {
		report("%s() did not return False when the WM_COLORMAP_WINDOWS property had type ATOM.", TestName);
		FAIL;
	} else
		CHECK;

	if( rat != (Atom *) -1) {
		report("Atom list pointer variable was updated when the WM_COLORMAP_WINDOWS property had type ATOM.");
		FAIL;
	} else
		CHECK;

	if( rcnt != -1) {
		report("Atom count variable was updated when the WM_COLORMAP_WINDOWS property had type ATOM.");
		FAIL;
	} else
		CHECK;

	CHECKPASS(11);

>>ASSERTION Bad A
.ER BadWindow 
>># Kieron	Action	Review
