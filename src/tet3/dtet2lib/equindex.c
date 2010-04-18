/*
 *      SCCS:  @(#)equindex.c	1.6 (96/11/04) 
 *
 *	UniSoft Ltd., London, England
 *
 * (C) Copyright 1992 X/Open Company Limited
 *
 * All rights reserved.  No part of this source code may be reproduced,
 * stored in a retrieval system, or transmitted, in any form or by any
 * means, electronic, mechanical, photocopying, recording or otherwise,
 * except as stated in the end-user licence agreement, without the prior
 * permission of the copyright owners.
 *
 * X/Open and the 'X' symbol are trademarks of X/Open Company Limited in
 * the UK and other countries.
 */

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

/************************************************************************

SCCS:   	@(#)equindex.c	1.6 96/11/04 TETware release 3.3
NAME:		equindex.c
PRODUCT:	TETware
AUTHOR:		Andrew Dingwall, UniSoft Ltd.
DATE CREATED:	June 1992

DESCRIPTION:
	function to return pointer to first '=' in string

MODIFICATIONS:

************************************************************************/

#include <stdio.h>
#include "dtmac.h"
#include "dtetlib.h"

/*
**	tet_equindex() - return pointer to first '=' in string
**
**	return (char *) 0 if not found
*/

char *tet_equindex(s)
register char *s;
{
	while (*s) {
		if (*s == '=')
			return(s);
		s++;
	}

	return((char *) 0);
}

