TERMUX_PKG_HOMEPAGE=https://www.mirbsd.org/jupp.htm
TERMUX_PKG_DESCRIPTION="User friendly full screen text editor"
TERMUX_PKG_MAINTAINER="Dominik George @Natureshadow"
TERMUX_PKG_DEPENDS="ncurses, libutil"
TERMUX_PKG_CONFLICTS="joe"
TERMUX_PKG_VERSION=3.1jupp30
TERMUX_PKG_SRCURL=https://pub.allbsd.org/MirOS/dist/jupp/joe-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=65ddb346364a056c1d78a1cb406b0ebf6c9c2fbd753cd404b1b4c8fd3fa9916d
TERMUX_PKG_FOLDERNAME=jupp
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-termcap --disable-getpwnam --disable-termidx --disable-dependency-tracking --enable-sysconfjoesubdir=/jupp"

termux_step_post_extract_package() {
	cd $TERMUX_PKG_SRCDIR
	chmod +x configure
}
