TERMUX_PKG_HOMEPAGE=https://www.mirbsd.org/jupp.htm
TERMUX_PKG_DESCRIPTION="User friendly full screen text editor"
TERMUX_PKG_MAINTAINER="Dominik George @Natureshadow"
TERMUX_PKG_DEPENDS="ncurses, libutil"
TERMUX_PKG_CONFLICTS="joe"
TERMUX_PKG_VERSION=3.1jupp36
TERMUX_PKG_SHA256=99df61b8644613144f4bcb9e6b8fc53a722c39521cdc7a0413c5a9146fd63e9f
TERMUX_PKG_SRCURL=https://www.mirbsd.org/MirOS/dist/jupp/joe-${TERMUX_PKG_VERSION}.tgz
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
