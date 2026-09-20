#!/bin/bash
set -euo pipefail

# Finds files shipped by 2+ published packages with no Conflicts/Replaces/
# Breaks declared between them in the local checkout (a fix may be merged
# but not yet published). Prints "PKG_A PKG_B PATH (REPO/ARCH)" per finding.

cd "$(realpath "$(dirname "$0")")/../.."

TERMUX_PREFIX=$(. scripts/properties.sh && echo "$TERMUX_PREFIX")

audit_tmpdir=$(mktemp -d)

declare -A pkg_relations_cache=()

pkg_arch_for_build_sh() {
	# $1: path to a build.sh; prints an arch not in its TERMUX_PKG_EXCLUDED_ARCHES.
	local build_sh="$1" line excluded_arches="" arch candidate
	while IFS= read -r line; do
		if [[ "$line" == TERMUX_PKG_EXCLUDED_ARCHES=* ]]; then
			excluded_arches="${line#TERMUX_PKG_EXCLUDED_ARCHES=}"
			excluded_arches="${excluded_arches%%#*}"
			excluded_arches="${excluded_arches//[\"\',]/ }"
			break
		fi
	done < "$build_sh"
	arch=aarch64
	for candidate in aarch64 arm i686 x86_64; do
		[[ " $excluded_arches " == *" $candidate "* ]] || { arch="$candidate"; break; }
	done
	echo "$arch"
}

pkg_declares_relation_to() {
	# $1: package whose declarations to check, $2: package to look for.
	local pkg="$1" other="$2" dir file declared="" arch
	local -a fields
	local field relations
	if [[ -z "${pkg_relations_cache[$pkg]+x}" ]]; then
		for dir in packages root-packages x11-packages; do
			if [[ -f "$dir/$pkg/build.sh" ]]; then
				: "${TERMUX_PKG_MAKE_PROCESSES:=$(nproc)}"
				arch=$(pkg_arch_for_build_sh "$dir/$pkg/build.sh")
				declared=$(
					set +eu
					TERMUX_ARCH="$arch"
					TERMUX_PKG_MAKE_PROCESSES="$TERMUX_PKG_MAKE_PROCESSES"
					. "$dir/$pkg/build.sh"
					printf '%s\n' "$TERMUX_PKG_CONFLICTS" "$TERMUX_PKG_REPLACES" "$TERMUX_PKG_BREAKS"
				)
				break
			fi

			file=$(compgen -G "$dir/*/$pkg.subpackage.sh" || true)
			file=${file%%$'\n'*}
			if [[ -n "$file" ]]; then
				arch=$(pkg_arch_for_build_sh "${file%/*}/build.sh")
				declared=$(
					set +eu
					TERMUX_ARCH="$arch"
					TERMUX_PKG_TMPDIR="$audit_tmpdir"
					TERMUX_SUBPKG_CONFLICTS="" TERMUX_SUBPKG_REPLACES="" TERMUX_SUBPKG_BREAKS=""
					. "$file"
					printf '%s\n' "$TERMUX_SUBPKG_CONFLICTS" "$TERMUX_SUBPKG_REPLACES" "$TERMUX_SUBPKG_BREAKS"
				)
				break
			fi
		done
		relations=""
		IFS=$',\n' read -rd '' -a fields <<< "$declared" || true
		for field in "${fields[@]}"; do
			field="${field%%(*}"
			field="${field#"${field%%[![:space:]]*}"}"
			field="${field%"${field##*[![:space:]]}"}"
			[[ -n "$field" ]] && relations+="$field"$'\n'
		done
		pkg_relations_cache[$pkg]="${relations%$'\n'}"
	fi
	[[ $'\n'"${pkg_relations_cache[$pkg]}"$'\n' == *$'\n'"$other"$'\n'* ]]
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

		while IFS= read -r line; do
			owners=${line##* }
			[[ "$owners" == *,* ]] || continue
			path=${line% "$owners"}
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

rm -rf "$audit_tmpdir"
