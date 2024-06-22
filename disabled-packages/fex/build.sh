TERMUX_PKG_HOMEPAGE=https://fex-emu.com/
TERMUX_PKG_DESCRIPTION="Fast x86 emulation frontend"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2404
TERMUX_PKG_SRCURL=git+https://github.com/FEX-Emu/FEX
TERMUX_PKG_GIT_BRANCH=FEX-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++"
TERMUX_PKG_BUILD_DEPENDS="gdb"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686, x86_64"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTS=OFF
-DBUILD_FEXCONFIG=OFF
-DENABLE_ASSERTIONS=ON
-DENABLE_GDB_SYMBOLS=ON
-DENABLE_JEMALLOC=OFF
-DENABLE_JEMALLOC_GLIBC_ALLOC=OFF
-DENABLE_LTO=OFF
-DENABLE_OFFLINE_TELEMETRY=OFF
-DHAS_CLANG_PRESERVE_ALL=OFF
-DTUNE_ARCH=armv8-a
-DTUNE_CPU=generic
"

termux_pkg_auto_update() {
	local latest_tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}")"
	[[ -z "${latest_tag}" ]] && termux_error_exit "ERROR: Unable to get tag from ${TERMUX_PKG_SRCURL}"
	termux_pkg_upgrade_version "${latest_tag#FEX-}"
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-shmem"
	find "${TERMUX_PKG_SRCDIR}" -name '*.h' -o -name '*.c' -o -name '*.cpp' | \
		xargs -P"${TERMUX_PKG_MAKE_PROCESSES}" -n1 \
		sed \
			-e 's:"/data/local/tmp:"'${TERMUX_PREFIX}'/tmp:g' \
			-e 's:"/tmp:"'${TERMUX_PREFIX}'/tmp:g' \
			-i
}
