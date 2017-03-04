TERMUX_PKG_HOMEPAGE=http://www.pango.org/
TERMUX_PKG_DESCRIPTION="Library for laying out and rendering text"
_MAJOR_VERSION=1.40
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/pango/${_MAJOR_VERSION}/pango-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=90582a02bc89318d205814fc097f2e9dd164d26da5f27c53ea42d583b34c3cd1
TERMUX_PKG_DEPENDS="fontconfig,glib,harfbuzz,libcairo"
