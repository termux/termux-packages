TERMUX_PKG_HOMEPAGE=https://www.wxwidgets.org/
TERMUX_PKG_DESCRIPTION="A free and open source cross-platform C++ framework for writing advanced GUI applications"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="docs/gpl.txt, docs/lgpl.txt, docs/licence.txt, docs/licendoc.txt, docs/preamble.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/wxWidgets/wxWidgets/releases/download/v${TERMUX_PKG_VERSION}/wxWidgets-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=d7b3666de33aa5c10ea41bb9405c40326e1aeb74ee725bb88f90f1d50270a224
TERMUX_PKG_DEPENDS="glu, gtk3, libcurl, libexpat, libiconv, libjpeg-turbo, liblzma, libnotify, libpng, libsecret, libsm, libtiff, mesa, sdl2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-intl
--disable-option-checking
--disable-xlocale
--with-sdl
wx_cv_func_snprintf_pos_params=yes
"

termux_step_pre_configure() {
	_WX_RELEASE=$(awk '/^WX_RELEASE =/ { print $3 }' "$TERMUX_PKG_SRCDIR"/Makefile.in)
}

termux_step_post_make_install() {
	cp -fr "$TERMUX_PKG_SRCDIR"/include/wx/android \
		$TERMUX_PREFIX/include/wx-${_WX_RELEASE}/wx/android
}
