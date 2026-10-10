#!/bin/bash
set -euo pipefail

# Checks DEBS_DIR (default ./debs) for file conflicts between built packages,
# and against published repos for filename collisions or undeclared file conflicts.

cd "$(realpath "$(dirname "$0")")/../.."

DEBS_DIR="${1:-debs}"

termux_pkg_relations_match() {
	local relations="$1" package="$2" version="$3" relation relation_regex='^([[:alnum:]][[:alnum:]+.-]*)(:[[:alnum:]][[:alnum:].-]*)?[[:space:]]*\((<<|<=|=|>=|>>)[[:space:]]*([^)]*)\)$'

	while IFS= read -r relation; do
		relation="${relation#"${relation%%[![:space:]]*}"}"
		relation="${relation%"${relation##*[![:space:]]}"}"
		if [[ "$relation" =~ $relation_regex ]]; then
			[[ "${BASH_REMATCH[1]}" == "$package" ]] || continue
			dpkg --compare-versions "$version" "${BASH_REMATCH[3]}" "${BASH_REMATCH[4]}" && return 0
		elif [[ "$relation" == "$package" || "$relation" == "$package:"* ]]; then
			return 0
		fi
	done <<< "${relations//,/$'\n'}"

	return 1
}

shopt -s nullglob
debs=("${DEBS_DIR}"/*.deb)
shopt -u nullglob
[[ ${#debs[@]} -eq 0 ]] && exit 0

error=0

# Stage 1: Check for file conflicts between the newly built packages themselves.
declare -a deb_arches deb_names deb_versions deb_relations
local_contents=$(mktemp)
trap 'rm -f "$local_contents"' EXIT

: > "$local_contents"
for i in "${!debs[@]}"; do
	deb=${debs[i]}
	deb_arches[i]=$(dpkg-deb -f "$deb" Architecture)
	deb_names[i]=$(dpkg-deb -f "$deb" Package)
	deb_versions[i]=$(dpkg-deb -f "$deb" Version)
	deb_relations[i]=$(
		{ dpkg-deb -f "$deb" Conflicts; dpkg-deb -f "$deb" Replaces; dpkg-deb -f "$deb" Breaks; } |
			tr ',' '\n' | sed '/^[[:space:]]*$/d'
	)
	dpkg-deb --fsys-tarfile "$deb" | tar -t | sed -E 's|^\./||; /\/$/d' |
		awk -v idx="$i" '{ print $0 "\t" idx }' >> "$local_contents"
done
sort -u -t$'\t' -k1,1 -k2,2n "$local_contents" -o "$local_contents"

while IFS=$'\t' read -r path owners; do
	IFS=',' read -r -a owner_list <<< "$owners"
	for ((i = 0; i < ${#owner_list[@]}; i++)); do
		for ((j = i + 1; j < ${#owner_list[@]}; j++)); do
			a=${owner_list[i]}
			b=${owner_list[j]}
			[[ "${deb_names[a]}" == "${deb_names[b]}" ]] && continue
			[[ "${deb_arches[a]}" == "${deb_arches[b]}" || "${deb_arches[a]}" == "all" || "${deb_arches[b]}" == "all" ]] || continue
			termux_pkg_relations_match "${deb_relations[a]}" "${deb_names[b]}" "${deb_versions[b]}" && continue
			termux_pkg_relations_match "${deb_relations[b]}" "${deb_names[a]}" "${deb_versions[a]}" && continue
			local_arch=${deb_arches[a]}
			if [[ "$local_arch" == "all" ]]; then
				local_arch=${deb_arches[b]}
			fi
			echo "::error::\"${deb_names[a]}\" and \"${deb_names[b]}\" (local/${local_arch}) both ship \"$path\", with no Conflicts/Replaces/Breaks declared"
			error=1
		done
	done
done < <(awk -F '\t' '
	function emit() { if (count > 1) print path "\t" owners }
	$1 != path { emit(); path=$1; owners=$2; count=1; next }
	{ owners=owners "," $2; count++ }
	END { emit() }
' "$local_contents")

rm -f "$local_contents"
trap - EXIT

# Stage 2: Check newly built packages against packages already published in repositories.
for repo in $(jq --raw-output 'del(.pkg_format) | keys | .[]' repo.json); do
	distribution=$(jq --raw-output '.["'"${repo}"'"].distribution' repo.json)
	component=$(jq --raw-output '.["'"${repo}"'"].component' repo.json)
	url=$(jq --raw-output '.["'"${repo}"'"].url' repo.json)

	for arch in aarch64 arm i686 x86_64; do
		if [[ ! -f "Packages-${repo}-${arch}" ]]; then
			echo "[*] Downloading ${url}/dists/${distribution}/${component}/binary-${arch}/Packages.bz2"
			curl -s \
				--user-agent 'Termux-Packages/1.0\ (https://github.com/termux/termux-packages)' \
				"${url}/dists/${distribution}/${component}/binary-${arch}/Packages.bz2" \
				-o "Packages-${repo}-${arch}.bz2"
			7z x "Packages-${repo}-${arch}.bz2" > /dev/null
		fi
		if [[ ! -f "Contents-${repo}-${arch}" ]]; then
			echo "[*] Downloading ${url}/dists/${distribution}/Contents-${arch}.gz"
			curl -s \
				--user-agent 'Termux-Packages/1.0\ (https://github.com/termux/termux-packages)' \
				"${url}/dists/${distribution}/Contents-${arch}.gz" \
				-o "Contents-${repo}-${arch}.gz"
			gunzip -k "Contents-${repo}-${arch}.gz"
		fi

		for deb in "${debs[@]}"; do
			deb_arch=$(dpkg-deb -f "$deb" Architecture)
			[[ "$deb_arch" == "$arch" || "$deb_arch" == "all" ]] || continue
			pkg_name=$(dpkg-deb -f "$deb" Package)
			deb_version=$(dpkg-deb -f "$deb" Version)

			# Check that this .deb is newer than every published version of the package.
			while read -r published_version; do
				if dpkg --compare-versions "$deb_version" lt "$published_version"; then
					echo "::error::\"$pkg_name\" ${deb_version} (${repo}/${arch}) is older than published ${published_version}"
					error=1
				fi
			done < <(awk -v pkg="$pkg_name" '
				$0 == "Package: " pkg { found=1; next }
				found && /^Version: / { print $2; found=0 }
				/^$/ { found=0 }
			' "Packages-${repo}-${arch}")

			# Check that this exact .deb filename isn't already published (missed revbump).
			deb_name_escaped=$(printf '%s' "$(basename "$deb")" | sed 's/[.[\*^$]/\\&/g')
			if grep -q "^Filename:.*/${deb_name_escaped}\$" "Packages-${repo}-${arch}"; then
				echo "::error::\"$(basename "$deb")\" (${repo}/${arch}) already exists on the server"
				error=1
			fi

			# Check that this .deb doesn't ship a file already owned by a different
			# published package, unless a Conflicts/Replaces/Breaks relation is declared.
			declared=$(
				{ dpkg-deb -f "$deb" Conflicts; dpkg-deb -f "$deb" Replaces; dpkg-deb -f "$deb" Breaks; } |
					tr ',' '\n' | sed '/^[[:space:]]*$/d'
			)

			conflicts=$(dpkg-deb --fsys-tarfile "$deb" | tar -t | sed -E 's|^\./||' |
				awk '
					NR==FNR { want[$0]; next }
					{
						owners = $NF
						path = substr($0, 1, length($0) - length(owners) - 1)
						if (path in want) print path "\t" owners
					}
				' - "Contents-${repo}-${arch}" |
				while IFS=$'\t' read -r path owners; do
					IFS=',' read -r -a owner_list <<< "$owners"
					for owner in "${owner_list[@]}"; do
						[[ "$owner" == "$pkg_name" ]] && continue
						termux_pkg_relations_match "$declared" "$owner" "$deb_version" && continue
						owner_declared=$(awk -v pkg="$owner" '
							$0 == "Package: " pkg { found=1 }
							found && /^(Conflicts|Replaces|Breaks):/ { print }
							found && /^$/ { found=0 }
						' "Packages-${repo}-${arch}" |
							sed -E 's/^(Conflicts|Replaces|Breaks): *//' | tr ',' '\n' | sed '/^[[:space:]]*$/d')
						termux_pkg_relations_match "$owner_declared" "$pkg_name" "$deb_version" && continue
						echo "::error::\"$pkg_name\" and \"$owner\" (${repo}/${arch}) both ship \"$path\", with no Conflicts/Replaces/Breaks declared"
					done
				done)
			if [[ -n "$conflicts" ]]; then
				echo "$conflicts"
				error=1
			fi
		done
	done
done

if [[ "$error" != 0 ]]; then
	echo "::error::Found versions older than published, or conflicting files between built packages, or between built and published packages!%0APlease bump version or add an epoch, revbump package, rebase, add Conflicts/Replaces/Breaks, or tag commit with '%ci:no-build'"
	exit 1
fi
