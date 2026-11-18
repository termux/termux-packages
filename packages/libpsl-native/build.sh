TERMUX_PKG_HOMEPAGE=https://github.com/PowerShell/PowerShell-Native
TERMUX_PKG_DESCRIPTION="This library provides functionality missing from .NET Core via system calls"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="700.0.1"
TERMUX_PKG_SRCURL=https://github.com/PowerShell/PowerShell-Native/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=816bf0e3ae991e41cf69a4871480eec49c7fe1339cf590fa521f51ed82cc7eaa
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="googletest"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
# Only consumed by powershell, which has no 32-bit .NET runtime support
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja

	export OLD_TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}"
	TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/src/libpsl-native"
}

termux_step_make_install() {
	TERMUX_PKG_SRCDIR="${OLD_TERMUX_PKG_SRCDIR}"
	install -v -Dm644 -t "${TERMUX_PREFIX}/lib" \
		"${TERMUX_PKG_SRCDIR}/src/powershell-unix/libpsl-native.so"
	install -v -Dm755 -t "${TERMUX_PREFIX}/bin" \
		test/psl-native-test
	unset OLD_TERMUX_PKG_SRCDIR
}
