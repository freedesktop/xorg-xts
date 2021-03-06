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
>># File: xts/Xt11/XtVaGetSubresources.m
>># 
>># Description:
>>#	Tests for XtVaGetSubresources()
>># 
>># Modifications:
>># $Log: tvagtsres.m,v $
>># Revision 1.1  2005-02-12 14:37:54  anderson
>># Initial revision
>>#
>># Revision 8.0  1998/12/23 23:37:24  mar
>># Branch point for Release 5.0.2
>>#
>># Revision 7.0  1998/10/30 23:00:20  mar
>># Branch point for Release 5.0.2b1
>>#
>># Revision 6.0  1998/03/02 05:28:29  tbr
>># Branch point for Release 5.0.1
>>#
>># Revision 5.0  1998/01/26 03:25:03  tbr
>># Branch point for Release 5.0.1b1
>>#
>># Revision 4.2  1998/01/13 04:27:38  andy
>># In test 4 call to XtVaCreateArgsList changed value portion of
>># name/value pair to be a pointer rather than a value (SR 145).
>>#
>># Revision 4.1  1997/01/07 19:47:00  mar
>># req.4.W.00031: tp3, tp4 - use background instead of foreground, since
>># foreground is not a valid resource in the toplevel shell widget.
>>#
>># Revision 4.0  1995/12/15  09:19:21  tbr
>># Branch point for Release 5.0.0
>>#
>># Revision 3.1  1995/12/15  02:14:01  andy
>># Prepare for GA Release
>>#
>>EXTERN
#include <X11/IntrinsicP.h>
#include <X11/ConstrainP.h>
#include <X11/CoreP.h>

XtAppContext app_ctext;
Widget topLevel, panedw, boxw1, boxw2;
Widget labelw, rowcolw, click_quit;

typedef struct _instance_variables {
	long background;
	String label;
} instance_variable_rec;
static XtResource resources[] = {
	{
	XtNbackground,
	XtCBackground,
	XtRPixel, sizeof(Pixel),
	XtOffsetOf(instance_variable_rec, background),
	XtRString, "XtDefaultbackground"
	},
	{
	XtNlabel,
	XtCLabel,
	XtRString, sizeof(String),
	XtOffsetOf(instance_variable_rec, label),
	XtRString, "XtDefaultLabel"
	},
};
int def = 2002;
static XtResource resources2[] = {
	{
	XtNbackground,
	XtCBackground,
	XtRPixel, sizeof(Pixel),
	XtOffsetOf(instance_variable_rec, background),
	XtRString, "XtDefaultBackground"
	},
	{
	XtNlabel,
	XtCLabel,
	XtRString, sizeof(String),
	XtOffsetOf(instance_variable_rec, label),
	XtRInt, &def
	},
};

char whereitsat[64];

Boolean XtCVT_Proc(display, args, num_args, from_val, to_val, converter_data)
Display *display;
XrmValuePtr args;
Cardinal *num_args;
XrmValue *from_val;
XrmValue *to_val;
XtPointer *converter_data;
{
	sprintf(whereitsat, "%d", *(int *)from_val->addr);
	*(String*)to_val->addr = whereitsat;
	to_val->size = sizeof(XtPointer);
	avs_set_event(2, avs_get_event(2)+1);
	return True;
}
>>SET tpstartup avs_alloc_sem
>>SET tpcleanup avs_free_sem
>>TITLE XtVaGetSubresources Xt11
void
XtVaGetSubresources(w, base, name, class, resources, num_resources, ...);
>>ASSERTION Good A
A successful call to
void XtVaGetSubresources(w, base, name, class, resources, 
num_resources, ...)
shall retrieve the resource value for each resource specified in the
resource list
.A resources
from the resource values specified in
the varargs style argument list,
or if no value for the resource is found the variable argument list, 
from the resource database associated with the widget
.A w,
matching the resource identified by the 
calling application's
name and class, the names and classes of all ancestors of
.A w,
the name and class of
.A w, 
the subpart name 
.A name
and class
.A class, 
and the resource name and class,
or if no value is found in the database, from the default_addr field
of the resource list and copy the resource value at an offset specified
by the corresponding resource_offset field from the address
.A base.
>>CODE
instance_variable_rec base;
Cardinal num_resources;
Arg setargs[2], getargs[2];
Cardinal num_args;
Pixel pixel;
char *string;
pid_t pid2;

	FORK(pid2);
	avs_xt_hier("Tvagtsres1", "XtVaGetSubresources");
	tet_infoline("PREP: Create windows for widgets and map them");
	XtRealizeWidget(topLevel);
	tet_infoline("PREP: Initialize the base address");
	XtGetApplicationResources(topLevel, &base, resources,2,
			 (ArgList)NULL, (Cardinal)0);
	tet_infoline("PREP: Update subpart resource list");
	XtVaGetSubresources(topLevel, &base, (String)NULL, (String)NULL,
			resources, 2, XtNbackground, 1,
			XtNlabel, "Hello World",(char *)NULL);
	tet_infoline("PREP: Get subvalues");
	XtVaGetSubvalues(&base, resources, 2, XtNbackground, &pixel,
		 XtNlabel, &string, (char *)NULL);
	tet_infoline("TEST: Retrieved subvalues");
	check_dec(1, pixel , XtNbackground);
	check_str("Hello World", string , XtNlabel);
	LKROF(pid2, AVSXTTIMEOUT-2);
	tet_result(TET_PASS);
