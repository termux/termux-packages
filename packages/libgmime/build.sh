TERMUX_PKG_HOMEPAGE=http://spruce.sourceforge.net/gmime/
TERMUX_PKG_DESCRIPTION="MIME message parser and creator"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.2.5
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gmime/${TERMUX_PKG_VERSION:0:3}/gmime-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=fb7556501f85c3bf3e65fdd82697cbc4fa4b55dccd33ad14239ce0197e78ba59
TERMUX_PKG_DEPENDS="glib, libffi, libiconv, libidn2, zlib"
TERMUX_PKG_BREAKS="libgmime-dev"
TERMUX_PKG_REPLACES="libgmime-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_have_iconv_detect_h=yes
--with-libiconv=gnu
--disable-glibtest
--disable-crypto
"
