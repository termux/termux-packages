TERMUX_PKG_HOMEPAGE=https://www.capstone-engine.org/
TERMUX_PKG_DESCRIPTION="Lightweight multi-platform, multi-architecture disassembly framework"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.0.5"
TERMUX_PKG_SRCURL=https://github.com/capstone-engine/capstone/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3bfd3e7085fbf0fab75fb1454067bf734bb0bebe9b670af7ce775192209348e9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="capstone-dev"
TERMUX_PKG_REPLACES="capstone-dev"

termux_pkg_auto_update() {
	local latest_version
	latest_version="$(termux_github_api_get_tag "$TERMUX_PKG_SRCURL")"

	if [[ -z "$latest_version" ]]; then
		termux_error_exit "ERROR: Failed to get latest version."
	fi

	if [[ "$latest_version" =~ ^[0-9]+(\.[0-9]+)+$ ]]; then
		termux_pkg_upgrade_version "$latest_version"
	else
		echo "WARN: Found non-stable version ($latest_version) marked as latest release. Skipping..."
		return
	fi
}

termux_step_post_get_source() {
	termux_setup_cmake

	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=5

	local v=$(sed -En 's/.*VERSION_MAJOR.*[ |=]([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ -z "${v}" ]; then
		local tmpdir=$(mktemp -d)
		cmake -S "${TERMUX_PKG_SRCDIR}" -B "${tmpdir}"
		v=$(sed -En 's/.*VERSION_MAJOR.*[ |=]([0-9]+).*/\1/p' \
			"${tmpdir}/CMakeCache.txt")
		rm -fr "${tmpdir}"
	fi
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "
		SOVERSION guard check failed!
		SOVERSION guard    = ${_SOVERSION}
		SOVERSION computed = ${v}
		"
	fi
}

termux_step_post_make_install() {
	# build system can only build static or shared at a time
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	-DBUILD_SHARED_LIBS=ON
	"
	termux_step_configure
	termux_step_make
	termux_step_make_install
}
