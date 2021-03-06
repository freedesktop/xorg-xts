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

Copyright (c) 1999 The Open Group
Copyright (c) Applied Testing and Technology, Inc. 1993, 1994, 1995
Copyright (c) 88open Consortium, Ltd. 1990, 1991, 1992, 1993
All Rights Reserved.

>># 
>># Project: VSW5
>># 
>># File: xts/Xt9/XtAppAddInput.m
>># 
>># Description:
>>#	Tests for XtAppAddInput()
>># 
>># Modifications:
>># $Log: tapaddinp.m,v $
>># Revision 1.2  2005-04-21 09:40:42  ajosey
>># resync to VSW5.1.5
>>#
>># Revision 8.2  2005/01/21 12:20:01  gwc
>># Updated copyright notice
>>#
>># Revision 8.1  1999/11/26 10:53:14  vsx
>># avoid fixed file locations (for exec-in-place false)
>>#
>># Revision 8.0  1998/12/23 23:36:56  mar
>># Branch point for Release 5.0.2
>>#
>># Revision 7.0  1998/10/30 22:59:49  mar
>># Branch point for Release 5.0.2b1
>>#
>># Revision 6.0  1998/03/02 05:28:03  tbr
>># Branch point for Release 5.0.1
>>#
>># Revision 5.0  1998/01/26 03:24:37  tbr
>># Branch point for Release 5.0.1b1
>>#
>># Revision 4.0  1995/12/15 09:17:59  tbr
>># Branch point for Release 5.0.0
>>#
>># Revision 3.2  1995/12/15  02:11:11  andy
>># Prepare for GA Release
>>#
>>EXTERN
#include <X11/IntrinsicP.h>
#include <X11/ConstrainP.h>
#include <X11/CoreP.h>

XtAppContext app_ctext;
Widget topLevel, panedw, boxw1, boxw2;
Widget labelw, rowcolw, click_quit;

/* procedure XtTMO_Proc */
void XtTMO_Proc(client_data, id)
XtPointer client_data;
XtIntervalId *id;
{
	XtDestroyWidget(topLevel);
	exit(0);
}
XtInputId input_ret;
char *msg = "Hello World";
FILE *fid;
/* Procedure XtIOP_Proc */
void XtIOP_Proc(client_data, source, id)
XtPointer client_data;
int *source;
XtInputId *id;
{
	avs_set_event(1,1);
	tet_infoline("TEST: InputID passed to procedure matches return from XtAddInput");
	if (*id != input_ret) {
		sprintf(ebuf, "ERROR: InputId passed to procedure was %#x, InputId returned by XtAddInput was %#x, should be identical", id, input_ret);
		tet_infoline(ebuf);
		tet_result(TET_FAIL);
	}
	tet_infoline("TEST: Source passed to procedure matches that passed to XtAddInput");
	if (*source != fileno(fid)) {
		sprintf(ebuf, "ERROR: Source passed to procedure was %#x, source passed to XtAddInput was %#x, should be identical", *source, fileno(fid));
		tet_infoline(ebuf);
		tet_result(TET_FAIL);
	}
	tet_infoline("TEST: Client data passed to procedure matches that passed to XtAddInput");
	if (strncmp(client_data, msg, sizeof(msg)) != 0) {
		sprintf(ebuf, "ERROR: Client_data passed to procedure was %s, client_data passed to XtAddInput was %s, should be identical", client_data, msg);
		tet_infoline(ebuf);
		tet_result(TET_FAIL);
	}
	exit(0);
}
>>SET tpstartup avs_alloc_sem
>>SET tpcleanup avs_free_sem
>>TITLE XtAppAddInput Xt9
XtInputId
XtAppAddInput(app_context, sources, condition, proc, client_data)
>>ASSERTION Good C
If the implementation is POSIX-based:
A successful call to
XtInputId XtAppAddInput(app_context, sources, 
condition, proc, client_data)
when condition is XtInputReadMask shall register 
.A proc 
as the procedure that will be called 
for the application
context
.A app_context
when the file descriptor 
.A source 
has data to be read and return an identifier for it.
>>CODE
const char *data;
int status;
pid_t pid2;

if (config.posix_system != 0) {
	data = outfile("tapaddinp.dat");
	FORK(pid2);
	avs_xt_hier("Tapaddinp1", "XtAppAddInput");
	sprintf(ebuf, "PREP: Open file %s for read", data);
	tet_infoline(ebuf);
	if ((fid = (FILE *)fopen(data, "w+")) == NULL) {
		sprintf(ebuf, "ERROR: Could not open file %s", data);
		tet_infoline(ebuf);
		tet_result(TET_FAIL);
	}
	tet_infoline("PREP: Register the file as input source");
	input_ret = XtAppAddInput(app_ctext, fileno(fid), (XtPointer)XtInputReadMask, XtIOP_Proc, (XtPointer)msg);
	XtAppAddTimeOut(app_ctext, AVSXTLOOPTIMEOUT, XtTMO_Proc, topLevel);
	tet_infoline("PREP: Create windows for widgets and map them");
	XtRealizeWidget(topLevel);
	tet_infoline("TEST: Input procedure is invoked");
	XtAppMainLoop(app_ctext);
	KROF(pid2);
	unlink(data);
	status = avs_get_event(1);
	check_dec(1, status, "XtIOP_Proc invoked status");
	tet_result(TET_PASS);
}else {
	tet_infoline("INFO: Not configured as a POSIX system");
	tet_result(TET_UNSUPPORTED);
}

