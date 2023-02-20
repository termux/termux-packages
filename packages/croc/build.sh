TERMUX_PKG_HOMEPAGE=https://github.com/schollz/croc
TERMUX_PKG_DESCRIPTION="Easily and securely send things from one computer to another"
TERMUX_PKG_LICENSE=MIT
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.6.3"
TERMUX_PKG_SRCURL=https://github.com/schollz/croc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6b935a30ae90e971676872aa6401065d1ece5bb6d4b7b9e370afe96affb2c5bc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR

	termux_setup_golang

	go build -o croc -trimpath
}

termux_step_make_install() {
	install -m755 croc $TERMUX_PREFIX/bin/croc
}
