TERMUX_PKG_HOMEPAGE=https://www.mirbsd.org/jupp.htm
TERMUX_PKG_DESCRIPTION="User friendly full screen text editor"
TERMUX_PKG_MAINTAINER="Dominik George @Natureshadow"
TERMUX_PKG_DEPENDS="ncurses, libutil"
TERMUX_PKG_CONFLICTS="joe"
TERMUX_PKG_VERSION=3.1jupp35
TERMUX_PKG_SHA256=c4509df80b9f12d0f52b1b85c43717f068e42cad0fe281647ba5b2b9bdb34bec
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
