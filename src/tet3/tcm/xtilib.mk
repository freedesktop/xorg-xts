#
#      SCCS:  @(#)xtilib.mk	1.9 (98/09/01) 
#
#	UniSoft Ltd., London, England
#
# (C) Copyright 1993 X/Open Company Limited
#
# All rights reserved.  No part of this source code may be reproduced,
# stored in a retrieval system, or transmitted, in any form or by any
# means, electronic, mechanical, photocopying, recording or otherwise,
# except as stated in the end-user licence agreement, without the prior
# permission of the copyright owners.
#
# X/Open and the 'X' symbol are trademarks of X/Open Company Limited in
# the UK and other countries.
#
#
# ************************************************************************
#
# SCCS:   	@(#)xtilib.mk	1.9 98/09/01 TETware release 3.3
# NAME:		xtilib.mk
# PRODUCT:	TETware
# AUTHOR:	Denis McConalogue, UniSoft Ltd.
# DATE CREATED:	August 1993
#
# DESCRIPTION:
#	aux include file for XTI-specific tcm files
# 
# MODIFICATIONS:
#	Andrew Dingwall, UniSoft Ltd., December 1993
#	Moved lists of transport-specific files from makefile and dtet.mk
#	to here.
#
#	Geoff Clare, UniSoft Ltd., Sept 1996
#	Changes for TETware-Lite.
# 
#	Andrew Dingwall, UniSoft Ltd., August 1998
#	Added support for shared libraries.
#
# ************************************************************************

# additional targets when building the TCM in Distributed TETware
ALL_TS = $(ALL_DIST)
TARGETS_TS = $(TARGETS_DIST)
TARGETS_TS_S = $(TARGETS_DIST_S)

# XTI-specific tcm object files
TCM_STATIC_OFILES_TS = tcm_xt$O tcm_bs$O
TCM_SHARED_OFILES_TS =

