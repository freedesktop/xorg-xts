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
>># File: xts5/tset/Xlib15/XStringListToTextProperty/XStringListToTextProperty.m
>># 
>># Description:
>># 	Tests for XStringListToTextProperty()
>># 
>># Modifications:
>># $Log: strlstttxt.m,v $
>># Revision 1.2  2005-11-03 08:42:51  jmichael
>># clean up all vsw5 paths to use xts5 instead.
>>#
>># Revision 1.1.1.2  2005/04/15 14:05:21  anderson
>># Reimport of the base with the legal name in the copyright fixed.
>>#
>># Revision 8.0  1998/12/23 23:34:02  mar
>># Branch point for Release 5.0.2
>>#
>># Revision 7.0  1998/10/30 22:56:04  mar
>># Branch point for Release 5.0.2b1
>>#
>># Revision 6.0  1998/03/02 05:25:23  tbr
>># Branch point for Release 5.0.1
>>#
>># Revision 5.0  1998/01/26 03:21:56  tbr
>># Branch point for Release 5.0.1b1
>>#
>># Revision 4.1  1996/05/09 00:29:03  andy
>># Corrected Xatom include
>>#
>># Revision 4.0  1995/12/15  09:09:29  tbr
>># Branch point for Release 5.0.0
>>#
>># Revision 3.1  1995/12/15  01:11:32  andy
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
>>TITLE XStringListToTextProperty Xlib15
Status
XStringListToTextProperty(list, count, text_prop_return)
char		**list;
int		count;
XTextProperty	*text_prop_return;
>>EXTERN
#include	"X11/Xatom.h"
>>#
>># COMMENT: 	This assertion is wrong about the nitems component.
>>#		Its value is the sum of the string lengths plus the
>>#		null separators.
>>#
>>#	Cal 11/6/91
>>#
>># >>ASSERTION Good A
>># A call to xname sets the
>># .S XTextProperty 
>># structure named by the
>># .A text_prop_return
>># argument such that the
>># .M format
>># component is 8,
>># the
>># .M encoding
>># component is STRING, the
>># .M value 
>># component is the null-separated concatenation of 
>># .A count
>># of the character strings specified by the
>># .A list
>># argument and terminated with an ASCII nul, the
>># .M nitems
>># component is the number of null-terminated character strings
>># and returns non-zero.
>>ASSERTION Good A
A call to xname sets the
.S XTextProperty 
structure named by the
.A text_prop_return
argument such that the
.M format
component is 8,
the
.M encoding
component is STRING, the
.M value 
component is the null-separated concatenation of 
.A count
of the character strings specified by the
.A list
argument and terminated with an ASCII nul, the
.M nitems
component is the total number of characters and
separating nulls
and returns non-zero.
>>STRATEGY
Create a window using XCreateWindow.
Create a XTextPropertyStructure using XStringListToTextProperty with three strings.
Verify that the call did not return zero.
Verify that the format component is 8.
Verify that the encoding component is STRING.
Verify that the value field is correctly set
Verify that the nitems field is correctly set.
Set the property WM_NAME to the returned XTextProperty using XSetTextProperty.
Verify that no error occurred.
Create a XTextPropertyStructure using XStringListToTextProperty no strings.
Verify that the call did not return zero.
Set the property WM_NAME to the returned XTextProperty using XSetTextProperty.
Verify that no error occurred.
>>CODE
Status		status;
char		*str1 = "XtestString1_._.";
char		*str2 = "XtextString2._";
char		*str3 = "XtestString3._..";
char		*argv[3];
char		*value, *vp;
int		argc = 3;
int		i;
int		len;
XTextProperty	tp;
Window		win;
XVisualInfo	*vi;

	resetvinf(VI_WIN);
	nextvinf(&vi);
	win = makewin(Dsp, vi);

	argv[0] = str1;
	argv[1] = str2;
	argv[2] = str3;

	len = 0;
	for(i=0; i< argc; i++)
		len += strlen(argv[i]) + 1;
	
	if((value = (char *)malloc(len)) == NULL) {
		delete("malloc() returned NULL.");
		return;
	} else
		CHECK;

	len--;
	vp = value;
	for(i=0; i< argc; i++) {
		strcpy(vp, argv[i]);
		vp += strlen(argv[i]) + 1;
		
	}

	list = argv;
	count = argc;
	text_prop_return = &tp;
	status = XCALL;

	if(status == 0) {
		delete("%s() returned zero.", TestName);
		return;
	} else
		CHECK;

	if( tp.format != 8 ) {
		report("The format component of the XTextProperty structure was %d instead of %d.", tp.format, 8);
		FAIL;
	} else
		CHECK;

	if( tp.encoding != XA_STRING) {
		report("The encoding component of the XTextProperty structure was %ld instead of %ld.", 
			(long) tp.encoding, (long) XA_STRING);
		FAIL;
	} else
		CHECK;

	if(tp.nitems != len) {
		report("The nitems component of the XTextProperty structure was %ld instead of %ld.", tp.nitems, len);
		FAIL;
	} else 
		CHECK;

	if(tp.value == NULL) {
		report("The value component of the XTextProperty structure was NULL.");
		FAIL;
	} else {
		CHECK;

		if(memcmp(tp.value, value, len+1) != 0) {
			report("The value component of the XTextProperty was not correct.");
			FAIL;
		} else
			CHECK;

		startcall(Dsp);
		XSetTextProperty(Dsp, win, &tp, XA_WM_NAME);
		endcall(Dsp);

		if(geterr() != Success) {
			report("Could not set property WM_NAME with the returned XTextProperty.");
			FAIL;
		} else
			CHECK;

		XFree((char*)tp.value);
	}


	free(value);

	list = (char **) NULL;
	count = 0;
	text_prop_return = &tp;
	status = XCALL;

	if(status == 0) {
		delete("%s() returned zero.", TestName);
		return;
	} else
		CHECK;

	startcall(Dsp);
	XSetTextProperty(Dsp, win, &tp, XA_WM_NAME);
	endcall(Dsp);

	if(geterr() != Success) {
		report("Could not set property WM_NAME with the returned XTextProperty.");
		FAIL;
	} else
		CHECK;

	if(tp.value != (unsigned char *) NULL)
		XFree((char*)tp.value);

	CHECKPASS(10);		

>>ASSERTION Bad B 1
When insufficient memory is available for the new value string, then 
a call to xname does not set any fields in the
.S XTextProperty 
structure and returns zero.
>>ASSERTION Good A
The new value string returned by a call to xname can be freed with XFree.
>>STRATEGY
Create a XTextProperty structure using XStringListToTextProperty.
Verify that the call did not return zero.
Release the allocated memory using XFree.
>>CODE
Status		status;
char		*str1 = "XtestString1_._.";
char		*str2 = "XtextString2._";
char		*str3 = "XtestString3._..";
char		*argv[3];
int		argc = 3;
XTextProperty	tp;

	argv[0] = str1;
	argv[1] = str2;
	argv[2] = str3;

	list = argv;
	count = argc;
	text_prop_return = &tp;
	status = XCALL;

	if(status == 0) {
		delete("%s() returned zero.", TestName);
		return;
	} else
		CHECK;

	if(tp.value == NULL) {
		report("The value component of the XTextProperty structure was NULL.");
		FAIL;
	} else {
		CHECK;
		XFree((char*)tp.value);
	}

	CHECKPASS(2);
>># Kieron	Completed	Review
