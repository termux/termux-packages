#!/bin/bash
set -euo pipefail

# Checks DEBS_DIR (default ./debs) for file conflicts between built packages,
# and against published repos for filename collisions or undeclared file conflicts.
# If BY_ARCH_DIR (optional) is given, also checks that platform independent packages
# are identical on all architectures.

DEBS_DIR="$(realpath -m "${1:-debs}")"
BY_ARCH_DIR="${2:+$(realpath -m "$2")}"

cd "$(realpath "$(dirname "$0")")/../.."

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
if [[ -n "$BY_ARCH_DIR" ]]; then
	mkdir -p "$DEBS_DIR"
	for deb in "$BY_ARCH_DIR"/*/debs/*.deb; do
		ln -sf "$deb" "$DEBS_DIR"/
	done
fi
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

termux_deb_fingerprint() {
	local deb="$1" out="$2"
	mkdir -p "$out/data" "$out/control"
	dpkg-deb --fsys-tarfile "$deb" | tar -x --no-same-owner --delay-directory-restore -C "$out/data"
	dpkg-deb -e "$deb" "$out/control"
	{
		echo "## data"
		dpkg-deb --fsys-tarfile "$deb" | tar -tv --numeric-owner | awk '{ $4 = ""; $5 = ""; print }' | LC_ALL=C sort
		(cd "$out/data" && find . -type f -print0 | LC_ALL=C sort -z | xargs -0 -r sha256sum)
		echo "## control"
		(cd "$out/control" && find . -type f -print0 | LC_ALL=C sort -z | xargs -0 -r sha256sum)
	} > "$out/manifest"
	chmod -R u+rwX "$out" || true
	rm -rf "$out/data" "$out/control"
}

termux_package_skips_platform_independent_check() {
	local package="$1" dir script
	for dir in packages root-packages x11-packages; do
		script="$dir/$package/build.sh"
		if [[ ! -f "$script" ]]; then
			script="$(compgen -G "$dir/*/$package.subpackage.sh" | head -n 1 || true)"
			[[ -n "$script" ]] && script="$(dirname "$script")/build.sh"
		fi
		if [[ -f "$script" ]]; then
			grep -qE '^TERMUX_PKG_SKIP_PLATFORM_INDEPENDENT_CHECK=("true"|true)$' "$script"
			return
		fi
	done
	# Virtual -static subpackages have no *.subpackage.sh, use the parent's build.sh.
	if [[ "$package" == *-static ]]; then
		termux_package_skips_platform_independent_check "${package%-static}"
		return
	fi
	return 1
}

# Checks that platform independent (*_all.deb) packages have identical contents,
# ignoring modification times, on every architecture they were built for.
# Packages with TERMUX_PKG_SKIP_PLATFORM_INDEPENDENT_CHECK=true in build.sh are skipped.
# BY_ARCH_DIR holds one directory per architecture, each with a debs/ directory.
termux_check_platform_independent() {
	local by_arch_dir="$1" work_dir arch_dir arch deb name reference
	local -A first_arch=() skipped=()

	work_dir="$(mktemp -d)"
	shopt -s nullglob
	for arch_dir in "$by_arch_dir"/*/; do
		arch="$(basename "$arch_dir")"
		for deb in "$arch_dir"debs/*_all.deb; do
			name="$(basename "$deb")"
			if [[ -z "${skipped[$name]:-}" ]]; then
				skipped[$name]=no
				if termux_package_skips_platform_independent_check "$(dpkg-deb -f "$deb" Package)"; then
					skipped[$name]=yes
				fi
			fi
			[[ "${skipped[$name]}" == yes ]] && continue
			termux_deb_fingerprint "$deb" "$work_dir/$arch/$name"
			if [[ -z "${first_arch[$name]:-}" ]]; then
				first_arch[$name]="$arch"
				continue
			fi
			reference="${first_arch[$name]}"
			if ! cmp -s "$work_dir/$reference/$name/manifest" "$work_dir/$arch/$name/manifest"; then
				echo "::error::\"$name\" differs between ${reference} and ${arch} although it is platform independent"
				diff -u "$work_dir/$reference/$name/manifest" "$work_dir/$arch/$name/manifest" | head -n 20 || true
				error=1
			fi
		done
	done
	shopt -u nullglob
	rm -rf "$work_dir"
}

# Stage 1: Check for file conflicts between the newly built packages themselves.
declare -a deb_arches deb_names deb_versions deb_relations
local_contents=$(mktemp)
trap 'rm -f "$local_contents"' EXIT

: > "$local_contents"
for i in "${!debs[@]}"; do
	deb=${debs[i]}
	deb_arches[i]=$(dpkg_deb_field "$deb" Architecture)
	deb_names[i]=$(dpkg_deb_field "$deb" Package)
	deb_versions[i]=$(dpkg_deb_field "$deb" Version)
	deb_relations[i]=$(
		{ dpkg_deb_field "$deb" Conflicts; dpkg_deb_field "$deb" Replaces; dpkg_deb_field "$deb" Breaks; } |
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
			deb_version=$(dpkg_deb_field "$deb" Version)

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
				{ dpkg_deb_field "$deb" Conflicts; dpkg_deb_field "$deb" Replaces; dpkg_deb_field "$deb" Breaks; } |
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

# Stage 3: Check that platform independent packages are identical on all architectures.
if [[ -n "$BY_ARCH_DIR" ]]; then
	termux_check_platform_independent "$BY_ARCH_DIR"
fi

if [[ "$error" != 0 ]]; then
	printf '::error::%s%%0A%s\n' \
		"Found versions older than published, or conflicting files between built packages, or between built and published packages, or platform independent packages that differ between architectures!" \
		"Please bump version or add an epoch, revbump package, rebase, add Conflicts/Replaces/Breaks, fix the package to be really platform independent, or tag commit with '%ci:no-build'"
	exit 1
fi
