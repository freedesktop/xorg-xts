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
>># File: xts5/tset/Xlib11/MappingNotify/MappingNotify.m
>># 
>># Description:
>># 	Tests for MappingNotify()
>># 
>># Modifications:
>># $Log: mppngntfy.m,v $
>># Revision 1.2  2005-11-03 08:42:29  jmichael
>># clean up all vsw5 paths to use xts5 instead.
>>#
>># Revision 1.1.1.2  2005/04/15 14:05:18  anderson
>># Reimport of the base with the legal name in the copyright fixed.
>>#
>># Revision 8.0  1998/12/23 23:31:19  mar
>># Branch point for Release 5.0.2
>>#
>># Revision 7.0  1998/10/30 22:50:56  mar
>># Branch point for Release 5.0.2b1
>>#
>># Revision 6.0  1998/03/02 05:22:59  tbr
>># Branch point for Release 5.0.1
>>#
>># Revision 5.0  1998/01/26 03:19:32  tbr
>># Branch point for Release 5.0.1b1
>>#
>># Revision 4.0  1995/12/15 09:01:46  tbr
>># Branch point for Release 5.0.0
>>#
>># Revision 3.1  1995/12/15  00:58:45  andy
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
>>TITLE MappingNotify Xlib11
>>EXTERN
#define	EVENT		MappingNotify
>>ASSERTION Good A
When a xname event is generated,
a xname event is delivered to all clients.
>>STRATEGY
Create client2.
Generate MappingNotify event.
Verify that MappingNotify event was delivered.
Verify members in delivered event structure.
Verify that MappingNotify event was delivered to client2.
Verify members in delivered event structure.
>>CODE
Display	*display = Dsp;
Display	*client2;
XEvent	event_return;
int	nmap;
int	count;
unsigned char *map;
unsigned char buf[2];

/* Create client2. */
	if ((client2 = opendisplay()) == (Display *) NULL) {
		delete("Couldn't create client2.");
		return;
	}
	else
		CHECK;
/* Generate MappingNotify event. */
	nmap = XGetPointerMapping(display, buf, sizeof(buf));
	if (nmap < 1) {
		report("XGetPointerMapping returned %d, expected greater than 0", nmap);
		delete("Can't determine size of pointer mapping buffer");
		return;
	}
	else
		CHECK;
	map = (unsigned char *) malloc((unsigned int) (nmap * sizeof(*map)));
	if (map == (unsigned char *) NULL) {
		report("Couldn't allocate %d bytes", nmap * sizeof(*map));
		delete("Memory allocation error");
		return;
	}
	else
		CHECK;
	count = XGetPointerMapping(display, map, nmap);
	if (count < nmap) {
		report("XGetPointerMapping returned %d, expected %d",
			count, nmap);
		delete("XGetPointerMapping inconsistencies");
		free(map);
		return;
	}
	else
		CHECK;
	XSync(display, True);
	XSync(client2, True);
	count = XSetPointerMapping(display, map, nmap);
	if (count != Success) {
		report("XSetPointerMapping returned %d, expected %d",
			count, Success);
		delete("XSetPointerMapping failed");
		free(map);
		return;
	}
	else
		CHECK;
	XSync(display, False);
	XSync(client2, False);
/* Verify that MappingNotify event was delivered. */
	if (!XCheckTypedEvent(display, EVENT, &event_return)) {
		report("No events generated, expected %s event",
			eventname(EVENT));
		FAIL;
	}
	else {
		XMappingEvent good;

/* Verify members in delivered event structure. */
		good = event_return.xmapping;
		good.type = EVENT;
		good.request = MappingPointer;
		if (checkevent((XEvent *) &good, &event_return)) {
			report("Unexpected values in delivered event");
			FAIL;
		}
		else
			CHECK;
	}
/* Verify that MappingNotify event was delivered to client2. */
	if (!XCheckTypedEvent(client2, EVENT, &event_return)) {
		report("No events generated, expected %s event with client2",
			eventname(EVENT));
		FAIL;
	}
	else {
		XMappingEvent good;

/* Verify members in delivered event structure. */
		good = event_return.xmapping;
		good.type = EVENT;
		good.request = MappingPointer;
		if (checkevent((XEvent *) &good, &event_return)) {
			report("Unexpected values in delivered event with client2");
			FAIL;
		}
		else
			CHECK;
	}
	free(map);

	CHECKPASS(7);
>>#NOTEs >>ASSERTION
>>#NOTEs When ARTICLE xname event is delivered,
>>#NOTEs then
>>#NOTEs .M type
>>#NOTEs is set to
>>#NOTEs xname.
>>#NOTEs >>ASSERTION
>>#NOTEs >>#NOTE The method of expansion is not clear.
>>#NOTEs When ARTICLE xname event is delivered,
>>#NOTEs then
>>#NOTEs .M serial
>>#NOTEs is set
>>#NOTEs from the serial number reported in the protocol
>>#NOTEs but expanded from the 16-bit least-significant bits
>>#NOTEs to a full 32-bit value.
>>#NOTEm >>ASSERTION
>>#NOTEm When ARTICLE xname event is delivered
>>#NOTEm and the event came from a
>>#NOTEm .S SendEvent
>>#NOTEm protocol request,
>>#NOTEm then
>>#NOTEm .M send_event
>>#NOTEm is set to
>>#NOTEm .S True .
>>#NOTEs >>ASSERTION
>>#NOTEs When ARTICLE xname event is delivered
>>#NOTEs and the event was not generated by a
>>#NOTEs .S SendEvent
>>#NOTEs protocol request,
>>#NOTEs then
>>#NOTEs .M send_event
>>#NOTEs is set to
>>#NOTEs .S False .
>>#NOTEs >>ASSERTION
>>#NOTEs When ARTICLE xname event is delivered,
>>#NOTEs then
>>#NOTEs .M display
>>#NOTEs is set to
>>#NOTEs a pointer to the display on which the event was read.
>>#NOTEm >>ASSERTION
>>#NOTEm When a call is made to
>>#NOTEm .F XSetModifierMapping ,
>>#NOTEm then ARTICLE xname event is generated with
>>#NOTEm .M request
>>#NOTEm set to
>>#NOTEm .S MappingModifier .
>>#NOTEm >>ASSERTION
>>#NOTEm When a call is made to
>>#NOTEm .F XChangeKeyboardMapping ,
>>#NOTEm then ARTICLE xname event is generated with
>>#NOTEm .M request
>>#NOTEm set to
>>#NOTEm .S MappingKeyboard .
>>#NOTEm >>ASSERTION
>>#NOTEm When a call is made to
>>#NOTEm .F XSetPointerMapping ,
>>#NOTEm then ARTICLE xname event is generated with
>>#NOTEm .M request
>>#NOTEm set to
>>#NOTEm .S MappingPointer .
>>#NOTEs >>ASSERTION
>>#NOTEs When
>>#NOTEs .M request
>>#NOTEs is set to
>>#NOTEs .S MappingKeyboard ,
>>#NOTEs then
>>#NOTEs .M first_keycode
>>#NOTEs is set to the first number in the range of the altered mapping
>>#NOTEs and
>>#NOTEs .M count
>>#NOTEs is set to the number of keycodes altered.
