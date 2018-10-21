TERMUX_PKG_HOMEPAGE=https://www.mirbsd.org/jupp.htm
TERMUX_PKG_DESCRIPTION="User friendly full screen text editor"
TERMUX_PKG_MAINTAINER="Dominik George @Natureshadow"
TERMUX_PKG_DEPENDS="ncurses, libutil"
TERMUX_PKG_CONFLICTS="joe"
TERMUX_PKG_VERSION=3.1jupp37
TERMUX_PKG_SHA256=7755480792026b4eedc1ed5abe3f771ace85d402195a658d4bd3a9e9cdd8f11b
TERMUX_PKG_SRCURL=http://www.mirbsd.org/MirOS/dist/jupp/joe-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-dependency-tracking
--disable-getpwnam
--disable-termcap
--disable-termidx
--enable-sysconfjoesubdir=/jupp
"

termux_step_post_extract_package() {
	chmod +x $TERMUX_PKG_SRCDIR/configure
}
