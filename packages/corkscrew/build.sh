TERMUX_PKG_HOMEPAGE=http://www.agroman.net/corkscrew/
TERMUX_PKG_DESCRIPTION="A tool for tunneling SSH through HTTP proxies"
TERMUX_PKG_DEPENDS="openssh"
TERMUX_PKG_VERSION=2.0
TERMUX_PKG_SRCURL=http://agroman.net/corkscrew/corkscrew-${TERMUX_PKG_VERSION}.tar.gz

termux_step_post_make_install () {
	# Corkscrew does not distribute a man page, use one from debian:
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_BUILDER_DIR/corkscrew.1 $TERMUX_PREFIX/share/man/man1
}
