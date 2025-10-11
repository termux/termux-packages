# shellcheck shell=bash

# Title:          logger
# Description:    A library for logging.
# License-SPDX:   MIT
# Function-Depends: data



##
# Set `logger` library default variables.
# .
# .
# logger__set_default_variables
##
logger__set_default_variables() {

### Set Default Variables Start
# The following variables must not be modified unless you know what you are doing

LOGGER__LOG_LEVEL=0 # Default to 0
LOGGER__MAX_LOG_LEVEL=3 # Default to 3

### Set Default Variables End

LOGGER__VARIABLES_SET=1

}


##
# logger__log `log_level` `log_string...`
##
logger__log() { local log_level="${1}"; shift; if [ "${LOGGER__LOG_LEVEL:=0}" -ge "$log_level" ]; then data__printfln_string "$@"; fi }

##
# logger__log_literal `log_level` `log_string...`
##
logger__log_literal() { local log_level="${1}"; shift; if [ "${LOGGER__LOG_LEVEL:=0}" -ge "$log_level" ]; then data__printfln_literal_string "$@"; fi }

##
# logger__log_errors `log_string...`
##
logger__log_errors() { data__printfln_string "$@" 1>&2; }
