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
* Project: VSW5
*
* File: xts5/include/X11/Xaw/Box.h
*
* Description:
*	Defines used by the version of Athena widgets include in VSW5
*
* Modifications:
* $Log: Box.h,v $
* Revision 1.2  2005-11-03 08:42:01  jmichael
* clean up all vsw5 paths to use xts5 instead.
*
* Revision 1.1.1.2  2005/04/15 14:05:07  anderson
* Reimport of the base with the legal name in the copyright fixed.
*
* Revision 8.0  1998/12/23 23:23:00  mar
* Branch point for Release 5.0.2
*
* Revision 7.0  1998/10/30 22:41:00  mar
* Branch point for Release 5.0.2b1
*
* Revision 6.0  1998/03/02 05:15:33  tbr
* Branch point for Release 5.0.1
*
* Revision 5.0  1998/01/26 03:12:05  tbr
* Branch point for Release 5.0.1b1
*
* Revision 4.0  1995/12/15 08:38:55  tbr
* Branch point for Release 5.0.0
*
* Revision 3.1  1995/12/15  00:34:56  andy
* Prepare for GA Release
*
*/

/***********************************************************
Copyright 1987, 1988 by Digital Equipment Corporation, Maynard, Massachusetts,
and the Massachusetts Institute of Technology, Cambridge, Massachusetts.

                        All Rights Reserved

Permission to use, copy, modify, and distribute this software and its 
documentation for any purpose and without fee is hereby granted, 
provided that the above copyright notice appear in all copies and that
both that copyright notice and this permission notice appear in 
supporting documentation, and that the names of Digital or MIT not be
used in advertising or publicity pertaining to distribution of the
software without specific, written prior permission.  

DIGITAL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
DIGITAL BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
SOFTWARE.

******************************************************************/

#ifndef _XawBox_h
#define _XawBox_h

#include <X11/Xmu/Converters.h>

/***********************************************************************
 *
 * Box Widget (subclass of CompositeClass)
 *
 ***********************************************************************/

/* Parameters:

 Name		     Class		RepType		Default Value
 ----		     -----		-------		-------------
 background	     Background		Pixel		XtDefaultBackground
 border		     BorderColor	Pixel		XtDefaultForeground
 borderWidth	     BorderWidth	Dimension	1
 destroyCallback     Callback		Pointer		NULL
 hSpace 	     HSpace		Dimension	4
 height		     Height		Dimension	0
 mappedWhenManaged   MappedWhenManaged	Boolean		True
 orientation	     Orientation	XtOrientation	vertical
 vSpace 	     VSpace		Dimension	4
 width		     Width		Dimension	0
 x		     Position		Position	0
 y		     Position		Position	0

*/


/* New fields */
#ifndef _XtStringDefs_h_
#define XtNhSpace "hSpace"
#define XtNvSpace "vSpace"
#endif

/* Class record constants */

extern WidgetClass boxWidgetClass;

typedef struct _BoxClassRec *BoxWidgetClass;
typedef struct _BoxRec      *BoxWidget;

#endif /* _XawBox_h */
