TERMUX_PKG_HOMEPAGE="https://www.ode.org"
TERMUX_PKG_DESCRIPTION="An open source, high performance library for simulating rigid body dynamics"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause, LGPL-2.1"
TERMUX_PKG_MAINTAINER="Pooya Moradi <pvonmoradi@gmail.com>"
TERMUX_PKG_VERSION="0.16.2"
TERMUX_PKG_SRCURL="https://bitbucket.org/odedevs/ode/downloads/ode-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=b26aebdcb015e2d89720ef48e0cb2e8a3ca77915f89d853893e7cc861f810f22
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_DEPENDS="libccd"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS='
-DBUILD_SHARED_LIBS=ON
-DODE_WITH_DEMOS=OFF
-DODE_WITH_TESTS=OFF
-DODE_WITH_LIBCCD=ON
-DODE_WITH_LIBCCD_SYSTEM=ON
'

termux_step_pre_configure() {
	# Use double-precision for 64-bit archs, otherwise use single-precision
	case "$TERMUX_ARCH" in
		"aarch64" |  "x86_64")
			TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=' -DODE_DOUBLE_PRECISION=ON'
			;;
		"arm" | "i686")
			TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=' -DODE_DOUBLE_PRECISION=OFF'
			;;
		*)
			TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=' -DODE_DOUBLE_PRECISION=OFF'
			;;
	esac
}
