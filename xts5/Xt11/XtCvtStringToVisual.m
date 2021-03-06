Copyright (c) 2005 X.Org Foundation LLC

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

Copyright (c) Applied Testing and Technology, Inc. 1993, 1994, 1995
Copyright (c) 88open Consortium, Ltd. 1990, 1991, 1992, 1993
All Rights Reserved.

>># 
>># Project: VSW5
>># 
>># File: xts/Xt11/XtCvtStringToVisual.m
>># 
>># Description:
>>#	Tests for XtCvtStringToVisual()
>># 
>># Modifications:
>># $Log: tcstvis.m,v $
>># Revision 1.1  2005-02-12 14:37:53  anderson
>># Initial revision
>>#
>># Revision 8.0  1998/12/23 23:37:35  mar
>># Branch point for Release 5.0.2
>>#
>># Revision 7.0  1998/10/30 23:00:32  mar
>># Branch point for Release 5.0.2b1
>>#
>># Revision 6.0  1998/03/02 05:28:39  tbr
>># Branch point for Release 5.0.1
>>#
>># Revision 5.1  1998/02/03 22:18:13  andy
>># Added warning handler install to test 2 (SR 160).
>>#
>># Revision 5.0  1998/01/26 03:25:14  tbr
>># Branch point for Release 5.0.1b1
>>#
>># Revision 4.0  1995/12/15 09:19:57  tbr
>># Branch point for Release 5.0.0
>>#
>># Revision 3.1  1995/12/15  02:14:47  andy
>># Prepare for GA Release
>>#
>>EXTERN
#include <X11/IntrinsicP.h>
#include <X11/ConstrainP.h>
#include <X11/CoreP.h>

XtAppContext app_ctext;
Widget topLevel, panedw, boxw1, boxw2;
Widget labelw, rowcolw, click_quit;

void XtWMH_Proc(str1, str2, str3, str4, str5, car)
String str1, str2, str3, str4, *str5;
Cardinal *car;
{
	avs_set_event(1,1);
}
>>SET tpstartup avs_alloc_sem
>>SET tpcleanup avs_free_sem
>>TITLE XtCvtStringToVisual Xt11
Boolean
XtCvtStringToVisual(display, args, num_args, from, to, converter_data)
>>ASSERTION Good C
If the implementation is X11R5 or later:
A successful call to
Boolean XtCvtStringToVisual(display, args, num_args, from, to, converter_data)
when 
.A to->addr 
is not NULL and
.A to->size 
is large enough to store
an XtRVisual type shall convert the string specified in 
.A from
to an XtRVisual type, store it at the location specified by
.A to->addr,
set
.A to->size 
to the actual size of the converted data, and return True.
>>CODE
#if XT_X_RELEASE > 4
/* Conversion arguments and results */
Boolean status;
Display *display;
XrmValue args[2];
Cardinal num_args;
XrmValue fromVal;
XrmValue toVal;
XtPointer *closure_ret = (XtPointer *) 0;
/* String to Visual specific */
Screen *screen;
Cardinal depth;
char *visstr;
Visual *res;
pid_t pid2;
#endif

#if XT_X_RELEASE > 4
	FORK(pid2);
	avs_xt_hier("Tcstvis1", "XtCvtStringToVisual");
	tet_infoline("PREP: Create windows for widgets and map them");
	XtRealizeWidget(topLevel);
	tet_infoline("PREP: Get display");
	display = XtDisplay(topLevel);
	tet_infoline("PREP: Set up required conversion args");
	screen = DefaultScreenOfDisplay(display);
	args[0].addr = (XtPointer )&screen;
	args[0].size = sizeof(Screen*);
	depth = DefaultDepthOfScreen(screen);
	args[1].addr = (XtPointer) &depth;
	args[1].size = sizeof(Cardinal);
	num_args = 2;
	tet_infoline("PREP: Choose a visual that exists");
	res = DefaultVisualOfScreen(screen);
	switch(res->class) {
	case StaticGray:
		visstr = "StaticGray";
		break;
	case GrayScale:
		visstr = "GrayScale";
		break;
	case StaticColor:
		visstr = "StaticColor";
		break;
	case PseudoColor:
		visstr = "PseudoColor";
		break;
	case TrueColor:
		visstr = "TrueColor";
		break;
	case DirectColor:
		visstr = "DirectColor";
		break;
	}
	tet_infoline("TEST: Check conversion succeeds");
	fromVal.addr = visstr;
	fromVal.size = strlen(visstr)+1;
	toVal.addr = (XtPointer) &res;
	toVal.size = sizeof(XtPointer);
	status = XtCvtStringToVisual(display,
			&args[0],
			&num_args,
			&fromVal,
			&toVal,
			closure_ret);
	check_dec(True, status, "XtCvtStringToVisual return value");
	LKROF(pid2, AVSXTTIMEOUT-2);
	tet_result(TET_PASS);
