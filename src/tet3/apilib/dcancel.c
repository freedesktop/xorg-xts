/*
 *	SCCS: @(#)dcancel.c	1.9 (98/08/28)
 *
 *	UniSoft Ltd., London, England
 *
 * (C) Copyright 1997 X/Open Company Limited
 *
 * All rights reserved.  No part of this source code may be reproduced,
 * stored in a retrieval system, or transmitted, in any form or by any
 * means, electronic, mechanical, photocopying, recording or otherwise,
 * except as stated in the end-user licence agreement, without the prior
 * permission of the copyright owners.
 * A copy of the end-user licence agreement is contained in the file
 * Licence which accompanies this distribution.
 * 
 * X/Open and the 'X' symbol are trademarks of X/Open Company Limited in
 * the UK and other countries.
 */

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

/************************************************************************

SCCS:   	@(#)dcancel.c	1.9 98/08/28 TETware release 3.3
NAME:		dcancel.c
PRODUCT:	TETware
AUTHOR:		Andrew Dingwall, UniSoft Ltd.
DATE CREATED:	June 1997

DESCRIPTION:
	API library functions for cancelling test purposes.

	This version of this file replaces a previous one of the same
	name.
	The API functions provided here perform the same actions as
	those provided in the previous file, but the implementation is
	different.
	Re-implementation of these functions became necessary with the
	introduction of the defined test case interface.

MODIFICATIONS:

	Andrew Dingwall, UniSoft Ltd., July 1998
	Added support for shared API libraries.

	Aaron Plattner, April 2010
	Fixed warnings when compiled with GCC's -Wall option.

************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include "dtmac.h"
#include "bstring.h"
#include "dtetlib.h"
#include "tet_api.h"

/*
** deletion reason structure
**
** an element in this structure is allocated for each test purpose
** that has been deleted
*/

struct delreason {
	int dr_testnum;		/* absolute test number of deleted TP */
	char *dr_reason;	/* pointer to the deletion reason text */
};

/* the list of deletion reasons itself */
static struct delreason *delreason;
static int ldelreason, ndelreason;


/* static function declarations */
static struct delreason *dralloc PROTOLIST((void));
static struct delreason *drfind PROTOLIST((int));
static void drfree PROTOLIST((struct delreason *));


/*
**	tet_delete() - mark a test purpose as cancelled
*/

TET_IMPORT void tet_delete(testnum, reason)
int testnum;
char *reason;
{
	struct delreason *drp;

	if (testnum <= 0)
		return;

	/*
	** see if this TP is currently deleted -
	**
	** if it isn't and the request is to delete it now, allocate a new
	** delreason structure for this TP and mark it as deleted
	*/
	if ((drp = drfind(testnum)) == (struct delreason *) 0) {
		if (reason) {
			drp = dralloc();
			drp->dr_testnum = testnum;
			drp->dr_reason = reason;
		}
		return;
	}

	/*
	** here when the TP has previously been deleted
	**
	** if the deletion reason is to be changed, do so now;
	** otherwise the TP is to be undeleted so mark the delreason
	** structure as free
	*/
	if (reason)
		drp->dr_reason = reason;
	else
		drfree(drp);
}

/*
**	tet_reason() - return the deletion reason for the specified
**		test purpose
**
**	return (char *) 0 if the test purpose is not marked as cancelled
*/

TET_IMPORT char *tet_reason(testnum)
int testnum;
{
	register struct delreason *drp;

	if (testnum < 0 || (drp = drfind(testnum)) == (struct delreason *) 0)
		return((char *) 0);

	return(drp->dr_reason);
}

/*
**	drfind() - find the delreason element which relates to testnum
**		and return a pointer thereto
**
**	return (struct delreason *) 0 if no such element can be found
*/

static struct delreason *drfind(testnum)
int testnum;
{
	register struct delreason *drp;

	if (delreason)
		for (drp = delreason; drp < delreason + ndelreason; drp++)
			if (drp->dr_testnum == testnum)
				return(drp);

	return((struct delreason *) 0);
}

/*
**	dralloc() - allocate a new delreason element and return a pointer
**		thereto
*/

static struct delreason *dralloc()
{
	register struct delreason *drp;

	/* see if there is a free delreason structure that we can use */
	if ((drp = drfind(-1)) != (struct delreason *) 0)
		return(drp);

	/* no free structures so we must allocate a new one */
	if (BUFCHK((char **) &delreason, &ldelreason, (ndelreason + 1) * sizeof *delreason) < 0)
		tet_exit(EXIT_FAILURE);

	drp = delreason + ndelreason++;
	bzero((char *) drp, sizeof *drp);
	return(drp);
}

/*
**	drfree() - mark a delreason element as free
*/

static void drfree(drp)
struct delreason *drp;
{
	drp->dr_reason = (char *) 0;
	drp->dr_testnum = -1;
}

