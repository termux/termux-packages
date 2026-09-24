#!/bin/bash
set -euo pipefail

# Checks DEBS_DIR (default ./debs) against a published repo for filename
# collisions or file conflicts lacking a declared Conflicts/Replaces/Breaks.

cd "$(realpath "$(dirname "$0")")/../.."

DEBS_DIR="${1:-debs}"

shopt -s nullglob
debs=("${DEBS_DIR}"/*.deb)
shopt -u nullglob
[[ ${#debs[@]} -eq 0 ]] && exit 0

error=0
download_jobs=()
download_file() {
	if ! curl --fail --silent --show-error --retry 5 --retry-all-errors --user-agent 'Termux-Packages/1.0\ (https://github.com/termux/termux-packages)' "$1" -o "$2"; then
		echo "ERROR: Failed to download $1" >&2
		return 1
	fi
}

filter_dpkg_deb_warnings() {
	sed -E '
/^dpkg-deb: warning: parsing file '\''\/tmp\/dpkg-deb\.[[:alnum:]]+\/control'\'' near line 2 package '\''[^'\'']+:x86_64'\'':$/ {
	N
	/^dpkg-deb: warning: parsing file '\''\/tmp\/dpkg-deb\.[[:alnum:]]+\/control'\'' near line 2 package '\''[^'\'']+:x86_64'\'':\n '\''x86_64'\'' is not a valid architecture name in '\''Architecture'\'' field: character '\''_'\'' not allowed \(only letters, digits and characters '\''-'\''\)$/d
}
'
}

dpkg_deb_field() {
	dpkg-deb -f "$1" "$2" 2> >(filter_dpkg_deb_warnings >&2)
}

download_metadata() (
	local repo=$1 distribution=$2 component=$3 url=$4 arch=$5

	if [[ ! -f "Packages-${repo}-${arch}" ]]; then
		echo "[*] Downloading ${url}/dists/${distribution}/${component}/binary-${arch}/Packages.bz2"
		download_file "${url}/dists/${distribution}/${component}/binary-${arch}/Packages.bz2" "Packages-${repo}-${arch}.bz2"
		7z x "Packages-${repo}-${arch}.bz2" > /dev/null
	fi
	if [[ ! -f "Contents-${repo}-${arch}" ]]; then
		echo "[*] Downloading ${url}/dists/${distribution}/Contents-${arch}.gz"
		download_file "${url}/dists/${distribution}/Contents-${arch}.gz" "Contents-${repo}-${arch}.gz"
		gunzip -k "Contents-${repo}-${arch}.gz"
	fi
)

for repo in $(jq --raw-output 'del(.pkg_format) | keys | .[]' repo.json); do
	distribution=$(jq --raw-output '.["'"${repo}"'"].distribution' repo.json)
	component=$(jq --raw-output '.["'"${repo}"'"].component' repo.json)
	url=$(jq --raw-output '.["'"${repo}"'"].url' repo.json)

	for arch in aarch64 arm i686 x86_64; do
		download_metadata "$repo" "$distribution" "$component" "$url" "$arch" &
		download_jobs+=("$!")
		if (( ${#download_jobs[@]} >= 4 )); then
			wait "${download_jobs[0]}"
			download_jobs=("${download_jobs[@]:1}")
		fi
	done
done

for job in "${download_jobs[@]}"; do
	wait "$job"
done

for repo in $(jq --raw-output 'del(.pkg_format) | keys | .[]' repo.json); do
	distribution=$(jq --raw-output '.["'"${repo}"'"].distribution' repo.json)
	component=$(jq --raw-output '.["'"${repo}"'"].component' repo.json)
	url=$(jq --raw-output '.["'"${repo}"'"].url' repo.json)

	for arch in aarch64 arm i686 x86_64; do
		for deb in "${debs[@]}"; do
			deb_arch=$(dpkg_deb_field "$deb" Architecture)
			[[ "$deb_arch" == "$arch" || "$deb_arch" == "all" ]] || continue
			pkg_name=$(dpkg_deb_field "$deb" Package)

			# Check that this exact .deb filename isn't already published (missed revbump).
			deb_name_escaped=$(printf '%s' "$(basename "$deb")" | sed 's/[.[\*^$]/\\&/g')
			if grep -q "^Filename:.*/${deb_name_escaped}\$" "Packages-${repo}-${arch}"; then
				echo "[!] \"$(basename "$deb")\" (${repo}/${arch}) already exists on the server"
				error=1
			fi

			# Check that this .deb doesn't ship a file already owned by a different
			# published package, unless a Conflicts/Replaces/Breaks relation is declared.
			declared=$(
				{ dpkg_deb_field "$deb" Conflicts; dpkg_deb_field "$deb" Replaces; dpkg_deb_field "$deb" Breaks; } |
					tr ',' '\n' | sed -E 's/\(.*\)//; s/^[[:space:]]+//; s/[[:space:]]+$//' | sed '/^$/d'
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
						grep -qx "$owner" <<< "$declared" && continue
						owner_declared=$(awk -v pkg="$owner" '
							$0 == "Package: " pkg { found=1 }
							found && /^(Conflicts|Replaces|Breaks):/ { print }
							found && /^$/ { found=0 }
						' "Packages-${repo}-${arch}" |
							sed -E 's/^(Conflicts|Replaces|Breaks): *//' | tr ',' '\n' |
							sed -E 's/\(.*\)//; s/^[[:space:]]+//; s/[[:space:]]+$//')
						grep -qx "$pkg_name" <<< "$owner_declared" && continue
						echo "[!] \"$pkg_name\" and \"$owner\" (${repo}/${arch}) both ship \"$path\", with no Conflicts/Replaces/Breaks declared"
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
	echo "[!] Found local files same name with server files, or undeclared file conflicts with published packages!"
	echo "[!] Please revbump package, rebase, add Conflicts/Replaces/Breaks, or tag commit with '%ci:no-build'"
	exit 1
fi