#else
	tet_infoline("INFO: Implementation not X11R5 or greater");
	tet_result(TET_UNSUPPORTED);
#endif
>>ASSERTION Good C
If the implementation is X11R5 or later:
A call to 
Boolean XtCvtStringToVisual(display, args, num_args, from, to, converter_data)
when 
.A to->addr 
is not NULL and 
.A to->size 
is too small for an
XtRVisual type shall not perform a
conversion, set the 
.A to->size 
field to the number of bytes required to store the converted data,
and return False.
>>CODE
#if XT_X_RELEASE > 4
/* Conversion arguments and results */
Boolean status;
Display *display;
XrmValue args[2];
Cardinal num_args;
XrmValue fromVal;
XrmValue toVal;
XtPointer *closure_ret = (XtPointer *) 0;
/* String to Visual specific */
Screen *screen;
Cardinal depth;
char *visstr = "fixed";
Visual *res;
pid_t pid2;
#endif

#if XT_X_RELEASE > 4
	FORK(pid2);
	avs_xt_hier("Tcstvis2", "XtCvtStringToVisual");
	XtAppSetWarningMsgHandler(app_ctext, XtWMH_Proc);
	tet_infoline("PREP: Create windows for widgets and map them");
	XtRealizeWidget(topLevel);
	tet_infoline("PREP: Get display");
	display = XtDisplay(topLevel);
	tet_infoline("PREP: Set up required conversion args");
	screen = DefaultScreenOfDisplay(display);
	args[0].addr = (XtPointer )&screen;
	args[0].size = sizeof(Screen*);
	depth = DefaultDepthOfScreen(screen);
	args[1].addr = (XtPointer) &depth;
	args[1].size = sizeof(Cardinal);
	num_args = 2;
	tet_infoline("PREP: Choose a visual that exists");
	res = DefaultVisualOfScreen(screen);
	switch(res->class) {
	case StaticGray:
		visstr = "StaticGray";
		break;
	case GrayScale:
		visstr = "GrayScale";
		break;
	case StaticColor:
		visstr = "StaticColor";
		break;
	case PseudoColor:
		visstr = "PseudoColor";
		break;
	case TrueColor:
		visstr = "TrueColor";
		break;
	case DirectColor:
		visstr = "DirectColor";
		break;
	}
	tet_infoline("TEST: Check conversion fails");
	fromVal.addr = visstr;
	fromVal.size = strlen(visstr)+1;
	toVal.addr = (XtPointer) &res;
	toVal.size = 0;
	status = XtCvtStringToVisual(display,
			&args[0],
			&num_args,
			&fromVal,
			&toVal,
			closure_ret);
	check_dec(False, status, "XtCvtStringToVisual return value");
	tet_infoline("TEST: to_size");
	if (toVal.size != sizeof(Visual *)) {
		sprintf(ebuf, "ERROR: to_size not set correctly, expected %d, received %d", sizeof(Visual *), toVal.size);
		tet_infoline(ebuf);
		tet_result(TET_FAIL);
	}
	LKROF(pid2, AVSXTTIMEOUT-2);
	tet_result(TET_PASS);
#else
	tet_infoline("INFO: Implementation not X11R5 or greater");
	tet_result(TET_UNSUPPORTED);
