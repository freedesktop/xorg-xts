/*
 *	SCCS: @(#)basename.c	1.1 (98/09/01)
 *
 *	UniSoft Ltd., London, England
 *
 * Copyright (c) 1998 The Open Group
 * All rights reserved.
 *
 * No part of this source code may be reproduced, stored in a retrieval
 * system, or transmitted, in any form or by any means, electronic,
 * mechanical, photocopying, recording or otherwise, except as stated
 * in the end-user licence agreement, without the prior permission of
 * the copyright owners.
 * A copy of the end-user licence agreement is contained in the file
 * Licence which accompanies this distribution.
 * 
 * Motif, OSF/1, UNIX and the "X" device are registered trademarks and
 * IT DialTone and The Open Group are trademarks of The Open Group in
 * the US and other countries.
 *
 * X/Open is a trademark of X/Open Company Limited in the UK and other
 * countries.
 *
 */

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

/************************************************************************

SCCS:   	@(#)basename.c	1.1 98/09/01 TETware release 3.3
NAME:		basename.c
PRODUCT:	TETware
AUTHOR:		Andrew Dingwall, UniSoft Ltd.
DATE CREATED:	May 1998

DESCRIPTION:
	function to return the last part of a path name

MODIFICATIONS:

	Aaron Plattner, April 2010
	Fixed warnings when compiled with GCC's -Wall option.

************************************************************************/

#include <stdio.h>
#include "dtmac.h"
#include "dtetlib.h"

/*
**	tet_basename() - return the last component of a path name
**
**	note that both '/' and '\' are interpreted as the
**	directory separator character
*/

TET_IMPORT const char *tet_basename(const char *path)
{
	register const char *p;
	register const char *retval = path;

	if (path)
		for (p = path; *p; p++)
			if (isdirsep(*p) && *(p + 1))
				retval = p + 1;

	return(retval);
}
