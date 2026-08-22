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

			# Check that this exact .deb filename isn't already published (missed revbump).
			if grep -q "^Filename:.*/$(basename "$deb")\$" "Packages-${repo}-${arch}"; then
				echo "[!] \"$(basename "$deb")\" (${repo}/${arch}) already exists on the server"
				error=1
			fi

			# Check that this .deb doesn't ship a file already owned by a different
			# published package, unless a Conflicts/Replaces/Breaks relation is declared.
			declared=$(
				{ dpkg-deb -f "$deb" Conflicts; dpkg-deb -f "$deb" Replaces; dpkg-deb -f "$deb" Breaks; } |
					tr ',' '\n' | sed -E 's/\(.*\)//; s/^[[:space:]]+//; s/[[:space:]]+$//' | sed '/^$/d'
			)

			conflicts=$(dpkg-deb -c "$deb" | awk '{print $6}' | sed -E 's|^\./||' |
				awk 'NR==FNR{want[$0];next} $1 in want' - "Contents-${repo}-${arch}" |
				while read -r path owners; do
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
