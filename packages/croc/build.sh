TERMUX_PKG_HOMEPAGE=https://github.com/schollz/croc
TERMUX_PKG_DESCRIPTION="Easily and securely send things from one computer to another"
TERMUX_PKG_LICENSE=MIT
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.6.2
TERMUX_PKG_SRCURL=https://github.com/schollz/croc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=af1889daca1cd71445975aebb80dc416b01b1e8d63cd261a79a5dd1a3fd74b29
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
