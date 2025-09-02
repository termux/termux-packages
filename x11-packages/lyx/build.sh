TERMUX_PKG_HOMEPAGE=https://www.lyx.org
TERMUX_PKG_DESCRIPTION="WYSIWYM (What You See Is What You Mean) Document Processor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://ftp.lip6.fr/pub/lyx/stable/${TERMUX_PKG_VERSION:0:3}.x/lyx-${TERMUX_PKG_VERSION/p/-}.tar.xz"
TERMUX_PKG_SHA256=ffacd37480f320f3f3f8f30445fe40897e9df44c94ee87ba0413e364086f4b90
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/\./p/3; s/-/p/'
TERMUX_PKG_DEPENDS="file, ghostscript, hunspell, imagemagick, libandroid-execinfo, libc++, libiconv, libxcb, lyx-data, qt5-qtbase, qt5-qtsvg, qt5-qtx11extras, texlive-bin, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, qt5-qtbase-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-build-type=rel
--without-included-boost
--without-aspell
--with-hunspell
"
TERMUX_PKG_RM_AFTER_INSTALL="share/lyx/examples"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo"

	# This is to allow the build script find the `moc` on cross-build host
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export PATH="${TERMUX_PREFIX}/opt/qt/cross/bin:${PATH}"
	fi
}
