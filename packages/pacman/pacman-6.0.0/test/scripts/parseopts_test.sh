#!/bin/bash

source "$(dirname "$0")"/../tap.sh || exit 1

# source the library function
lib=${1:-${PMTEST_LIBMAKEPKG_DIR}util/parseopts.sh}
if [[ -z $lib || ! -f $lib ]]; then
	tap_bail "parseopts library ($lib) could not be located"
	exit 1
fi
. "$lib"

if ! type -t parseopts &>/dev/null; then
	tap_bail "parseopts function not found"
	exit 1
fi

# borrow opts from makepkg
OPT_SHORT="AcdefFghiLmop:rRsVb?"
OPT_LONG=('allsource' 'asroot' 'ignorearch' 'check' 'clean:' 'cleanall' 'nodeps'
          'noextract' 'force' 'forcever:' 'geninteg' 'help' 'holdver'
          'install' 'key:' 'log' 'nocolor' 'nobuild' 'nocheck' 'noprepare' 'nosign' 'pkg:' 'rmdeps'
          'repackage' 'skipinteg' 'sign' 'source' 'syncdeps' 'version' 'config:'
          'noconfirm' 'noprogressbar' 'opt?')

tap_parse() {
	local result=$1 tokencount=$2; shift 2
	parseopts "$OPT_SHORT" "${OPT_LONG[@]}" -- "$@" 2>/dev/null
	tap_is_int "${#OPTRET[@]}" "$tokencount" "$* - tokencount"
	tap_is_str "$result" "${OPTRET[*]}" "$* - result"
	unset OPTRET
}

tap_plan 56

# usage: tap_parse <expected result> <token count> test-params...
# a failed tap_parse will match only the end of options marker '--'

# no options
tap_parse '--' 1

# short options
tap_parse '-s -r --' 3 -s -r

# short options, no spaces
tap_parse '-s -r --' 3 -sr

# short opt missing an opt arg
tap_parse '--' 1 -s -p

# short opt with an opt arg
tap_parse '-p PKGBUILD -L --' 4 -p PKGBUILD -L

# short opt with an opt arg, no space
tap_parse '-p PKGBUILD --' 3 -pPKGBUILD

# valid shortopts as a long opt
tap_parse '--' 1 --sir

# long opt with no optarg
tap_parse '--log --' 2 --log

# long opt with missing optarg
tap_parse '--' 1 -sr --pkg

# long opt with optarg
tap_parse '--pkg foo --' 3 --pkg foo

# long opt with optarg with whitespace
tap_parse '--pkg foo bar -- baz' 4 --pkg "foo bar" baz

# long opt with optarg with =
tap_parse '--pkg foo=bar -- baz' 4 --pkg foo=bar baz

# long opt with explicit optarg
tap_parse '--pkg bar -- foo baz' 5 foo --pkg=bar baz

# long opt with explicit optarg, with whitespace
tap_parse '--pkg foo bar -- baz' 4 baz --pkg="foo bar"

# long opt with explicit optarg that doesn't take optarg
tap_parse '--' 1 --force=always -s

# long opt with explicit optarg with =
tap_parse '--pkg foo=bar --' 3 --pkg=foo=bar

# explicit end of options with options after
tap_parse '-s -r -- foo bar baz' 6 -s -r -- foo bar baz

# non-option parameters mixed in with options
tap_parse '-s -r -- foo baz' 5 -s foo baz -r

# optarg with whitespace
tap_parse '-p foo bar -s --' 4 -p'foo bar' -s

# non-option parameter with whitespace
tap_parse '-i -- foo bar' 3 -i 'foo bar'

# successful stem match (opt has no arg)
tap_parse '--nocolor --' 2 --nocol

# successful stem match (opt has arg)
tap_parse '--config foo --' 3 --conf foo

# ambiguous long opt
tap_parse '--' 1 '--for'

# exact match on a possible stem (--force & --forcever)
tap_parse '--force --' 2 --force

# exact match on possible stem (opt has optarg)
tap_parse '--clean foo --' 3 --clean=foo

# long opt with empty, non-empty, and no optional arg
tap_parse '--opt= --opt=foo --opt --' 4 --opt= --opt=foo --opt

# short opt with and without optional arg, and non-option arg
tap_parse '-b=foo -A -b -- foo' 5 -bfoo -Ab foo

# all possible ways to specify empty optargs
tap_parse '--key  --pkg  -p  --' 7 --key '' --pkg='' -p ''

tap_finish
