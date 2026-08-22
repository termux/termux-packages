#!/bin/bash
set -euo pipefail

# Finds files shipped by 2+ published packages with no Conflicts/Replaces/
# Breaks declared between them in the local checkout (a fix may be merged
# but not yet published). Prints "PKG_A PKG_B PATH (REPO/ARCH)" per finding.

cd "$(realpath "$(dirname "$0")")/../.."

declare -A pkg_relations_cache=()

pkg_declares_relation_to() {
	# $1: package whose declarations to check, $2: package to look for.
	local pkg="$1" other="$2" dir file declared=""
	if [[ -z "${pkg_relations_cache[$pkg]+x}" ]]; then
		for dir in packages root-packages x11-packages; do
			if [[ -f "$dir/$pkg/build.sh" ]]; then
				declared=$(
					set +eu
					. "$dir/$pkg/build.sh"
					printf '%s\n' "$TERMUX_PKG_CONFLICTS" "$TERMUX_PKG_REPLACES" "$TERMUX_PKG_BREAKS"
				)
				break
			fi
			file=$(compgen -G "$dir/*/$pkg.subpackage.sh" | head -n1 || true)
			if [[ -n "$file" ]]; then
				declared=$(
					set +eu
					TERMUX_SUBPKG_CONFLICTS="" TERMUX_SUBPKG_REPLACES="" TERMUX_SUBPKG_BREAKS=""
					. "$file"
					printf '%s\n' "$TERMUX_SUBPKG_CONFLICTS" "$TERMUX_SUBPKG_REPLACES" "$TERMUX_SUBPKG_BREAKS"
				)
				break
			fi
		done
		pkg_relations_cache[$pkg]=$(
			tr ',' '\n' <<< "$declared" |
				sed -E 's/\(.*\)//; s/^[[:space:]]+//; s/[[:space:]]+$//' |
				sed '/^$/d'
		)
	fi
	grep -qx "$other" <<< "${pkg_relations_cache[$pkg]}"
}

for repo in $(jq --raw-output 'del(.pkg_format) | keys | .[]' repo.json); do
	distribution=$(jq --raw-output '.["'"${repo}"'"].distribution' repo.json)
	url=$(jq --raw-output '.["'"${repo}"'"].url' repo.json)

	for arch in aarch64 arm i686 x86_64; do
		if [[ ! -f "Contents-${repo}-${arch}" ]]; then
			echo "[*] Downloading ${url}/dists/${distribution}/Contents-${arch}.gz" >&2
			curl -s \
				--user-agent 'Termux-Packages/1.0\ (https://github.com/termux/termux-packages)' \
				"${url}/dists/${distribution}/Contents-${arch}.gz" \
				-o "Contents-${repo}-${arch}.gz"
			gunzip -k "Contents-${repo}-${arch}.gz"
		fi

		while read -r path owners; do
			[[ "$owners" == *,* ]] || continue
			IFS=',' read -r -a owner_list <<< "$owners"
			for ((i = 0; i < ${#owner_list[@]}; i++)); do
				for ((j = i + 1; j < ${#owner_list[@]}; j++)); do
					a=${owner_list[i]}
					b=${owner_list[j]}
					pkg_declares_relation_to "$a" "$b" && continue
					pkg_declares_relation_to "$b" "$a" && continue
					echo "${a} ${b} ${path} (${repo}/${arch})"
				done
			done
		done < "Contents-${repo}-${arch}"
	done
done
