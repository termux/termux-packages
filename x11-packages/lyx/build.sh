TERMUX_PKG_HOMEPAGE=http://www.lyx.org
TERMUX_PKG_DESCRIPTION="WYSIWYM (What You See Is What You Mean) Document Processor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
_VERSION=2.3.7-1
TERMUX_PKG_VERSION=${_VERSION/-/p}
TERMUX_PKG_SRCURL="https://ftp.lip6.fr/pub/lyx/stable/$(echo $_VERSION | cut -d . -f 1-2).x/lyx-${_VERSION}.tar.xz"
TERMUX_PKG_SHA256=39be8864fb86b34e88310e70fb80e5e9e296601f0856cf161aa094171718d8ed
TERMUX_PKG_DEPENDS="ghostscript, hunspell, imagemagick, libandroid-execinfo, libc++, libxcb, lyx-data, qt5-qtbase, qt5-qtsvg, qt5-qtx11extras, texlive-bin, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, qt5-qtbase-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-build-type=rel
--enable-qt5
--without-included-boost
--without-aspell
--with-hunspell
"
TERMUX_PKG_RM_AFTER_INSTALL="share/lyx/examples"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo"

	# This is to allow the build script find the `moc` on cross-build host
	export PATH+=":${TERMUX_PREFIX}/opt/qt/cross/bin"
}
