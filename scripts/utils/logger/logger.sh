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

LOGGER__MAX_LOG_LEVEL=4 # Default: `4` (VVERBOSE=4)

# Logger log levels: (OFF=0, NORMAL=1, DEBUG=2, VERBOSE=3, VVERBOSE=4),  Default: `1`
case "${LOGGER__LOG_LEVEL:-}" in
    0|1|2|3|4) :;;
    *) LOGGER__LOG_LEVEL=1;;
esac

### Set Default Variables End

LOGGER__VARIABLES_SET=1

}


##
# logger__log `<log_level>` `<log_string>`
##
logger__log() { local log_level="${1}"; shift; if [ "${LOGGER__LOG_LEVEL:-1}" -ge "$log_level" ]; then data__printfln_string "${1:-}"; fi }

##
# logger__log_literal `<log_level>` `<log_string>`
##
logger__log_literal() { local log_level="${1}"; shift; if [ "${LOGGER__LOG_LEVEL:-1}" -ge "$log_level" ]; then data__printfln_literal_string "${1:-}"; fi }

##
# logger__log_formatted `<log_level>` `<log_string...>`
##
logger__log_formatted() { local log_level="${1}"; shift; if [ "${LOGGER__LOG_LEVEL:-1}" -ge "$log_level" ]; then data__printf_formatted_string "$@"; fi }



##
# logger__log_errors `<log_string>`
##
logger__log_errors() { data__printfln_string "${1:-}" 1>&2; }

##
# logger__log_errors_literal `<log_string>`
##
logger__log_errors_literal() { data__printfln_literal_string "${1:-}" 1>&2; }

##
# logger__log_errors_formatted `<log_string...>`
##
logger__log_errors_formatted() { data__printf_formatted_string "$@" 1>&2; }
