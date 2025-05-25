#!/usr/bin/env bash
sha256sums=()
scriptdir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd)"
buildsh="${scriptdir}/build.sh"
getvar() {
	<"${buildsh}" awk -v scope=0 '
$0 ~ /^termux_step_post_get_source/ {scope=1}
scope == 1 && /local[[:blank:]]*-A[[:blank:]]*'"$1"'=\(/ {var=1; print gensub(/.*=\(/,"",1); next}
var == 1 {if ($0 ~ /\)/) { var=0; sub(/\)/,"",$0); } print}
'
}

tmpd="$(mktemp -d "${TMPDIR-/tmp}/termux.src.dl.XXXXXXXX")"
trap 'cd "$scriptdir"; rm -rf "$tmpd"; trap - EXIT; exit' INT EXIT TERM
[ -d "$tmpd" ] || { printf 'Error: mktemp failed'; exit 1; }
pushd "$tmpd" >/dev/null

eval project="$(<"${buildsh}" awk '/local[[:blank:]]*_project=/ {print gensub(/.*=/,"",1)}')"
sha256sums=($(
	for i in SHA256 URL COMMIT; do
		eval "declare -A GIT_$i=($(getvar _GIT_"$i"))"
	done
	for proj in "${project[@]}"; do
		# the commands enclosed in braces can be replaced with git clone --revision "${GIT_COMMIT["$proj"]}" --depth 1 in git 2.49
		{
		mkdir "$( printf "%s" "${GIT_URL["$proj"]}" | sed -E 's|^.*/(.*)$|\1|' )"
		pushd "$( printf "%s" "${GIT_URL["$proj"]}" | sed -E 's|^.*/(.*)$|\1|' )"
		git init -q
		git remote add origin "${GIT_URL["$proj"]:4}"
		git fetch --depth 1 origin "${GIT_COMMIT["$proj"]}"
		git -c advice.detachedHead=false checkout "${GIT_COMMIT["$proj"]}"
		} >/dev/null
		# we need a deterministic checksum, logs get in the way
		rm -rf .git/logs
		printf '[%s]=' "$proj"
		find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum | awk '{printf "%s ",$1}'
		popd >/dev/null
	done
))
sed -zi 's/\(_GIT_SHA256=(\)[^)]*)/\1\n'"$(printf '\\t\\t%s\\n' "${sha256sums[@]}")"'\t)/' "${buildsh}"
