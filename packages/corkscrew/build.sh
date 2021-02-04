TERMUX_PKG_HOMEPAGE=https://wiki.linuxquestions.org/wiki/Corkscrew
TERMUX_PKG_DESCRIPTION="A tool for tunneling SSH through HTTP proxies"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/termux/distfiles/releases/download/2021.01.04/corkscrew-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0d0fcbb41cba4a81c4ab494459472086f377f9edb78a2e2238ed19b58956b0be
TERMUX_PKG_DEPENDS="openssh"

termux_step_post_make_install() {
	# Corkscrew does not distribute a man page, use one from debian:
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_BUILDER_DIR/corkscrew.1 $TERMUX_PREFIX/share/man/man1
}
