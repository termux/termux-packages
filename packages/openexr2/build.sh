TERMUX_PKG_HOMEPAGE=https://www.openexr.com/
TERMUX_PKG_DESCRIPTION="Provides the specification and reference implementation of the EXR file format"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.5.8
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=db261a7fcc046ec6634e4c5696a2fc2ce8b55f50aac6abe034308f54c8495f55
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTING=OFF
-DPYILMBASE_ENABLE=OFF
"

termux_step_pre_configure() {
	case "$TERMUX_PKG_VERSION" in
		2.*|*:2.* ) ;;
		* ) termux_error_exit "Invalid version '$TERMUX_PKG_VERSION' for package '$TERMUX_PKG_NAME'." ;;
	esac
}
