#!/bin/sh
# rfc.sh -- 
# Created: Tue Apr 22 09:41:37 1997 by faith@cs.unc.edu
# Revised: Tue Apr 22 09:46:26 1997 by faith@cs.unc.edu
# Public Domain 1997 Rickard E. Faith (faith@cs.unc.edu)
# 
# $Id: rfc.sh,v 1.1 1997/05/26 11:31:32 faith Exp $
# 
#

awk '/.*FORMFEED.*/ { print; flag=1; next }
     /^$/           { if (!flag) print; next }
                    { print; flag=0 }' \
| sed 's/^\(.*\)FORMFEED\(.*\)$/\1        \2\
/'
