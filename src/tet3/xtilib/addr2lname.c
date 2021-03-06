/*
 *      SCCS:  @(#)addr2lname.c	1.7 (98/09/01) 
 *
 *	UniSoft Ltd., London, England
 *
 * (C) Copyright 1993 X/Open Company Limited
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

SCCS:   	@(#)addr2lname.c	1.7 98/09/01 TETware release 3.3
NAME:		addr2lname.c
PRODUCT:	TETware
AUTHOR:		Denis McConalogue, UniSoft Ltd.
DATE CREATED:	April 1993

DESCRIPTION:
	function to convert XTI caller address (binary) into printable
	hex string

	Warning: The string returned is a pointer to a static buffer. This
		 string should be copied by the caller to local storage after
		 calling this function.

MODIFICATIONS:

	Aaron Plattner, April 2010
	Fixed warnings when compiled with GCC's -Wall option.

************************************************************************/

#include <stdio.h>
#include <sys/types.h>
#include <xti.h>
#include "dtmac.h"
#include "dtmsg.h"
#include "ptab.h"
#include "xtilib_xt.h"

/*
**	tet_addr2lname.c() - convert XTI call address to printable hex string
*/

char *tet_addr2lname(np)
struct netbuf *np;
{
	static char buf[MAX_ADDRL*2+1];
	register char *p=buf;
	register char *q=np->buf;

	unsigned int len = np->len;

	if (len > MAX_ADDRL)
		return (char *)0;

	while (len--) {
		sprintf(p,"%02x", (unsigned char) *q++);
		p += 2;
	}
	*p = '\0';

	return (buf);
}

