TERMUX_PKG_HOMEPAGE=https://gitlab.com/azelpg/azpainter
TERMUX_PKG_DESCRIPTION="Full color painting software for Unix-like systems for illustration drawing"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:3.0.5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL=https://gitlab.com/azelpg/azpainter/-/archive/v${TERMUX_PKG_VERSION:2}/azpainter-${TERMUX_PKG_VERSION:2}.tar.bz2
TERMUX_PKG_SHA256=e40f2d0fc104d7097097cf38b50852587d0031cc9ecefff03d0ee8cbefaee399
TERMUX_PKG_DEPENDS="libandroid-shmem, iconv, fontconfig, freetype, hicolor-icon-theme, libxfixes, libxi, libxcursor, libpng, libjpeg-turbo, libtiff, libwebp"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="
share/icons/hicolor/icon-theme.cache
share/mime/XMLnamespaces
share/mime/aliases
share/mime/generic-icons
share/mime/globs
share/mime/globs2
share/mime/icons
share/mime/magic
share/mime/mime.cache
share/mime/subclasses
share/mime/treemagic
share/mime/types
share/mime/version
"

termux_step_configure() {
	termux_setup_ninja
	./configure --prefix="$TERMUX_PREFIX" \
		CC="$CC" \
		CFLAGS="$CPPFLAGS $CFLAGS" \
		LDFLAGS="$LDFLAGS" \
		LIBS="-liconv -landroid-shmem"
}

termux_step_make() {
	cd build
	ninja
}

termux_step_make_install() {
	cd build
	ninja install
}
