TERMUX_PKG_HOMEPAGE=https://pardus.org.tr/en/projects/pardus-applications
TERMUX_PKG_DESCRIPTION="Screen Drawing Tool"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.0"
TERMUX_PKG_SRCURL="https://github.com/pardus/pardus-pen/archive/refs/tags/debian/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=87f41146aa170f38304836d6647f2dedd455891c05fb201b6b44b9fab7b40a75
TERMUX_PKG_DEPENDS="qt6-qtbase, qt6-qtsvg, poppler-qt, libarchive"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--prefix=${TERMUX__PREFIX}
-Dbackgrounds=${TERMUX__PREFIX__SHARE_DIR}/pardus/pardus-pen/backgrounds
"

termux_step_pre_configure() {
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == true ]]; then
		export PATH="${TERMUX__PREFIX__BASE_LIB_DIR}/qt6:${PATH}"
	else
		export PATH="${TERMUX__PREFIX__OPT_DIR}/qt6/cross/lib/qt6:${PATH}"
	fi
}
