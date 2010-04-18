/*
 *	SCCS: @(#)scentab.c	1.7 (98/09/01)
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

SCCS:   	@(#)scentab.c	1.7 98/09/01 TETware release 3.3
NAME:		scentab.c
PRODUCT:	TETware
AUTHOR:		Andrew Dingwall, UniSoft Ltd.
DATE CREATED:	August 1996

DESCRIPTION:
	functions which deal with scenario table elements

MODIFICATIONS:
	Andrew Dingwall, UniSoft Ltd., March 1997
	print ascii representation of scenario element type
	in tracescelem()

	Andrew Dingwall, UniSoft Ltd., December 1997
	removed SCF_DIST scenario flag - the "distributed" attribute
	is now part of a test case's execution context
	(see struct proctab in proctab.h)

************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <time.h>
#include <errno.h>
#include "dtmac.h"
#include "bstring.h"
#include "error.h"
#include "llist.h"
#include "ftoa.h"
#include "ltoa.h"
#include "scentab.h"
#include "dirtab.h"
#include "tcc.h"


#ifdef NEEDsrcFile
static char srcFile[] = __FILE__;	/* file name for error reporting */
#endif

/* the linear scenario list - generated by pass 1*/
struct scentab *sclist;

/* the scenario tree - generated by pass 2 */
struct scentab *sctree;

/* static function declarations */
static void scfreedata PROTOLIST((struct scentab *));


/*
**	scalloc(), scfree() - functions to allocate and free a
**		scenario element
*/

struct scentab *scalloc()
{
	register struct scentab *ep;

	errno = 0;
	if ((ep = (struct scentab *) malloc(sizeof *ep)) == (struct scentab *) 0)
		fatal(errno, "can't allocate scenario element", (char *) 0);

	TRACE2(tet_Tbuf, 6, "allocate scentab element = %s", tet_i2x(ep));
	bzero((char *) ep, sizeof *ep);
	ep->sc_magic = SC_MAGIC;
	return(ep);
}

void scfree(ep)
struct scentab *ep;
{
	TRACE3(TET_MAX(tet_Tscen, tet_Tbuf), 6,
		"free scentab element ref %s = %s",
		ep ? tet_l2a(ep->sc_ref) : "??", tet_i2x(ep));

	if (ep) {
		ASSERT(ep->sc_magic == SC_MAGIC);
		if ((ep->sc_flags & SCF_DATA_USED) == 0)
			scfreedata(ep);
		bzero((char *) ep, sizeof *ep);
		free((char *) ep);
	}
}

/*
**	scfreedata() - free storage pointed to by members of sc_data
*/

static void scfreedata(ep)
struct scentab *ep;
{
	register char **vp;

	TRACE2(TET_MAX(tet_Tscen, tet_Tbuf), 6, "free data in scentab ref %s",
		tet_l2a(ep->sc_ref));

	switch (ep->sc_type) {
	case SC_SCENARIO:
		if (ep->sc_scenario) {
			TRACE2(tet_Tbuf, 6, "free scenario name %s",
				tet_i2x(ep->sc_scenario));
			free(ep->sc_scenario);
		}
		break;
	case SC_SCENINFO:
		if (ep->sc_sceninfo) {
			TRACE2(tet_Tbuf, 6, "free scenario information %s",
				tet_i2x(ep->sc_sceninfo));
			free(ep->sc_sceninfo);
		}
		break;
	case SC_TESTCASE:
		if (ep->sc_tcname) {
			TRACE2(tet_Tbuf, 6, "free test case name %s",
				tet_i2x(ep->sc_tcname));
			free(ep->sc_tcname);
		}
		if (ep->sc_sciclist) {
			TRACE2(tet_Tbuf, 6, "free scenario IC list %s",
				tet_i2x(ep->sc_sciclist));
			free(ep->sc_sciclist);
		}
		if (ep->sc_exiclist && ep->sc_exiclist != ep->sc_sciclist) {
			TRACE2(tet_Tbuf, 6, "free exec IC list %s",
				tet_i2x(ep->sc_exiclist));
			free(ep->sc_exiclist);
		}
		break;
	case SC_SCEN_NAME:
		if (ep->sc_scen_name) {
			TRACE2(tet_Tbuf, 6,
				"free referenced scenario name %s",
				tet_i2x(ep->sc_scen_name));
			free(ep->sc_tcname);
		}
		break;
	case SC_DIRECTIVE:
		switch (ep->sc_directive) {
#ifndef TET_LITE	/* -START-LITE-CUT- */
		case SD_REMOTE:
		case SD_DISTRIBUTED:
			if (ep->sc_sys) {
				TRACE2(tet_Tbuf, 6, "free system list %s",
					tet_i2x(ep->sc_sys));
				free((char *) ep->sc_sys);
			}
			break;
#endif /* !TET_LITE */	/* -END-LITE-CUT- */
		case SD_VARIABLE:
			if (ep->sc_vars) {
				for (vp = ep->sc_vars; vp < ep->sc_vars + ep->sc_nvars; vp++)
					if (*vp) {
						TRACE2(tet_Tbuf, 6,
							"free variable %s",
							tet_i2x(*vp));
						free(*vp);
					}
				TRACE2(tet_Tbuf, 6, "free variable list %s",
					tet_i2x(ep->sc_vars));
				free((char *) ep->sc_vars);
			}
			break;
		}
		break;
	}

