#!/usr/bin/env bash

###############################################################################
##                     ----------------------------                          ##
##                     | Script Reporter Function |                          ##
##                     ----------------------------                          ##
## Function to output install script status to stdout. Turn comments into    ##
## literal programming, including output during execution.                   ##
## Thanks to @EricCrosson for this function.                                 ##
##                                                                           ##
###############################################################################

set -x

# Turn comments into literal programming, including output during execution.
function reporter() {
    source colors.sh
    || echo "FATAL: can't find colors..." >&2; exit 1
    message="$1"
    shift
    echo
    echo "${ORG}${message}${NC}"
    for (( i=0; i<${#message}; i++ )); do
        echo -n "${ORG}-${NC}"
    done
    echo
}
