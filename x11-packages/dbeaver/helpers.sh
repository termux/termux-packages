# shellcheck shell=bash

__dbeaver_swt_version_from_product() {
	local product_dir="$1"
	local frag
	frag="$(find "$product_dir/plugins" -maxdepth 1 -name "org.eclipse.swt.gtk.linux.${_SWT_ARCH}_*" | head -n 1)"
	[ -n "$frag" ] || termux_error_exit "SWT fragment for linux/gtk/${_SWT_ARCH} not found in product"

	if [ -d "$frag" ]; then
		find "$frag" -maxdepth 1 -name 'libswt-gtk-*.so' -printf '%f\n'
	else
		unzip -Z1 "$frag" | grep -E '^libswt-gtk-[0-9]+r[0-9]+\.so$' || true
	fi | head -n 1 | sed -E 's/^libswt-gtk-(.*)\.so$/\1/'
}

__dbeaver_find_product_dir() {
	find "$TERMUX_PKG_SRCDIR/product/community/target/products" \
		-type d -path "*/linux/gtk/${_SWT_ARCH}/dbeaver" | head -n 1
}

__dbeaver_resolve_source_pins() {
	local version="$1"
	local common_repo="https://github.com/dbeaver/dbeaver-common"
	local datadam_repo="https://github.com/dbeaver/datadam-api"
	local swt_repo="https://github.com/eclipse-platform/eclipse.platform.swt"
	local raw="https://raw.githubusercontent.com/dbeaver"
	local branch="release_${version//./_}"

	# Pinned by hash, branch tarballs are not stable.
	_NEW_COMMON_COMMIT="$(git ls-remote --heads "${common_repo}.git" "refs/heads/${branch}" | cut -f1)"
	[[ -n "${_NEW_COMMON_COMMIT}" ]] ||
		termux_error_exit "Branch ${branch} not found in dbeaver-common"

	local parent_version common_version
	parent_version="$(curl -fsSL "${raw}/dbeaver/${version}/pom.xml" |
		sed -n '/<parent>/,/<\/parent>/ s#.*<version>\(.*\)</version>.*#\1#p' | head -n 1)"
	common_version="$(curl -fsSL "${raw}/dbeaver-common/${_NEW_COMMON_COMMIT}/pom.xml" |
		sed -n 's#^    <version>\(.*\)</version>.*#\1#p' | head -n 1)"
	[[ -n "${parent_version}" ]] ||
		termux_error_exit "Could not read the parent POM version of dbeaver ${version}"
	[[ "${parent_version}" == "${common_version}" ]] ||
		termux_error_exit "dbeaver ${version} needs dbeaver-common ${parent_version}, but ${branch} is '${common_version}'"

	# datadam-api uses the same release_X_Y_Z branch convention and pins its
	# own parent POM version to the matching dbeaver-common release.
	_NEW_DATADAM_COMMIT="$(git ls-remote --heads "${datadam_repo}.git" "refs/heads/${branch}" | cut -f1)"
	[[ -n "${_NEW_DATADAM_COMMIT}" ]] ||
		termux_error_exit "Branch ${branch} not found in datadam-api"

	local datadam_parent_version
	datadam_parent_version="$(curl -fsSL "${raw}/datadam-api/${_NEW_DATADAM_COMMIT}/apis/pom.xml" |
		sed -n '/<parent>/,/<\/parent>/ s#.*<version>\(.*\)</version>.*#\1#p' | head -n 1)"
	[[ -n "${datadam_parent_version}" ]] ||
		termux_error_exit "Could not read the parent POM version of datadam-api ${branch}"
	[[ "${datadam_parent_version}" == "${common_version}" ]] ||
		termux_error_exit "datadam-api ${branch} needs dbeaver-common ${datadam_parent_version}, but ${branch} is '${common_version}'"

	# 2026-06 -> Eclipse 4.40 -> R4_40 (one minor version per quarter, 2024-06 is 4.32).
	local eclipse_version
	eclipse_version="$(curl -fsSL "${raw}/dbeaver-common/${_NEW_COMMON_COMMIT}/root/pom.xml" |
		sed -n 's#.*<eclipse-version>\(.*\)</eclipse-version>.*#\1#p' | head -n 1)"
	[[ "${eclipse_version}" =~ ^([0-9]{4})-(03|06|09|12)$ ]] ||
		termux_error_exit "Unexpected eclipse-version '${eclipse_version}' in dbeaver-common"
	_NEW_SWT_TAG="R4_$((32 + (BASH_REMATCH[1] - 2024) * 4 + (10#${BASH_REMATCH[2]} - 6) / 3))"
	git ls-remote --exit-code --tags "${swt_repo}.git" "refs/tags/${_NEW_SWT_TAG}" >/dev/null ||
		termux_error_exit "SWT tag ${_NEW_SWT_TAG} not found (Eclipse ${eclipse_version} not released yet?)"
}
