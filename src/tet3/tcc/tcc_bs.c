/*
 *	SCCS: @(#)tcc_bs.c	1.3 (96/11/04)
 *
 *	UniSoft Ltd., London, England
 *
 * (C) Copyright 1996 X/Open Company Limited
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

SCCS:   	@(#)tcc_bs.c	1.3 96/11/04 TETware release 3.3
NAME:		tcc_bs.c
PRODUCT:	TETware
AUTHOR:		Andrew Dingwall, UniSoft Ltd.
DATE CREATED:	April 1992

DESCRIPTION:
	tcc-specific functions to convert DTET interprocess messages between
	machine-independent and internal format

MODIFICATIONS:
	Denis McConalogue, UniSoft Limited, August 1993
	added support for OP_RCOPY message

	Denis McConalogue, UniSoft Limited, August 1993
	added support for OP_XRCLOSE request message

	Denis McConalogue, UniSoft Limited, September 1993
	OP_XRCLOSE not being recognised.

	Andrew Dingwall, UniSoft Ltd., August 1996
	Changes for TETware.
	This file is derived from d_tcc_bs.c in dTET2 R2.3.

	Aaron Plattner, April 2010
	Fixed warnings when compiled with GCC's -Wall option.

************************************************************************/

#ifndef TET_LITE	/* -START-LITE-CUT- */

#include <stdio.h>
#include <sys/types.h>
#include <time.h>
#include "dtmac.h"
#include "dtmsg.h"
#include "ptab.h"
#include "error.h"
#include "avmsg.h"
#include "valmsg.h"
#include "servlib.h"
#include "dtetlib.h"
#include "server_bs.h"
#include "tcc.h"
#include "dtcc.h"

static char reqerr[] = "unknown request code";

/*
**	tet_ss_bs2md() - convert message data to internal format
**
**	return length of internal-format message, or -ve error code on error
*/

int tet_ss_bs2md(from, pp)
char *from;
register struct ptab *pp;
{
	register int rc;
	register int request = pp->pt_savreq;

	switch (request) {
	case OP_EXEC:
	case OP_WAIT:
	case OP_KILL:
	case OP_SNGET:
	case OP_XROPEN:
	case OP_FOPEN:
		rc = tet_bs2valmsg(from, pp->ptm_len,
			(struct valmsg **) &pp->ptm_data, &pp->pt_mdlen);
		break;
	case OP_RCVCONF:
	case OP_MKTMPDIR:
	case OP_MKSDIR:
	case OP_SHARELOCK:
		rc = tet_bs2avmsg(from, pp->ptm_len,
			(struct avmsg **) &pp->ptm_data, &pp->pt_mdlen);
		break;
	default:
		error(0, reqerr, tet_ptreqcode(request));
		return(ER_REQ);
	}

	return(rc < 0 ? ER_ERR : rc);
}

/*
**	tet_ss_md2bs() - convert message data to machine-independent format
**
**	return length of machine-independent message
**	or -ve error code on error
*/

int tet_ss_md2bs(pp, bp, lp, offs)
struct ptab *pp;
char **bp;
int *lp, offs;
{
	register char *mp = pp->ptm_data;
	register int request = pp->ptm_req;
	register int len, rc;

	/* calculate outgoing data size */
	switch (request) {
	case OP_SYSID:
	case OP_SYSNAME:
	case OP_SNSYS:
	case OP_XRSYS:
	case OP_RESULT:
	case OP_FCLOSE:
	case OP_WAIT:
	case OP_KILL:
	case OP_XRCLOSE:
	case OP_SETCONF:
	case OP_SNRM:
		len = VM_VALMSGSZ(((struct valmsg *) mp)->vm_nvalue);
		break;
	case OP_TRACE:
	case OP_EXEC:
	case OP_XROPEN:
	case OP_XRES:
	case OP_CFNAME:
	case OP_CODESF:
	case OP_SNDCONF:
	case OP_CONFIG:
	case OP_PUTENV:
	case OP_ACCESS:
	case OP_MKDIR:
	case OP_RMDIR:
	case OP_CHDIR:
	case OP_FOPEN:
	case OP_PUTS:
	case OP_LOCKFILE:
	case OP_SHARELOCK:
	case OP_MKTMPDIR:
	case OP_UNLINK:
	case OP_RXFILE:
	case OP_MKSDIR:
	case OP_TSFILES:
	case OP_RCOPY:
	case OP_MKALLDIRS:
	case OP_RMALLDIRS:
#if TESTING
	case OP_PRINT:
#endif
		len = tet_avmsgbslen((struct avmsg *) mp);
		break;
	case OP_TSINFO:
		len = ts_tsinfolen();
		break;
	default:
		error(0, reqerr, tet_ptreqcode(request));
		return(ER_REQ);
	}

	/* make sure that the receiving area is big enough */
	if (BUFCHK(bp, lp, len + offs) < 0)
		return(ER_ERR);

	/* copy the data to (*bp + offs) */
	switch (request) {
	case OP_SYSID:
	case OP_SYSNAME:
	case OP_SNSYS:
	case OP_XRSYS:
	case OP_RESULT:
	case OP_FCLOSE:
	case OP_WAIT:
	case OP_KILL:
	case OP_XRCLOSE:
	case OP_SETCONF:
	case OP_SNRM:
		rc = tet_valmsg2bs((struct valmsg *) mp, *bp + offs);
		break;
	case OP_EXEC:
	case OP_TRACE:
	case OP_XROPEN:
	case OP_XRES:
	case OP_CFNAME:
	case OP_CODESF:
	case OP_SNDCONF:
	case OP_CONFIG:
	case OP_PUTENV:
	case OP_ACCESS:
	case OP_MKDIR:
	case OP_RMDIR:
	case OP_CHDIR:
	case OP_FOPEN:
	case OP_PUTS:
	case OP_LOCKFILE:
	case OP_SHARELOCK:
	case OP_MKTMPDIR:
	case OP_UNLINK:
	case OP_RXFILE:
	case OP_MKSDIR:
	case OP_TSFILES:
	case OP_RCOPY:
	case OP_MKALLDIRS:
	case OP_RMALLDIRS:
#if TESTING
	case OP_PRINT:
#endif
		rc = tet_avmsg2bs((struct avmsg *) mp, *bp + offs);
		break;
	case OP_TSINFO:
		rc = ts_tsinfo2bs(mp, *bp + offs);
		break;
	default:
		error(0, reqerr, tet_ptreqcode(request));
		return(ER_REQ);
	}

	return(rc < 0 ? ER_ERR : rc);
}

#else

int tet_tcc_bs_c_not_empty;

#endif /* !TET_LITE */	/* -LITE-CUT-LINE- */

