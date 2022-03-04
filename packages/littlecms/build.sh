TERMUX_PKG_HOMEPAGE=http://www.littlecms.com/
TERMUX_PKG_DESCRIPTION="Color management library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_SOVERSION=2
TERMUX_PKG_VERSION=2.13.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mm2/Little-CMS/archive/refs/tags/lcms${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6f84c942ecde1b4852b5a051894502ac8c98d010acb3400dec958c6db1bc94ef
TERMUX_PKG_BREAKS="littlecms-dev"
TERMUX_PKG_REPLACES="littlecms-dev"

termux_step_post_make_install() {
	ln -sf liblcms2.so $TERMUX_PREFIX/lib/liblcms2.so.${_SOVERSION}
}
