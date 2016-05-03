#!/usr/bin/env bash

###############################################################################
##                     ------------------------------                        ##
##                     | Ubuntu Post Install Script |                        ##
##                     ------------------------------                        ##
## Script to set up UbuntuGnome or Ubuntu server environment customized      ##
## to my liking. You will probably not like this. Feel free to run anyway.   ##
##                                                                           ##
###############################################################################

set -x

OPTIND=1    # resets opt index to one in case of previous getopts usage
INSTALL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function main() {
    source ${INSTALL_DIR}/functions/reporter.sh
    source ${INSTALL_DIR}/functions/desktop.sh
    source ${INSTALL_DIR}/functions/rpi.sh

    while getopts "dr:" opt; do
        case "$opt" in
        d)  reporter "Installing desktop configuration"
            install-on-desktop ${INSTALL_DIR}
            ;;
        r)  reporter "Installing raspberry pi configuration" 
            install-on-rpi ${INSTALL_DIR}
            ;;
        dr) echo $"Usage: $0 -{r || d}"
            exit 1
            ;;
        *)  echo $"Usage: $0 -{r || d}"
            exit 1
            ;;
        esac
    done
}

main "$@"