>>ASSERTION Good C
If the implementation is POSIX-based:
A successful call to
XtInputId XtAppAddInput(app_context, sources, condition, 
proc, client_data)
when condition is XtInputWriteMask shall register proc as the procedure 
that will be called for the application context
.A app_context
when the file descriptor 
.A source 
is ready for writing.
>>CODE
const char *data;
int status;
pid_t pid2;

if (config.posix_system != 0) {
	avs_xt_hier("Tapaddinp1", "XtAppAddInput");
	data = outfile("tapaddinp.dat");
	FORK(pid2);
	sprintf(ebuf, "PREP: Open file %s for write", data);
	tet_infoline(ebuf);
	if ((fid = (FILE *)fopen(data, "w+")) == NULL) {
		sprintf(ebuf, "ERROR: Could not open file %s", data);
		tet_infoline(ebuf);
		tet_result(TET_FAIL);
	}
	tet_infoline("PREP: Register the file as input source");
	input_ret = XtAppAddInput(app_ctext, fileno(fid), (XtPointer)XtInputWriteMask, XtIOP_Proc, (XtPointer)msg);
	XtAppAddTimeOut(app_ctext, AVSXTLOOPTIMEOUT, XtTMO_Proc, topLevel);
	tet_infoline("PREP: Create windows for widgets and map them");
	XtRealizeWidget(topLevel);
	tet_infoline("TEST: Input procedure is invoked");
	XtAppMainLoop(app_ctext);
	KROF(pid2);
	unlink(data);
	status = avs_get_event(1);
	check_dec(1, status, "XtIOP_Proc invoked status");
	tet_result(TET_PASS);
}else {
	tet_infoline("INFO: Not configured as a POSIX system");
	tet_result(TET_UNSUPPORTED);
}
>>ASSERTION Good D 1
If the implementation is POSIX-based:
A successful call to
XtInputId XtAppAddInput(app_context, sources, condition, 
proc, client_data)
when condition is XtInputExceptMask shall register proc as the procedure 
that will be called for the application context
.A app_context
when the file descriptor 
.A source 
has exception data.
>>ASSERTION Good D 3
If the implementation is POSIX-based:
A call to
XtInputId XtAppAddInput(app_context, sources, condition, 
proc, client_data)
when 
.A condition 
is some combination of XtInputReadMask, XtInputWriteMask, and 
XtInputExceptMask shall be the equivalent of separate calls to 
XtAppAddInput for each option specified in 
.A condition.
>>ASSERTION Good C
If the implementation is POSIX-based:
A successful call to
XtInputId XtAppAddInput(app_context, sources, condition, 
proc, client_data)
shall cause 
.A client_data
to be passed to
.A proc
when it is invoked.
>>CODE
const char *data;
int status;
pid_t pid2;

if (config.posix_system != 0) {
	avs_xt_hier("Tapaddinp1", "XtAppAddInput");
	data = outfile("tapaddinp.dat");
	FORK(pid2);
	sprintf(ebuf, "PREP: Open file %s for read", data);
	tet_infoline(ebuf);
	if ((fid = (FILE *)fopen(data, "w+")) == NULL) {
		sprintf(ebuf, "ERROR: Could not open file %s", data);
		tet_infoline(ebuf);
		tet_result(TET_FAIL);
	}
	tet_infoline("PREP: Register the file as input source");
	input_ret = XtAppAddInput(app_ctext, fileno(fid), (XtPointer)XtInputReadMask, XtIOP_Proc, (XtPointer)msg);
	XtAppAddTimeOut(app_ctext, AVSXTLOOPTIMEOUT, XtTMO_Proc, topLevel);
	tet_infoline("PREP: Create windows for widgets and map them");
	XtRealizeWidget(topLevel);
	tet_infoline("TEST: Input procedure is invoked");
	XtAppMainLoop(app_ctext);
	KROF(pid2);
	unlink(data);
	status = avs_get_event(1);
	check_dec(1, status, "XtIOP_Proc invoked status");
	tet_result(TET_PASS);
}else {
	tet_infoline("INFO: Not configured as a POSIX system");
	tet_result(TET_UNSUPPORTED);
}
