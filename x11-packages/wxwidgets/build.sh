TERMUX_PKG_HOMEPAGE=https://www.wxwidgets.org/
TERMUX_PKG_DESCRIPTION="A free and open source cross-platform C++ framework for writing advanced GUI applications"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="docs/gpl.txt, docs/lgpl.txt, docs/licence.txt, docs/licendoc.txt, docs/preamble.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.3.1"
TERMUX_PKG_SRCURL=https://github.com/wxWidgets/wxWidgets/releases/download/v${TERMUX_PKG_VERSION}/wxWidgets-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f936c8d694f9c49a367a376f99c751467150a4ed7cbf8f4723ef19b2d2d9998d
TERMUX_PKG_DEPENDS="fontconfig, gdk-pixbuf, glib, glu, gtk3, libandroid-execinfo, libc++, libcairo, libcurl, libexpat, libiconv, libjpeg-turbo, libnotify, libpng, libsecret, libsm, libtiff, libx11, libxtst, libxxf86vm, opengl, pango, pcre2, sdl2 | sdl2-compat, webkit2gtk-4.1, zlib"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DwxUSE_MEDIACTRL=OFF
-DwxUSE_WEBVIEW=ON
-DwxUSE_LIBSDL=ON
-DwxUSE_WEBVIEW=ON
-DwxUSE_WEBVIEW_WEBKIT=ON
-DwxUSE_WEBVIEW_WEBKIT2=OFF
-DwxBUILD_TESTS=OFF
"

termux_step_pre_configure() {
	_WX_RELEASE=$(awk '/^WX_RELEASE =/ { print $3 }' "$TERMUX_PKG_SRCDIR"/Makefile.in)

	# https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=273753:
	# "Add -Wl,--undefined-version to LDFLAGS to suppress these errors, since
	# wxWidgets reuses the same linker version script for all its shared
	# libraries"
	LDFLAGS+=" -Wl,--undefined-version -landroid-execinfo"

	sed -i 's/find_package(WEBKIT2 4.0)/find_package(WEBKIT2 4.1)/' build/cmake/init.cmake
}

termux_step_post_make_install() {
	cp -fr "$TERMUX_PKG_SRCDIR"/include/wx/android \
		$TERMUX_PREFIX/include/wx-${_WX_RELEASE}/wx/android
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libwx_baseu-3.3.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
