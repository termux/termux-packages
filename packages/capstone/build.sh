TERMUX_PKG_HOMEPAGE=https://www.capstone-engine.org/
TERMUX_PKG_DESCRIPTION="Lightweight multi-platform, multi-architecture disassembly framework"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.0.7"
TERMUX_PKG_SRCURL="https://github.com/capstone-engine/capstone/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6427a724726d161d1e05fb49fff8cd0064f67836c04ffca3c11d6d859e719caa
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+(?!-)"
TERMUX_PKG_BREAKS="capstone-dev"
TERMUX_PKG_REPLACES="capstone-dev"

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
