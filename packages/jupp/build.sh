TERMUX_PKG_HOMEPAGE=https://www.mirbsd.org/jupp.htm
TERMUX_PKG_DESCRIPTION="User friendly full screen text editor"
TERMUX_PKG_MAINTAINER="Dominik George @Natureshadow"
TERMUX_PKG_DEPENDS="ncurses, libutil"
TERMUX_PKG_CONFLICTS="joe"
TERMUX_PKG_VERSION=3.1jupp31
TERMUX_PKG_SHA256=1a50607b0417cf230f7b3609c091e71e8d8e91185a4a3897f7925cd3b44cceba
TERMUX_PKG_SRCURL=https://pub.allbsd.org/MirOS/dist/jupp/joe-${TERMUX_PKG_VERSION}.tgz
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
