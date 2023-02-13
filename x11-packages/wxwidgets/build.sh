TERMUX_PKG_HOMEPAGE=https://www.wxwidgets.org/
TERMUX_PKG_DESCRIPTION="A free and open source cross-platform C++ framework for writing advanced GUI applications"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="docs/gpl.txt, docs/lgpl.txt, docs/licence.txt, docs/licendoc.txt, docs/preamble.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.2
TERMUX_PKG_SRCURL=https://github.com/wxWidgets/wxWidgets/releases/download/v${TERMUX_PKG_VERSION}/wxWidgets-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8edf18672b7bc0996ee6b7caa2bee017a9be604aad1ee471e243df7471f5db5d
TERMUX_PKG_DEPENDS="fontconfig, gdk-pixbuf, glib, glu, gtk3, libandroid-execinfo, libc++, libcairo, libcurl, libexpat, libiconv, libjpeg-turbo, libnotify, libpng, libsecret, libsm, libtiff, libx11, libxtst, libxxf86vm, opengl, pango, pcre2, sdl2, webkit2gtk-4.1, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-option-checking
--disable-mediactrl
--enable-webview
--with-sdl
ac_cv_header_langinfo_h=no
wx_cv_func_snprintf_pos_params=yes
"

termux_step_pre_configure() {
	sed -i 's/\(webkit2gtk-4\.\)0/\11/g' configure

	_WX_RELEASE=$(awk '/^WX_RELEASE =/ { print $3 }' "$TERMUX_PKG_SRCDIR"/Makefile.in)
}

termux_step_post_make_install() {
	cp -fr "$TERMUX_PKG_SRCDIR"/include/wx/android \
		$TERMUX_PREFIX/include/wx-${_WX_RELEASE}/wx/android
}