>>ASSERTION Good A
On a call to
void XtVaGetSubresources(w, base, name, class, resources, 
num_resources, ...)
when a resource specified in the resource database, the varargs list or 
a default resource value is in a different representation from the 
representation type specified in the resource_type field of the resource 
list it shall call the appropriate type converter to perform the 
conversion and store the converted value in the subpart data structure.
>>CODE
instance_variable_rec base;
Cardinal num_resources;
Arg setargs[2], getargs[2];
Cardinal num_args;
Pixel pixel;
char *string;
pid_t pid2;
int status;

	FORK(pid2);
	avs_xt_hier("Tvagtsres5", "XtVaGetSubresources");
	tet_infoline("PREP: Create windows for widgets and map them");
	XtRealizeWidget(topLevel);
	XtAppSetTypeConverter(app_ctext,
		 XtRInt,
		 XtRString,
		 XtCVT_Proc,
		 (XtConvertArgList)NULL,
		 (Cardinal)0,
		 XtCacheNone,
		 NULL);
	tet_infoline("PREP: Initialize the base address");
	XtGetApplicationResources(topLevel, &base, resources,2,
				(ArgList)NULL,(Cardinal)0);
	tet_infoline("PREP: Update subpart resource list");
	XtVaGetSubresources(topLevel, &base, (String)NULL, (String)NULL,
		 resources2, 2, XtNbackground, 1, NULL);
	tet_infoline("PREP: Get subvalues");
	XtVaGetSubvalues(&base, resources2, 2, XtNbackground, &pixel,
	XtNlabel, &string, (char *)NULL);
	tet_infoline("TEST: Retrieved subvalues");
	check_dec(1, pixel , XtNbackground);
	check_str("2002", string , XtNlabel);
	LKROF(pid2, AVSXTTIMEOUT-2);
	tet_infoline("TEST: convertor was invoked");
	status = avs_get_event(2);
	check_dec(1, status, "XtCVT_Proc invoked status");

	tet_result(TET_PASS);
>>ASSERTION Good A
On a call to
void XtVaGetSubresources(w, base, name, class, resources, 
num_resources, ...)
when the name XtVaTypedArg is specified in place of a resource name
in the variable argument list it shall interpret the four arguments
following this argument as a name/type/value/size tuple.
>>CODE
instance_variable_rec base;
Cardinal num_resources;
Arg setargs[2], getargs[2];
Cardinal num_args;
Pixel pixel;
char *string;
pid_t pid2;

	FORK(pid2);
	avs_xt_hier("Tvagtsres1", "XtVaGetSubresources");
	tet_infoline("PREP: Create windows for widgets and map them");
	XtRealizeWidget(topLevel);
	tet_infoline("PREP: Initialize the base address");
	XtGetApplicationResources(topLevel, &base, resources,2,
			 (ArgList)NULL, (Cardinal)0);
	tet_infoline("PREP: Update subpart resource list");
	XtVaGetSubresources(topLevel, &base, (String)NULL, (String)NULL,
			resources, 2, XtVaTypedArg, XtNbackground, XtRPixel, 0, sizeof(Pixel), XtNlabel, "Hello World",(char *)NULL);
	tet_infoline("PREP: Get subvalues");
	XtVaGetSubvalues(&base, resources, 2, XtNbackground, &pixel,
		 XtNlabel, &string, (char *)NULL);
	tet_infoline("TEST: Retrieved subvalues");
	check_dec(0, base.background , XtNbackground);
	check_str("Hello World", string , XtNlabel);
	LKROF(pid2, AVSXTTIMEOUT-2);
	tet_result(TET_PASS);
>>ASSERTION Good A
On a call to
void XtVaGetSubresources(w, base, name, class, resources, 
num_resources, ...)
when the name XtVaNestedList is specified in place of a resource name
in the variable argument list it shall interpret the next argument 
as a value specifying another varargs style variable argument list and 
logically insert it in the original list at the point of declaration.
>>CODE
instance_variable_rec base;
Cardinal num_resources;
Arg setargs[2], getargs[2];
Cardinal num_args;
Pixel pixel;
char *string;
pid_t pid2;
XtVarArgsList sublist;

	FORK(pid2);
	avs_xt_hier("Tvagtsres1", "XtVaGetSubresources");
	tet_infoline("PREP: Create windows for widgets and map them");
	XtRealizeWidget(topLevel);
	tet_infoline("PREP: Initialize the base address");
	XtGetApplicationResources(topLevel, &base, resources,2,
			 (ArgList)NULL, (Cardinal)0);
	tet_infoline("PREP: Update subpart resource list");
	XtVaGetSubresources(topLevel, &base, (String)NULL, (String)NULL,
			resources, 2, XtVaTypedArg, XtNbackground, XtRPixel, 0, sizeof(Pixel), XtNlabel, "Hello World",(char *)NULL);
	tet_infoline("PREP: Create nested list");
	sublist = XtVaCreateArgsList(NULL, XtNbackground, (XtArgVal)&pixel, NULL);
	tet_infoline("PREP: Get subvalues");
	XtVaGetSubvalues(&base, resources, 2, XtVaNestedList, sublist,
		 XtNlabel, &string, (char *)NULL);
	tet_infoline("TEST: Retrieved subvalues");
	check_dec(0, base.background, XtNbackground);
	check_str("Hello World", string , XtNlabel);
	XtFree((char *)sublist);
	LKROF(pid2, AVSXTTIMEOUT-2);
	tet_result(TET_PASS);