#endif
>>ASSERTION Good C
If the implementation is X11R5 or later:
A successful call to 
Boolean XtCvtStringToVisual(display, args, num_args, from, to, converter_data)
when 
.A to->addr 
is NULL shall convert the string specified in
.A from
to an XtRVisual type, allocate space for the converted data,
set
.A to->addr 
to specify the location of the data,
set
.A to->size
to the size of the coverted data, and return True.
>>CODE
#if XT_X_RELEASE > 4
/* Conversion arguments and results */
Boolean status;
Display *display;
XrmValue args[2];
Cardinal num_args;
XrmValue fromVal;
XrmValue toVal;
XtPointer *closure_ret = (XtPointer *) 0;
/* String to Visual specific */
Screen *screen;
Cardinal depth;
char *visstr = "fixed";
Visual *res;
pid_t pid2;
#endif

#if XT_X_RELEASE > 4
	FORK(pid2);
	avs_xt_hier("Tcstvis3", "XtCvtStringToVisual");
	tet_infoline("PREP: Create windows for widgets and map them");
	XtRealizeWidget(topLevel);
	tet_infoline("PREP: Get display");
	display = XtDisplay(topLevel);
	tet_infoline("PREP: Set up required conversion args");
	screen = DefaultScreenOfDisplay(display);
	args[0].addr = (XtPointer )&screen;
	args[0].size = sizeof(Screen*);
	depth = DefaultDepthOfScreen(screen);
	args[1].addr = (XtPointer) &depth;
	args[1].size = sizeof(Cardinal);
	num_args = 2;
	tet_infoline("PREP: Choose a visual that exists");
	res = DefaultVisualOfScreen(screen);
	switch(res->class) {
	case StaticGray:
		visstr = "StaticGray";
		break;
	case GrayScale:
		visstr = "GrayScale";
		break;
	case StaticColor:
		visstr = "StaticColor";
		break;
	case PseudoColor:
		visstr = "PseudoColor";
		break;
	case TrueColor:
		visstr = "TrueColor";
		break;
	case DirectColor:
		visstr = "DirectColor";
		break;
	}
	tet_infoline("TEST: Check conversion succeeds");
	fromVal.addr = visstr;
	fromVal.size = strlen(visstr)+1;
	toVal.addr = (XtPointer)0;
	toVal.size = 0;
	status = XtCvtStringToVisual(display,
			&args[0],
			&num_args,
			&fromVal,
			&toVal,
			closure_ret);
	check_dec(True, status, "XtCvtStringToVisual return value");
	tet_infoline("TEST: to->addr and to->size are set");
	if (!toVal.addr) {
		sprintf(ebuf, "ERROR: to->addr was not set");
	tet_infoline(ebuf);
	tet_result(TET_FAIL);
	}
	if (toVal.size != sizeof(Visual *)) {
		sprintf(ebuf, "ERROR: to_size not set correctly, expected %d, received %d", sizeof(Visual *), toVal.size);
		tet_infoline(ebuf);
		tet_result(TET_FAIL);
	}
	LKROF(pid2, AVSXTTIMEOUT-2);
	tet_result(TET_PASS);
#else
	tet_infoline("INFO: Implementation not X11R5 or greater");
	tet_result(TET_UNSUPPORTED);
#endif
>>ASSERTION Good C
If the implementation is X11R5 or later:
A call to
Boolean XtCvtStringToVisual(display, args, num_args, from, to, converter_data)
when 
.A args 
specifies an improper value shall not perform a conversion,
issue a warning message, and return False.
>>CODE
#if XT_X_RELEASE > 4
/* Conversion arguments and results */
Boolean status;
Display *display;
XrmValue args[2];
Cardinal num_args;
XrmValue fromVal;
XrmValue toVal;
XtPointer *closure_ret = (XtPointer *) 0;
/* String to Visual specific */
Screen *screen;
char *visstr = "fixed";
Visual *res;
pid_t pid2;
#endif

