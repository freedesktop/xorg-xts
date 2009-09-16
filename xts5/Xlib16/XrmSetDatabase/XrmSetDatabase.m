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
>># File: xts5/Xlib16/XrmSetDatabase/XrmSetDatabase.m
>># 
>># Description:
>># 	Tests for XrmSetDatabase()
>># 
>># Modifications:
>># $Log: rmstdb.m,v $
>># Revision 1.2  2005-11-03 08:42:59  jmichael
>># clean up all vsw5 paths to use xts5 instead.
>>#
>># Revision 1.1.1.2  2005/04/15 14:05:23  anderson
>># Reimport of the base with the legal name in the copyright fixed.
>>#
>># Revision 8.0  1998/12/23 23:34:28  mar
>># Branch point for Release 5.0.2
>>#
>># Revision 7.0  1998/10/30 22:56:48  mar
>># Branch point for Release 5.0.2b1
>>#
>># Revision 6.0  1998/03/02 05:25:47  tbr
>># Branch point for Release 5.0.1
>>#
>># Revision 5.0  1998/01/26 03:22:19  tbr
>># Branch point for Release 5.0.1b1
>>#
>># Revision 4.1  1996/08/16 23:27:48  srini
>># Added test #2
>>#
>># Revision 4.0  1995/12/15  09:10:38  tbr
>># Branch point for Release 5.0.0
>>#
>># Revision 3.1  1995/12/15  01:13:05  andy
>># Prepare for GA Release
>>#
/*

Copyright (c) 1993  X Consortium

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
Copyright 1993 by Sun Microsystems, Inc. Mountain View, CA.

                  All Rights Reserved

Permission  to  use,  copy,  modify,  and  distribute   this
software  and  its documentation for any purpose and without
fee is hereby granted, provided that the above copyright no-
tice  appear  in all copies and that both that copyright no-
tice and this permission notice appear in  supporting  docu-
mentation,  and  that the names of Sun or MIT not be used in
advertising or publicity pertaining to distribution  of  the
software  without specific prior written permission. Sun and
M.I.T. make no representations about the suitability of this
software for any purpose. It is provided "as is" without any
express or implied warranty.

SUN DISCLAIMS ALL WARRANTIES WITH REGARD TO  THIS  SOFTWARE,
INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FIT-
NESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL SUN BE  LI-
ABLE  FOR  ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,  DATA  OR
PROFITS,  WHETHER  IN  AN  ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION  WITH
THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/
>>EXTERN
#include <locale.h>
#include <ximtest.h>

>>TITLE XrmSetDatabase Xlib14
void

Display	*display = Dsp;
XrmDatabase database;
>>SET startup rmstartup
>>ASSERTION Good C
If the implementation is X11R5 or later:
A call to xname shall associate a resource
.A database
with a display, by setting the db field of the display structure.
>>STRATEGY
Create a resource manager database, set the display database by calling
XrmSetDatabase and compare the db field of the display with the 
database which was created.
>>CODE

#if XT_X_RELEASE > 4

	database = XrmGetStringDatabase("");
	if(database == NULL)
	{
		report("Unable to create resource database");
		FAIL;
	}
	else
	{
		XCALL;
		if(database != XrmGetDatabase(display))
		{
			report("%s failed to set the db field of the display",
				TestName);
			FAIL; 
		} else 
			CHECK;
	}

	CHECKPASS(1);
#else

	tet_infoline("INFO: Implementation not X11R5 or greater");
	tet_result(TET_UNSUPPORTED);
#endif
>>ASSERTION Good C
If the implementation is X11R5 or later:
A call to xname 
shall not destroy the database previously associated with
.A display.
>>STRATEGY
Create a database in a known locale
Set this database to the display
Create a new database
Set this database to the same display
Obtain the locale of the previous database
If the locale is valid then the database has not bee destroyed.
>>CODE
#if XT_X_RELEASE > 4
char *plocale;
char *prmlocale;
XrmDatabase org_db;
#endif

#if XT_X_RELEASE > 4
	resetlocale();
	if (nextlocale(&plocale))
	{
		if (locale_set(plocale))
			CHECK;
		else
		{
			report("Couldn't set locale.");
			FAIL;
		}

		/* create a resource database */
		XrmInitialize();
		org_db = XrmGetStringDatabase("");
		if(org_db == (XrmDatabase)NULL)
		{
			delete("Could not create target database.");
			FAIL;
		}
		else
			CHECK;
		XrmSetDatabase(display, org_db);
		if (org_db != XrmGetDatabase(display))
		{
			report("%s failed to set the db field of the display",
				TestName);
			FAIL; 
		} else 
			CHECK;

		/* Now set to a new database */
		database = XrmGetStringDatabase("");
		if(database == NULL)
		{
			report("Unable to create resource database");
			FAIL;
		}
		else
		{
			XCALL;
			if(database != XrmGetDatabase(display))
			{
				report("%s failed to set the db field of the display",
					TestName);
				FAIL; 
			}
		}

		/* get the locale of the old database */
		prmlocale = XrmLocaleOfDatabase(org_db);

		/* Database is not destroyed */
		if(strcmp(prmlocale, plocale) != 0)
		{
			report("Locale for resource database, %s, differs from current locale, %s",
				prmlocale,plocale);
			FAIL;
		}
	}	/* nextlocale */

	tet_result(TET_PASS);
#else
	tet_infoline("INFO: Implementation not X11R5 or greater");
	tet_result(TET_UNSUPPORTED);
#endif
