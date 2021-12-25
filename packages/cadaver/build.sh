TERMUX_PKG_HOMEPAGE=http://webdav.org/cadaver/
TERMUX_PKG_DESCRIPTION="A command-line WebDAV client for Unix"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.23.3
TERMUX_PKG_SRCURL=http://webdav.org/cadaver/cadaver-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fd4ce68a3230ba459a92bcb747fc6afa91e46d803c1d5ffe964b661793c13fca
TERMUX_PKG_DEPENDS="libneon"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_prog_XML2_CONFIG=$TERMUX_PREFIX/bin/xml2-config
--with-neon=$TERMUX_PREFIX
--disable-nls
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DHAVE_LOCALE_H"
}
