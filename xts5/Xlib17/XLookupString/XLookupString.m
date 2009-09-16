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
>># File: xts5/tset/Xlib17/XLookupString/XLookupString.m
>># 
>># Description:
>># 	Tests for XLookupString()
>># 
>># Modifications:
>># $Log: lkpstr.m,v $
>># Revision 1.2  2005-11-03 08:43:08  jmichael
>># clean up all vsw5 paths to use xts5 instead.
>>#
>># Revision 1.1.1.2  2005/04/15 14:05:23  anderson
>># Reimport of the base with the legal name in the copyright fixed.
>>#
>># Revision 8.0  1998/12/23 23:34:46  mar
>># Branch point for Release 5.0.2
>>#
>># Revision 7.0  1998/10/30 22:57:08  mar
>># Branch point for Release 5.0.2b1
>>#
>># Revision 6.0  1998/03/02 05:26:03  tbr
>># Branch point for Release 5.0.1
>>#
>># Revision 5.0  1998/01/26 03:22:36  tbr
>># Branch point for Release 5.0.1b1
>>#
>># Revision 4.1  1996/05/09 21:05:24  andy
>># Fixed keysymdef include
>>#
>># Revision 4.0  1995/12/15  09:11:25  tbr
>># Branch point for Release 5.0.0
>>#
>># Revision 3.1  1995/12/15  01:14:04  andy
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
>>TITLE XLookupString Xlib17
int
XLookupString(event_struct, buffer_return, bytes_buffer, keysym_return, status_in_out)
XKeyEvent	*event_struct;
char		*buffer_return;
int		bytes_buffer;
KeySym		*keysym_return;
XComposeStatus	*status_in_out;
>>EXTERN
#define XK_LATIN1
#define XK_MISCELLANY
#include	"X11/keysymdef.h"
#undef XK_MISCELLANY
#undef XK_LATIN1
>>ASSERTION Good A
A call to xname returns in the
.A keysym_return
argument the
.S KeySym
and in the
.A buffer_return
the string of maximum length
.A bytes_buffer
specified by the 
.M keycode
and
.M state
of the
.A event_struct
argument,
using the standard shift
modifier computations as defined in the X protocol specification,
and returns the length of the returned string.
>>STRATEGY
Obtain the keycode corresponding to the keysym XK_b using XKeysymToKeycode.
Obtain the string and keysym bound to that keycode using xname.
Verify that the returned string is correct.
Obtain the string and keysym bound to that keycode using xname with state = ShiftMask.
Verify that the returned string is correct.
>>CODE
KeySym		ks = 0;
KeyCode		kc;
static char	buf[]="Xtest uninitialised string.";
int		res;
int		cmplen;
int		mlen = strlen(buf);
XKeyEvent	ke;

	kc = XKeysymToKeycode(Dsp, XK_b);

	ke.type = KeyPress;
	ke.display = Dsp;
	ke.keycode = kc;
	ke.state = 0;

	event_struct = &ke;
	buffer_return = (char *) buf;
	bytes_buffer = mlen;
	keysym_return = &ks;
	status_in_out = (XComposeStatus *) NULL;

	res = XCALL;

	if(ks != XK_b) {
		report("%s() returned keysym %d instead of %d.", TestName, (int) ks, (int) XK_b);
		FAIL;
	} else
		CHECK;

	if(res != 1) {
		report("%s() returned %d instead of 1.", TestName, res);
		FAIL;
	} else
		CHECK;

	cmplen = mlen;
	if(res>0 && res<mlen)
		cmplen = res;
	buf[cmplen] = '\0';

	if(strncmp(buffer_return, "b", cmplen) != 0) {
		report("%s() returned string \"%s\" instead of \"b\".", TestName, buffer_return);
		FAIL;
	} else
		CHECK;

	ke.state = ShiftMask;
	event_struct = &ke;
	res = XCALL;

	if(ks != XK_B) {
		report("%s() returned keysym %d instead of %d.", TestName, (int) ks, (int) XK_B);
		FAIL;
	} else
		CHECK;

	cmplen = mlen;
	if(res>0 && res<mlen)
		cmplen = res;
	buf[cmplen] = '\0';

	if(strncmp(buffer_return, "B", cmplen) != 0) {
		report("%s() returned string \"%s\" instead of \"B\".", TestName, buffer_return);
		FAIL;
	} else
		CHECK;

	CHECKPASS(5);

>>ASSERTION Good A
When the
.S KeySym
corresponding to the
.A event_struct
argument has been rebound, then
the bound string is returned, truncated to
.A bytes_buffer ,
in the
.A buffer_return
argument.
>>STRATEGY
Rebind the keysym XK_c to the string XtestRebound using XRebindKeysym.
Obtain the keycode bound to the XK_c keysym using XKeysymToKeycode.
Obtain the first three characters of the string to which the keycode is bound using xname.
Verify that the returned string is correct.
>>CODE
KeySym		ks = 0;
KeyCode		kc;
static char	buf[]="XtestRebound";
static char	buf_ret[4];
int		res;
int		cmplen;
int		mlen = 3;
XKeyEvent	ke;

	kc = XKeysymToKeycode(Dsp, XK_c);
	XRebindKeysym(Dsp, XK_c, (KeySym *) NULL, 0, (unsigned char *) buf, strlen(buf));

	ke.type = KeyPress;
	ke.display = Dsp;
	ke.keycode = kc;
	ke.state = 0;

	event_struct = &ke;
	buffer_return = (char *) buf_ret;
	bytes_buffer = mlen;
	keysym_return = &ks;
	status_in_out = (XComposeStatus *) NULL;

	res = XCALL;

	if(ks != XK_c) {
		report("%s() returned keysym %d instead of %d.", TestName, (int) ks, (int) XK_b);
		FAIL;
	} else
		CHECK;

	if(res != mlen) {
		report("%s() returned %d instead of %d.", TestName, res, mlen);
		FAIL;
	} else
		CHECK;

	cmplen = mlen;
	if(res>0 && res<mlen)
		cmplen = res;
	buf[cmplen] = '\0';
	buffer_return[cmplen] = '\0';

	if(strncmp(buffer_return, buf, cmplen) != 0) {
		report("%s() returned string \"%s\" instead of \"%s\".", TestName, buffer_return, buf);
		FAIL;
	} else
		CHECK;

	CHECKPASS(3);

>>ASSERTION Good B 1
When the
.A status_in_out
argument is not NULL, then a call to xname
records in it the state of compose processing.
