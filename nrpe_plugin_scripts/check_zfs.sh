#!/usr/bin/env python
#
#  check_zfs.py: Check zfs filessystems.
#
#
# NRPE Exit Codes: 0 == OK, 1 == Warning, 2 == Critical, 3 == Unknown
#
###############################################################################
# Grab each filesystem and create a array of data then output it in a useful fashon doing stuff.
# also allow a failsystem top be fed in as a  argument and then only work on that single filesystem.
