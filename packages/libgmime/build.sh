TERMUX_PKG_HOMEPAGE=http://spruce.sourceforge.net/gmime/
TERMUX_PKG_DESCRIPTION="MIME message parser and creator"
local _MAJOR_VERSION=3.0
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SHA256=c28459ea86107e3a04ad06081f0b2b96b57f0774db44bae7a72ae18ad6483e00
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gmime/$_MAJOR_VERSION/gmime-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="glib, libidn"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_have_iconv_detect_h=yes
--disable-glibtest
"