#if XT_X_RELEASE > 4
	avs_set_event(1,0);
	FORK(pid2);
	avs_xt_hier("Tcstvis4", "XtCvtStringToVisual");
	XtAppSetWarningMsgHandler(app_ctext, XtWMH_Proc);
	tet_infoline("PREP: Create windows for widgets and map them");
	XtRealizeWidget(topLevel);
	tet_infoline("PREP: Get display");
	display = XtDisplay(topLevel);
	tet_infoline("PREP: Set up required conversion args incorrectly");
	num_args = 0;
	tet_infoline("PREP: Choose a visual that exists");
	screen = DefaultScreenOfDisplay(display);
	res = DefaultVisualOfScreen(screen);
	switch(res->class) {
	case StaticGray:
		visstr = "StaticGray";
		break;
	case GrayScale:
		visstr = "GrayScale";
		break;
	case StaticColor:
		visstr = "StaticColor";
		break;
	case PseudoColor:
		visstr = "PseudoColor";
		break;
	case TrueColor:
		visstr = "TrueColor";
		break;
	case DirectColor:
		visstr = "DirectColor";
		break;
	}
	tet_infoline("TEST: Check conversion fails");
	fromVal.addr = visstr;
	fromVal.size = strlen(visstr)+1;
	toVal.addr = (XtPointer)0;
	toVal.size = 0;
	status = XtCvtStringToVisual(display,
			&args[0],
			&num_args,
			&fromVal,
			&toVal,
			closure_ret);
	check_dec(False, status, "XtCvtStringToVisual return value");
	LKROF(pid2, AVSXTTIMEOUT-2);
	tet_infoline("TEST: Warning handler is called");
	status = avs_get_event(1);
	check_dec(1, status, "calls to warning handler count");
	tet_result(TET_PASS);
#else
	tet_infoline("INFO: Implementation not X11R5 or greater");
	tet_result(TET_UNSUPPORTED);
#endif
>>ASSERTION Good A
If the implementation is X11R5 or later:
A call to
Boolean XtCvtStringToVisual(display, args, num_args, from, to, 
converter_data)
when the string specified by
.A from
is not StaticGray, StaticColor, TrueColor, GrayScale, PseudoColor or
DirectColor shall issue a warning message and return False.
>>CODE
#if XT_X_RELEASE > 4
/* Conversion arguments and results */
Boolean status;
Display *display;
XrmValue args[2];
Cardinal num_args;
XrmValue fromVal;
XrmValue toVal;
XtPointer *closure_ret = (XtPointer *) 0;
/* String to Visual specific */
Screen *screen;
Cardinal depth;
char *visstr="Visual from mars";
Visual *res;
pid_t pid2;
#endif

#if XT_X_RELEASE > 4
	FORK(pid2);
	avs_set_event(2, 0);
	avs_xt_hier("Tcstvis5", "XtCvtStringToVisual");
	XtAppSetWarningMsgHandler(app_ctext, XtWMH_Proc);
	tet_infoline("PREP: Create windows for widgets and map them");
	XtRealizeWidget(topLevel);
	tet_infoline("PREP: Get display");
	display = XtDisplay(topLevel);
	tet_infoline("PREP: Set up required conversion args");
	screen = DefaultScreenOfDisplay(display);
	args[0].addr = (XtPointer )&screen;
	args[0].size = sizeof(Screen*);
	depth = DefaultDepthOfScreen(screen);
	args[1].addr = (XtPointer) &depth;
	args[1].size = sizeof(Cardinal);
	num_args = 2;
	tet_infoline("TEST: Check conversion fails");
	fromVal.addr = visstr;
	fromVal.size = strlen(visstr)+1;
	toVal.addr = (XtPointer) &res;
	toVal.size = sizeof(XtPointer);
	status = XtCvtStringToVisual(display,
			&args[0],
			&num_args,
			&fromVal,
			&toVal,
			closure_ret);
	check_dec(False, status, "XtCvtStringToVisual return value");
	LKROF(pid2, AVSXTTIMEOUT-2);
	tet_infoline("TEST: Warning handler is called");
	status = avs_get_event(1);
	check_dec(1, status, "calls to warning handler count");
	tet_result(TET_PASS);
#else
	tet_infoline("INFO: Implementation not X11R5 or greater");
	tet_result(TET_UNSUPPORTED);
#endif
