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
    message="$1"
    shift
    echo
    echo "${message}"
    for (( i=0; i<${#message}; i++ )); do
        echo -n '-'
    done
    echo
}