	/*
	** note that we can't free any other allocated data storage -
	** it is probably still referenced in another scentab element
	*/
}

/*
**	scstore() - store a scenario element in the tree at the
**		current level
**
**	the pointer at *sctp points to the last element stored at this level
**
**	the element at *ep is stored below the one at *parent and
**	after the one at **sctp
**
**	the pointer at *sctp is updated to point to the newly stored element
*/

void scstore(ep, parent, sctp)
register struct scentab *ep, *parent, **sctp;
{
	TRACESCELEM(tet_Tscen, 4, ep, "scstore(): store an element");
	TRACESCELEM(tet_Tscen, 6, parent, "... below the element at");

#ifndef NOTRACE
	if (*sctp)
		TRACESCELEM(tet_Tscen, 6, *sctp,
			"... and to the right of the element at");
	else
		TRACE1(tet_Tscen, 6, "... starting a new level");
#endif

	if (parent->sc_child) {
		ASSERT(*sctp && (*sctp)->sc_magic == SC_MAGIC);
		(*sctp)->sc_forw = ep;
		ep->sc_back = *sctp;
	}
	else {
		ASSERT(*sctp == (struct scentab *) 0);
		parent->sc_child = ep;
		ep->sc_back = (struct scentab *) 0;
	}
	ep->sc_forw = (struct scentab *) 0;
	ep->sc_child = (struct scentab *) 0;
	ep->sc_parent = parent;
	*sctp = ep;
}

/*
**	scpush(), scpop() - scenario stack manipulation functions
*/

void scpush(ep, sp)
struct scentab *ep, **sp;
{
	ASSERT(ep->sc_magic == SC_MAGIC);

	/* ensure that this element is not already on a stack somewhere */
	ASSERT(ep->sc_next == (struct scentab *) 0);
	ASSERT(ep->sc_last == (struct scentab *) 0);

	TRACE3(tet_Tscen, 8, "scpush(): push element %s on stack %s",
		tet_i2x(ep), tet_i2x(sp));
	TRACESCELEM(tet_Tscen, 8, ep, (char *) 0);

	tet_listinsert((struct llist **) sp, (struct llist *) ep);
}

struct scentab *scpop(sp)
struct scentab **sp;
{
	register struct scentab *ep;

	if ((ep = *sp) != (struct scentab *) 0) {
		ASSERT(ep->sc_magic == SC_MAGIC);
		tet_listremove((struct llist **) sp, (struct llist *) ep);
		TRACE3(tet_Tscen, 8, "scpop(): pop element %s from stack %s",
			tet_i2x(ep), tet_i2x(sp));
		TRACESCELEM(tet_Tscen, 6, ep, (char *) 0);
	}
	else
		TRACE2(tet_Tscen, 8, "scpop(): %s stack empty", tet_i2x(sp));

	return(ep);
}

/*
**	scrm_lnode() - remove a leaf node from the scenario tree and free it
**
**	note that this function breaks the forward pointer chain
*/

void scrm_lnode(ep)
register struct scentab *ep;
{
	ASSERT(ep->sc_parent != (struct scentab *) 0);
	ASSERT(ep->sc_child == (struct scentab *) 0);

	if (ep->sc_forw)
		ep->sc_forw->sc_back = ep->sc_back;
	if (ep->sc_back)
		ep->sc_back->sc_forw = ep->sc_forw;
	if (ep->sc_parent->sc_child == ep)
		ep->sc_parent->sc_child = ep->sc_forw;

	scfree(ep);
}

/*
**	tracescelem() - print trace messages describing a scenario element
*/

#ifndef NOTRACE

