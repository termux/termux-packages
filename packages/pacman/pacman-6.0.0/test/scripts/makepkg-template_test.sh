#!/bin/bash

source "$(dirname "$0")"/../tap.sh || exit 1

script=${1:-${PMTEST_SCRIPT_DIR}makepkg-template}

if ! type -p "$script" &>/dev/null; then
	tap_bail "makepkg-template executable (%s) could not be located" "${script}"
	exit 1
fi

TMPDIR="$(mktemp -d "/tmp/${0##*/}.XXXXXX")"
trap "rm -rf '${TMPDIR}'" EXIT TERM
cp -r "${0%/*}/makepkg-template-tests" "$TMPDIR/makepkg-template-tests"

# normalize paths
script="$(readlink -f $(type -p "$script"))"
cd "$TMPDIR"
testdir="./makepkg-template-tests"


total=$(find "$testdir" -maxdepth 1 -mindepth 1 -type d | wc -l)
if [[ -z "$total" ]]; then
	tap_bail "unable to determine total number of tests"
	exit 1
fi
tap_plan "$((total*3))"

run_test() {
	local testcase=$1 exitcode expected_result expected_output
	local -a arguments
	local -i expected_exitcode=-1

	[[ -f "$testdir/$testcase/testcase-config" ]] || continue
	source "$testdir/$testcase/testcase-config"

	mkdir "$TMPDIR/$testcase"
	touch "$TMPDIR/$testcase/result"

	# work around autotools not putting symlinks into the release tarball
	[[ -d "$TMPDIR/$testdir/$testcase/templates" ]] || mkdir "$TMPDIR/$testdir/$testcase/templates"
	if type -t _setup_testcase >/dev/null; then
		cd "$TMPDIR/$testdir/$testcase"
		_setup_testcase
		unset -f _setup_testcase
		cd "$TMPDIR"
	fi

	LC_ALL=C "$script" \
		--template-dir "$testdir/$testcase/templates" \
		-p "$testdir/$testcase/PKGBUILD" \
		-o "$TMPDIR/$testcase/result" \
		&> "$TMPDIR/$testcase/output" "${arguments[@]}"
	exitcode=$?

	tap_is_int "$exitcode" "$expected_exitcode" "$testcase exitcode"
	tap_diff "$TMPDIR/$testcase/output" <(printf "%s" "$expected_output") "$testcase output"
	tap_diff "$TMPDIR/$testcase/result" <(printf "%s" "$expected_result") "$testcase resulting PKGBUILD"
}

for dir in "$testdir/"*; do
	if [[ -d "$dir" ]]; then
		run_test "${dir##*/}"
	fi
done

tap_finish
