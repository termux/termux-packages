TERMUX_PKG_HOMEPAGE=https://github.com/jstedfast/gmime
TERMUX_PKG_DESCRIPTION="A C/C++ MIME creation and parser library with support for S/MIME, PGP, and Unix mbox spools"
TERMUX_PKG_VERSION=2.6.23
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/gnome/sources/gmime/2.6/gmime-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7149686a71ca42a1390869b6074815106b061aaeaaa8f2ef8c12c191d9a79f6a
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="glib-dev, pkg-config"
