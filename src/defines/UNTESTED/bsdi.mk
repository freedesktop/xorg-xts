#
#       SCCS: @(#)bsdi.mk	1.1 (99/03/31)
#
#       UniSoft Ltd., London, England
#
# Copyright (c) 1998 The Open Group
# All rights reserved.
#
# No part of this source code may be reproduced, stored in a retrieval
# system, or transmitted, in any form or by any means, electronic,
# mechanical, photocopying, recording or otherwise, except as stated in
# the end-user licence agreement, without the prior permission of the
# copyright owners.
# A copy of the end-user licence agreement is contained in the file
# Licence which accompanies this distribution.
# 
# Motif, OSF/1, UNIX and the "X" device are registered trademarks and
# IT DialTone and The Open Group are trademarks of The Open Group in
# the US and other countries.
#
# X/Open is a trademark of X/Open Company Limited in the UK and other
# countries.
#
# ************************************************************************
#
# SCCS:   	@(#)bsdi.mk	1.1 99/03/31 TETware Release 
# NAME:		bsdi.mk
# PRODUCT:	TETware
# AUTHOR:	Andrew Josey
# DATE CREATED:	March 1999
#
# DESCRIPTION:
#	defines.mk file for BSDI
#       Contributed by Brad Knotwell
#
# MODIFICATIONS:
#	Andrew Dingwall, UniSoft Ltd., March 1999
#	Integrated into the TETware source tree (but not tested).
# 
# ************************************************************************

# tccd can be started:
#	from /etc/inittab (SYSV systems)
#	from /etc/inetd (BSD4.3 style)
#	from /etc/rc (BSD4.2 style)
#	interactively by a user
#
# inittab systems should include -DINITTAB in DTET_CDEFS below
# inetd systems should include -DINETD in DTET_CDEFS below
# [ Not relevant for TETware-Lite ]

# TCCD specifies the name by which tccd is to be known; this should be in.tccd
# if you define INETD, otherwise it should be tccd
# [ Not used when building TETware-Lite ]
TCCD = in.tccd

# make utilities - these don't usually change
MAKE = gmake
SHELL = /bin/sh

# TET and DTET defines; one of these is added to CDEFS in each compilation
#	TET_CDEFS are used to compile most source files
#	    these should include -D_POSIX_SOURCE 
#	    you may want to define TET_SIG_IGNORE and TET_SIG_LEAVE here
#
#	DTET_CDEFS are used to compile source files which use non-POSIX
#	features, such as networking and threads
#	    for example:
#	    inet:  DTET_CDEFS = -D_ALL_SOURCE -DINETD
#	    xti:   DTET_CDEFS = -D_ALL_SOURCE -DTCPTPI
#
TET_CDEFS = -D_POSIX_SOURCE -DNSIG=32
DTET_CDEFS = -D_ALL_SOURCE -DINETD

# sgs component definitions and flags
# CC - the name of the C compiler
CC = gcc
# CDEFS may be passed to lint and cc, COPTS to cc only
# CDEFS usually defines NSIG (the highest signal number plus one)
CDEFS = -I$(INC) -I$(DINC) 
COPTS = -O
# THR_COPTS is used instead of COPTS when compiling the thread API library.
# To disable thread support, set THR_COPTS = THREADS_NOT_SUPPORTED.
# For POSIX threads, include -DTET_POSIX_THREADS (default is UI threads).
THR_COPTS = -DTET_POSIX_THREADS -DETIME=ETIMEDOUT 
# LDFLAGS - loader flags used by make's built-in rules
LDFLAGS =
# C_PLUS - the name of the C++ compiler
# To disable C++ support, set C_PLUS = CPLUSPLUS_NOT_SUPPORTED.
C_PLUS = g++
# C_SUFFIX - suffix for C++ source files
C_SUFFIX = C
# if your system's a.out format includes a .comment section that can be
# compressed by using mcs -c, set MCS to mcs; otherwise set MCS to @:
MCS = @:
# AR is the name of the archive library maintainer
AR = ar
# LORDER and TSORT are the names for lorder and tsort, used to order an archive
# library; if they don't exist on your system or don't work, set LORDER to echo
# and TSORT to cat
LORDER = echo 
TSORT = cat
# if your system needs ranlib run after an archive library is updated,
# set RANLIB to ranlib; otherwise set RANLIB to @:
RANLIB = ranlib

# Source and object file suffixes that are understood by the sgs
# on this platform.
# Note that all these suffixes may include an initial dot - this convention
# permits an empty suffix to be specified.
# O - suffix that denotes an object file (e.g.: .obj or .o)
O = .o
# A - suffix that denotes an archive library (e.g.: .lib or .a)
A = .a
# E - suffix that denotes an executable file (e.g.: .exe or nothing)
E =

# system libraries for inclusion at the end of cc command line
SYSLIBS =

# Definitions for xpg3sh API and TCM
#
# standard signal numbers - change to correct numbers for your system
# SIGHUP, SIGINT, SIGQUIT, SIGILL, SIGABRT, SIGFPE, SIGPIPE, SIGALRM,
# SIGTERM, SIGUSR1, SIGUSR2, SIGTSTP, SIGCONT, SIGTTIN, SIGTTOU
# 
# Example: SH_STD_SIGNALS = 1 2 3 4 6 8 13 14 15 16 17 25 26 27 28
SH_STD_SIGNALS = 1 2 3 4 6 8 13 14 15 30 31 18 19 21 22

# signals that are always unhandled - change for your system
# May need to include SIGSEGV and others if the shell can't trap them
# SIGKILL, SIGCHLD, SIGSTOP, (SIGSEGV, ...)
#
# Example: SH_SPEC_SIGNALS = 9 18 24 11
SH_SPEC_SIGNALS = 9 20 17 

# highest shell signal number plus one
# May need to be less than the value specified with -DNSIG in CDEFS
# if the shell can't trap higher signal numbers
SH_NSIG = 32

# Definitions for ksh API and TCM
KSH_STD_SIGNALS = $(SH_STD_SIGNALS)
KSH_SPEC_SIGNALS = $(SH_SPEC_SIGNALS)
KSH_NSIG = $(SH_NSIG)

# Variables added in TETware release 3.3.
# Refer to "Preparing to build TETware" in the TETware Installation Guide
# for UNIX Operating Systems for further details.
#
# Not yet tested on this platform.
TET_THR_CDEFS = $(DTET_CDEFS)
DTET_THR_CDEFS = $(DTET_CDEFS)
SHLIB_COPTS = SHLIB_NOT_SUPPORTED
SHLIB_CC = $(CC)
SHLIB_BUILD =
SHLIB_BUILD_END =
THRSHLIB_BUILD_END =
SO =