void tracescelem(flag, level, ep, text)
int flag, level;
register struct scentab *ep;
char *text;
{
	static char null[] = "NULL";
	register int n;

	if (text)
		TRACE3(flag, level, "%s %s", text, tet_i2x(ep));

	if (!ep || ep->sc_magic != SC_MAGIC)
		return;

	TRACE4(flag, level + 1, "type = %s, next = %s, last = %s",
		prsctype(ep->sc_type), tet_i2x(ep->sc_next),
		tet_i2x(ep->sc_last));
	TRACE5(flag, level + 1,
		"forward = %s, backward = %s, parent = %s, child = %s",
		tet_i2x(ep->sc_forw), tet_i2x(ep->sc_back),
		tet_i2x(ep->sc_parent), tet_i2x(ep->sc_child));

	switch (ep->sc_type) {
	case SC_SCENARIO:
		TRACE3(flag, level + 2, "\t%s: name = %s",
			prsctype(ep->sc_type), ep->sc_scenario);
		break;
	case SC_DIRECTIVE:
		TRACE3(flag, level + 2, "\t%s = %s",
			prsctype(ep->sc_type), prscdir(ep->sc_directive));
		switch (ep->sc_directive) {
		case SD_PARALLEL:
		case SD_REPEAT:
			TRACE2(flag, level + 2,
				"\t\tcount = %s", tet_i2a(ep->sc_count));
			break;
		case SD_TIMED_LOOP:
			TRACE2(flag, level + 2, "\t\tseconds = %s",
				tet_l2a(ep->sc_seconds));
			break;
		case SD_VARIABLE:
			TRACE2(flag, level + 2,
				"\t\tnvars = %s", tet_i2a(ep->sc_nvars));
			for (n = 0; n < ep->sc_nvars; n++)
				TRACE2(flag, level + 2, "\t\t\t%s",
					*(ep->sc_vars + n));
			break;
#ifndef TET_LITE	/* -START-LITE-CUT- */
		case SD_REMOTE:
		case SD_DISTRIBUTED:
			TRACE2(flag, level + 2,
				"\t\tnsys = %s", tet_i2a(ep->sc_nsys));
			for (n = 0; n < ep->sc_nsys; n++)
				TRACE2(flag, level + 2, "\t\t\tsystem = %s",
					tet_i2a(*(ep->sc_sys + n)));
			break;
#endif /* !TET_LITE */	/* -END-LITE-CUT- */
		}
		break;
	case SC_TESTCASE:
		TRACE3(flag, level + 2, "\t%s = %s",
			prsctype(ep->sc_type), ep->sc_tcname);
		TRACE2(flag, level + 2, "\tscenfile IC list = %s",
			ep->sc_sciclist ? ep->sc_sciclist : null);
		TRACE2(flag, level + 2, "\texec IC list = %s",
			ep->sc_exiclist ? ep->sc_exiclist : null);
		break;
	case SC_SCENINFO:
		TRACE3(flag, level + 2, "\t%s = <%s>",
			prsctype(ep->sc_type), ep->sc_sceninfo);
		break;
	case SC_SCEN_NAME:
		TRACE4(flag, level + 2, "\t%s = %s (%s)",
			prsctype(ep->sc_type), ep->sc_scen_name,
			tet_i2x(ep->sc_scenptr));
		break;
	}

	TRACE2(flag, level + 1, "\tflags = %s", prscflags(ep->sc_flags));
	TRACE4(flag, level + 1, "\tref = %s, file = %s, line = %s",
		tet_l2a(ep->sc_ref), ep->sc_fname, tet_i2a(ep->sc_lineno));
}

#endif /* NOTRACE */

/*
**	prsctype() - return printable representation of
**		scenario element sc_type value
*/

char *prsctype(type)
int type;
{
	static char fmt[] = "<scenario type %d>";
	static char msg[sizeof fmt + LNUMSZ];

	switch (type) {
	case SC_SCENARIO:
		return("SCENARIO HEADER");
	case SC_DIRECTIVE:
		return("DIRECTIVE");
	case SC_TESTCASE:
		return("TEST CASE");
	case SC_SCENINFO:
		return("SCENARIO INFORMATION LINE");
	case SC_SCEN_NAME:
		return("REFERENCED SCENARIO NAME");
	default:
		(void) sprintf(msg, fmt, type);
		return(msg);
	}
}

/*
**	prscflags() - return printable representation of
**		scenario element sc_flags value
*/

char *prscflags(fval)
int fval;
{
	static struct flags flags[] = {
		{ SCF_IMPLIED, "IMPLIED" },
		{ SCF_PROCESSED, "PROCESSED" },
		{ SCF_RESOLVED, "RESOLVED" },
		{ SCF_ERROR, "ERROR" },
		{ SCF_NEEDED, "NEEDED" },
		{ SCF_DATA_USED, "DATA_USED" },
		{ SCF_SKIP_BUILD, "SKIP_BUILD" },
		{ SCF_SKIP_EXEC, "SKIP_EXEC" },
		{ SCF_SKIP_CLEAN, "SKIP_CLEAN" },
	};

	return(tet_f2a(fval, flags, sizeof flags / sizeof flags[0]));
}

/*
**	prscdir() - return printable representation of a directive type value
*/

char *prscdir(directive)
int directive;
{
	static char fmt[] = "<directive %d>";
	static char msg[sizeof fmt + LNUMSZ];
	register struct dirtab *dp;

	switch (directive) {
	case SD_SEQUENTIAL:
		return("SEQUENTIAL");
	default:
		dp = getdirbyvalue(directive);
		if (dp && dp->dt_name)
			return(dp->dt_name);
		else {
			(void) sprintf(msg, fmt, directive);
			return(msg);
		}
	}
}

