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
>># File: xts5/tset/Xlib7/XFreeColormap/XFreeColormap.m
>># 
>># Description:
>># 	Tests for XFreeColormap()
>># 
>># Modifications:
>># $Log: frclrmp.m,v $
>># Revision 1.2  2005-11-03 08:43:43  jmichael
>># clean up all vsw5 paths to use xts5 instead.
>>#
>># Revision 1.1.1.2  2005/04/15 14:05:31  anderson
>># Reimport of the base with the legal name in the copyright fixed.
>>#
>># Revision 8.0  1998/12/23 23:26:57  mar
>># Branch point for Release 5.0.2
>>#
>># Revision 7.0  1998/10/30 22:45:16  mar
>># Branch point for Release 5.0.2b1
>>#
>># Revision 6.0  1998/03/02 05:19:10  tbr
>># Branch point for Release 5.0.1
>>#
>># Revision 5.0  1998/01/26 03:15:42  tbr
>># Branch point for Release 5.0.1b1
>>#
>># Revision 4.0  1995/12/15 08:49:17  tbr
>># Branch point for Release 5.0.0
>>#
>># Revision 3.1  1995/12/15  00:48:31  andy
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
>>TITLE XFreeColormap Xlib7
void
XFreeColormap(display, colormap)
Display *display = Dsp;
Colormap colormap = DefaultColormap(display, DefaultScreen(display));
>>ASSERTION Good A
A call to xname 
removes the association between the
.A colormap
argument
and the colourmap ID, and frees the associated storage.
>>STRATEGY
For each supported visual type:
  Create a colourmap with XCreateColormap.
  Free the colourmap with XFreeColormap.
  Verify that XAllocColor fails.
>>CODE
XVisualInfo *vi;
unsigned long vmask;
XColor col;

	if( (vmask = visualsupported(display, 0L)) == 0L) {
		delete("No visuals are supported.");
		return;
	}

	for(resetsupvis(vmask); nextsupvis(&vi); ) {
		trace("Attempting XFreeColormap() for class %s", displayclassname(vi->class));
		colormap = XCreateColormap(display, DRW(display), vi->visual, AllocNone);

		XCALL;

		startcall(display);
		XAllocColor(display, colormap, &col);
		endcall(display);

		if( geterr() == Success) {
			report("XAllocColor() succeeded with a freed colormap");
			FAIL;
		} else
			CHECK;
	}

	CHECKPASS(nsupvis());

>>ASSERTION Good A
When the 
.A colormap
argument is the default colourmap, then a call to xname
does not remove the association between the
.A colormap
argument
and the colourmap ID or free the associated storage.
>>STRATEGY
Free the default colourmap with XFreeColormap.
Verify that XAllocColor succeeds in allocating 1 shared cell with this colormap.
>>CODE
XColor col;

	col.red = col.green = col.blue = 0;
	colormap = DefaultColormap(display, DefaultScreen(display));
	XCALL;
	if(XAllocColor(display, colormap, &col) == False) {
		report("XAllocColor() failed to allocate a colourcell with the default colormap.");
		FAIL;
	} else
		PASS;

>>ASSERTION Good A
When the 
.A colormap
argument is an installed colourmap, then a call to xname uninstalls the colourmap.
>>STRATEGY
For each visual class:
  Create a colourmap with XCreateColormap.
  Install the colourmap with XInstallColormap.
  Obtain a list of installed colourmaps with XListInstalledColormaps.
  Verify that the created colourmap is in the list.
  Free the colourmap with XFreeColormap.
  Obtain a list of installed colourmaps with XListInstalledColormaps.
  Verify that the created colourmap is not in the list.
>>CODE
int i, len, notfound;
XVisualInfo *vi;
Colormap *maplist;
unsigned long vmask;
XColor col;

	if( (vmask = visualsupported(display, 0L)) == 0L) {
		delete("No visuals are supported.");
		return;
	}

	for(resetsupvis(vmask); nextsupvis(&vi); ) {
		trace("Attempting XFreeColormap() for class %s", displayclassname(vi->class));
		colormap = XCreateColormap(display, DRW(display), vi->visual, AllocNone);


		XAllocColor(display, colormap, &col);
		XInstallColormap(display, colormap);
		maplist = XListInstalledColormaps(display, DRW(display), &len);
		for(i=0, notfound = 1; i<len  && notfound; i++ )
			if(maplist[i] == colormap) {
				CHECK;
				trace("Found map at position %d of the required list", i);
				notfound = 0;
			}

		XFree((char*)maplist);
		if(notfound) {
			delete("The installed colourmap was not on the required list.");
			return;
		}

		XCALL;

		maplist = XListInstalledColormaps(display, DRW(display), &len);

		for(i=0, notfound = 1 ; i<len && notfound; i++)
			if(maplist[i] == colormap) {
				report("Colormap is still on the required list.");
				FAIL;
				notfound = 0;
			}

		XFree((char*)maplist);

		if(notfound == 1)
			CHECK;
	}

	CHECKPASS(2*nvinf());

>>ASSERTION Good A
When the specified colourmap is defined as the colourmap for a window,
then a call to xname changes the colourmap associated with the window to
.S None 
and generates a
.S ColormapNotify 
event.
>>STRATEGY
For each supported visual class:
  Create a colourmap with XCreateColormap.
  Create a window with XCreateWindow.
  Select ColormapNotify events with XSelectInput.
  Make the colormap the colormap for the window with XSetWindowColormap.
  Free the colormap with XFreeColormap
  Verify that a ColorMapnotify event was generated with XNextEvent.
  Verify that the window's colourmap is set to none with XGetWindowAttributes.
>>CODE
int i, len, notfound;
XVisualInfo *vi;
XWindowAttributes watts;
XEvent ev;
Colormap *maplist;
unsigned long vmask;
XColor col;
Window win;

	if( (vmask = visualsupported(display, 0L)) == 0L) {
		delete("No visuals are supported.");
		return;
	}

	for(resetsupvis(vmask); nextsupvis(&vi); ) {
		trace("Attempting XFreeColormap() for class %s", displayclassname(vi->class));
		colormap = XCreateColormap(display, DRW(display), vi->visual, AllocNone);
		XAllocColor(display, colormap, &col);

		win = makewin(display, vi);
		XSetWindowColormap(display, win, colormap);
		XGetWindowAttributes(display, win, &watts);

		XSelectInput(display, win, ColormapChangeMask);

		
		if(watts.colormap != colormap) {
			delete("XSetWindowColormap() did not set the window colormap.");
			return;
		}

		XInstallColormap(display, colormap);

		XCALL;

		XGetWindowAttributes(display, win, &watts);
		if(watts.colormap != None) {
			report("Colormap of window was not set to None.");
			FAIL;
		}

		if(getevent(display, &ev) == 0) {
			report("No Event was generated");
			FAIL;
		} else
			if(ev.type != ColormapNotify) {
				report("Event generated was not ColormapNotify");
				FAIL;
			} else
				CHECK;

	}

	CHECKPASS(nsupvis());

>>ASSERTION Bad A
.ER BadColor
>>#HISTORY	Cal	Completed	Written in new format and style - Cal	4/12/90.
>>#HISTORY	Kieron	Completed		<Have a look>
