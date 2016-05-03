#!/usr/bin/env bash

# TODO: docblock

set -x

function check-connection() {
    source colors.sh
    || echo "FATAL: can't find colors..." >&2; exit 1
    source reporter.sh
    || echo "${RED}FATAL: can't find reporter function...${NC}" >&2; exit 1

    reporter "Confirming internet connection"
    if [[ ! $(curl -Is http://www.google.com/ | head -n 1) =~ "200 OK" ]]; then
      echo "${RED}Your Internet seems broken.\n
            Press Ctrl-C to abort or enter to continue.${NC}"
      read
    else
      echo "${GRN}Connection successful${NC}"
    fi
}
