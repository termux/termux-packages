#!/bin/bash
#
#   parseopts.sh - getopt_long-like parser
#
#   Copyright (c) 2012-2021 Pacman Development Team <pacman-dev@archlinux.org>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# A getopt_long-like parser which portably supports longopts and
# shortopts with some GNU extensions. For both short and long opts,
# options requiring an argument should be suffixed with a colon, and
# options with optional arguments should be suffixed with a question
# mark. After the first argument containing the short opts, any number
# of valid long opts may be be passed. The end of the options delimiter
# must then be added, followed by the user arguments to the calling
# program.
#
# Options with optional arguments will be returned as "--longopt=optarg"
# for longopts, or "-o=optarg" for shortopts. This isn't actually a valid
# way to pass an optional argument with a shortopt on the command line,
# but is done by parseopts to enable the caller script to split the option
# and its optarg easily.
#
# Recommended Usage:
#   OPT_SHORT='fb:zq?'
#   OPT_LONG=('foo' 'bar:' 'baz' 'qux?')
#   if ! parseopts "$OPT_SHORT" "${OPT_LONG[@]}" -- "$@"; then
#     exit 1
#   fi
#   set -- "${OPTRET[@]}"
# Returns:
#   0: parse success
#   1: parse failure (error message supplied)
parseopts() {
	local opt= optarg= i= shortopts=$1
	local -a longopts=() unused_argv=()

	shift
	while [[ $1 && $1 != '--' ]]; do
		longopts+=("$1")
		shift
	done
	shift

	longoptmatch() {
		local o longmatch=()
		for o in "${longopts[@]}"; do
			if [[ ${o%[:?]} = "$1" ]]; then
				longmatch=("$o")
				break
			fi
			[[ ${o%[:?]} = "$1"* ]] && longmatch+=("$o")
		done

		case ${#longmatch[*]} in
			1)
				# success, override with opt and return arg req (0 == none, 1 == required, 2 == optional)
				opt=${longmatch%[:?]}
				case $longmatch in
					*:)  return 1 ;;
					*\?) return 2 ;;
					*)   return 0 ;;
				esac
				;;
			0)
				# fail, no match found
				return 255 ;;
			*)
				# fail, ambiguous match
				printf "${0##*/}: $(gettext "option '%s' is ambiguous; possibilities:")" "--$1"
				printf " '%s'" "${longmatch[@]%[:?]}"
				printf '\n'
				return 254 ;;
		esac >&2
	}

	while (( $# )); do
		case $1 in
			--) # explicit end of options
				shift
				break
				;;
			-[!-]*) # short option
				for (( i = 1; i < ${#1}; i++ )); do
					opt=${1:i:1}

					case $shortopts in
						# option requires optarg
						*$opt:*)
							# if we're not at the end of the option chunk, the rest is the optarg
							if (( i < ${#1} - 1 )); then
								OPTRET+=("-$opt" "${1:i+1}")
								break
							# if we're at the end, grab the the next positional, if it exists
							elif (( i == ${#1} - 1 && $# > 1 )); then
								OPTRET+=("-$opt" "$2")
								shift
								break
							# parse failure
							else
								printf "${0##*/}: $(gettext "option requires an argument") -- '%s'\n" "$opt" >&2
								OPTRET=(--)
								return 1
							fi
							;;
						# option's optarg is optional
						*$opt\?*)
							# if we're not at the end of the option chunk, the rest is the optarg
							if (( i < ${#1} - 1 )); then
								OPTRET+=("-$opt=${1:i+1}")
								break
							# option has no optarg
							else
								OPTRET+=("-$opt")
							fi
							;;
						# option has no optarg
						*$opt*)
							OPTRET+=("-$opt")
							;;
						# option doesn't exist
						*)
							printf "${0##*/}: $(gettext "invalid option") -- '%s'\n" "$opt" >&2
							OPTRET=(--)
							return 1
							;;
					esac
				done
				;;
			--?*=*|--?*) # long option
				IFS='=' read -r opt optarg <<< "${1#--}"
				longoptmatch "$opt"
				case $? in
					0)
						# parse failure
						if [[ $1 = *=* ]]; then
							printf "${0##*/}: $(gettext "option '%s' does not allow an argument")\n" "--$opt" >&2
							OPTRET=(--)
							return 1
						# --longopt
						else
							OPTRET+=("--$opt")
						fi
						;;
					1)
						# --longopt=optarg
						if [[ $1 = *=* ]]; then
							OPTRET+=("--$opt" "$optarg")
						# --longopt optarg
						elif (( $# > 1 )); then
							OPTRET+=("--$opt" "$2" )
							shift
						# parse failure
						else
							printf "${0##*/}: $(gettext "option '%s' requires an argument")\n" "--$opt" >&2
							OPTRET=(--)
							return 1
						fi
						;;
					2)
						# --longopt=optarg
						if [[ $1 = *=* ]]; then
							OPTRET+=("--$opt=$optarg")
						# --longopt
						else
							OPTRET+=("--$opt")
						fi
						;;
					254)
						# ambiguous option -- error was reported for us by longoptmatch()
						OPTRET=(--)
						return 1
						;;
					255)
						# parse failure
						printf "${0##*/}: $(gettext "invalid option") '--%s'\n" "$opt" >&2
						OPTRET=(--)
						return 1
						;;
				esac
				;;
			*) # non-option arg encountered, add it as a parameter
				unused_argv+=("$1")
				;;
		esac
		shift
	done

	# add end-of-opt terminator and any leftover positional parameters
	OPTRET+=('--' "${unused_argv[@]}" "$@")
	unset longoptmatch

	return 0
}
