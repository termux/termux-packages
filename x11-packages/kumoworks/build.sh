TERMUX_PKG_HOMEPAGE=https://github.com/opentoonz/kumoworks
TERMUX_PKG_DESCRIPTION="Cloud rendering software for animation production"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="../LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.1"
TERMUX_PKG_SRCURL="https://github.com/opentoonz/kumoworks/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d854ef28e2d0bb1e936f733ba66c0d7cbe523768d0bb7171eb689f1d954b77a3
TERMUX_PKG_DEPENDS="libc++, qt5-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_pre_configure() {
	termux_setup_cmake
	TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/sources"
}
