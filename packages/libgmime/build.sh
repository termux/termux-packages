TERMUX_PKG_HOMEPAGE=http://spruce.sourceforge.net/gmime/
TERMUX_PKG_DESCRIPTION="MIME message parser and creator"
local _MAJOR_VERSION=2.6
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.23
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gmime/$_MAJOR_VERSION/gmime-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7149686a71ca42a1390869b6074815106b061aaeaaa8f2ef8c12c191d9a79f6a
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_have_iconv_detect_h=yes
--disable-glibtest
"
