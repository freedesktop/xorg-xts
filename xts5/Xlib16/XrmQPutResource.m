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
>># File: xts5/Xlib16/XrmQPutResource.m
>># 
>># Description:
>># 	Tests for XrmQPutResource()
>># 
>># Modifications:
>># $Log: rmqptrsrc.m,v $
>># Revision 1.2  2005-11-03 08:42:59  jmichael
>># clean up all vsw5 paths to use xts5 instead.
>>#
>># Revision 1.1.1.2  2005/04/15 14:05:22  anderson
>># Reimport of the base with the legal name in the copyright fixed.
>>#
>># Revision 8.0  1998/12/23 23:34:20  mar
>># Branch point for Release 5.0.2
>>#
>># Revision 7.0  1998/10/30 22:56:39  mar
>># Branch point for Release 5.0.2b1
>>#
>># Revision 6.0  1998/03/02 05:25:40  tbr
>># Branch point for Release 5.0.1
>>#
>># Revision 5.0  1998/01/26 03:22:12  tbr
>># Branch point for Release 5.0.1b1
>>#
>># Revision 4.0  1995/12/15 09:10:17  tbr
>># Branch point for Release 5.0.0
>>#
>># Revision 3.1  1995/12/15  01:12:38  andy
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
>>TITLE XrmQPutResource Xlib16
void

XrmDatabase *database = &xqpr_database;
XrmBindingList bindings = xqpr_bindings;
XrmQuarkList quarks = xqpr_quarks;
XrmRepresentation type;
XrmValue *value = &xqpr_value;
>>SET startup rmstartup
>>EXTERN
static XrmDatabase xqpr_database;
static XrmBinding xqpr_bindings[10];
static XrmQuark xqpr_quarks[10];
static XrmValue xqpr_value;

>>INCLUDE putres.mc
>>ASSERTION Good A
A call to xname adds a resource
specified by
.A bindings
and
.A quarks
with the specified
.A value
to the specified
.A database
with a
.A type
representation type.
>>STRATEGY
Create an empty test database.
Call xname to add database entries.
Call XrmGetResource to verify the database entries were added.
>>CODE
int i,j;

/* Create an empty test database. */
	xqpr_database = xrm_create_database("");
	if (xqpr_database = (XrmDatabase)NULL) {
		delete("Could not create test database.");
		return;
	} else
		CHECK;

/* Call xname to add database entries. */
/* Call XrmGetResource to verify the database entries were added. */
	for(i=0; i<XRM_T1_TESTS; i++) {
		for(j=0; qt1_specifiers[i][j] != (char *)NULL; j++) {
			xqpr_quarks[j]=XrmStringToQuark(qt1_specifiers[i][j]);
			xqpr_bindings[j]=qt1_bindings[i][j];
		}
		xqpr_quarks[j]=(XrmQuark)0;
		type = XrmStringToRepresentation(t1_types[i]);
		xrm_fill_value(value, t1_values[i]);
		XCALL;
		if(xrm_check_entry(xqpr_database,
			t1_fspecs[i], t1_fclasses[i],
			t1_types[i], t1_values[i])) {
			FAIL;
		} else
			CHECK;
	}

#ifdef TESTING
	XrmPutFileDatabase(xqpr_database, "xqpr_one");
#endif

	CHECKPASS(1+XRM_T1_TESTS);

	XrmDestroyDatabase(xqpr_database);

>>ASSERTION Good A
When the 
.A database
contains an entry for the resource name specified by
.A bindings 
and
.A quarks ,
then a call to xname replaces the resource value in the
.A database
with
.A value ,
and the resource type with
.A type .
>>STRATEGY
Create an empty test database.
Call xname to add a database entry.
Call xname to replace a database entry.
Verify the database entry was updated as expected.
>>CODE
	int i,j;

/* Create an empty test database. */
	xqpr_database = xrm_create_database("");
	if (xqpr_database = (XrmDatabase)NULL) {
		delete("Could not create test database.");
		return;
	} else
		CHECK;

/* Call xname to add a database entry. */
/* Call xname to replace a database entry. */
	for(i=0; i<2; i++) {
		for(j=0; qt2_specifier[j] != (char *)NULL; j++) {
			xqpr_quarks[j]=XrmStringToQuark(qt2_specifier[j]);
			xqpr_bindings[j]=qt2_bindings[j];
		}
		xqpr_quarks[j]=(XrmQuark)0;
		type = XrmStringToRepresentation(t2_types[i]);
		xrm_fill_value(value, t2_values[i]);
		XCALL;
		CHECK;
	}

/* Verify the database entry was updated as expected. */
	if(xrm_check_entry(xqpr_database,
		t2_fullspec, t2_fullclass,
		t2_types[1], t2_values[1])) {
			FAIL;
			report("%s did not update the database contents as expected.",
				TestName);
		} else
			CHECK;

	CHECKPASS(4);

#ifdef TESTING
	XrmPutFileDatabase(xqpr_database, "xqpr_two");
#endif

	XrmDestroyDatabase(xqpr_database);

>>ASSERTION Good A
When
.A database
is NULL, then a call to xname
creates a new database,
adds a resource
specified by
.A bindings
and
.A quarks
with the specified
.A value
to the database
with a
.A type
representation type, and returns a pointer to the database in
.A database .
>>STRATEGY
Call xname to add data to a NULL database.
Verify that the database was created, and the data was added as expected.
>>CODE
int j;

/* Call xname to add data to a NULL database. */
	xqpr_database = (XrmDatabase)NULL;
	for(j=0; qt2_specifier[j] != (char *)NULL; j++) {
		xqpr_quarks[j]=XrmStringToQuark(qt2_specifier[j]);
		xqpr_bindings[j]=qt2_bindings[j];
	}
	xqpr_quarks[j]=(XrmQuark)0;

	type = XrmStringToRepresentation(t2_types[0]);
	xrm_fill_value(value, t2_values[0]);
	XCALL;

/* Verify that the database was created, and the data was added as expected. */
	if (xqpr_database== (XrmDatabase)NULL) {
		FAIL;
		report("%s did not create a new database when called with",
			TestName);
		report("*database=(XrmDatabase)NULL");
	} else {
		CHECK;
		if(xrm_check_entry(xqpr_database,
			t2_fullspec, t2_fullclass,
			t2_types[0], t2_values[0])) {
				FAIL;
				report("%s did not add to the database as expected.",
					TestName);
			} else
				CHECK;
	}

	CHECKPASS(2);

#ifdef TESTING
	XrmPutFileDatabase(xqpr_database, "xqpr_three");
#endif

	XrmDestroyDatabase(xqpr_database);
