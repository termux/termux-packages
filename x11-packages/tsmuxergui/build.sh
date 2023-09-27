TERMUX_PKG_HOMEPAGE=https://github.com/justdan96/tsMuxer
TERMUX_PKG_DESCRIPTION="A transport stream muxer for remuxing/muxing elementary streams"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Update both tsmuxer and tsmuxergui to the same version in one PR.
_VERSION_REAL=nightly-2023-01-30-02-16-12
TERMUX_PKG_VERSION=$(cut -d- -f2,3,4 <<< "$_VERSION_REAL" | tr '-' '.')
TERMUX_PKG_SRCURL=https://github.com/justdan96/tsMuxer/archive/refs/tags/${_VERSION_REAL}.tar.gz
TERMUX_PKG_SHA256=e975d7ab9a73448b1c2c1ded311977a6f0dc77398edb720158dbcf213d9cf4df
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, qt5-qtmultimedia"
TERMUX_PKG_BUILD_DEPENDS="freetype, qt5-qtbase-cross-tools, qt5-qttools-cross-tools, zlib"
TERMUX_PKG_RM_AFTER_INSTALL="bin/tsmuxer"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_INSTALL_DATADIR=share -DTSMUXER_GUI=ON"

termux_step_post_get_source() {
	# Version guard
	local ver_t=$(. $TERMUX_SCRIPTDIR/packages/tsmuxer/build.sh; echo ${TERMUX_PKG_VERSION#*:})
	local ver_g=${TERMUX_PKG_VERSION#*:}
	if [ "${ver_t}" != "${ver_g}" ]; then
		termux_error_exit "Version mismatch between tsmuxer and tsmuxergui."
	fi
}

termux_step_post_make_install() {
	mv ${TERMUX_PREFIX}/bin/tsMuxerGUI ${TERMUX_PREFIX}/bin/tsmuxergui
}
