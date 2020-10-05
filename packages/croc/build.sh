TERMUX_PKG_HOMEPAGE=https://github.com/schollz/croc
TERMUX_PKG_DESCRIPTION="Easily and securely send things from one computer to another."
TERMUX_PKG_LICENSE=MIT
TERMUX_PKG_VERSION=8.4.0
TERMUX_PKG_SRCURL=https://github.com/schollz/croc/releases/download/v${TERMUX_PKG_VERSION}/croc_${TERMUX_PKG_VERSION}_src.tar.gz
TERMUX_PKG_SHA256=2f0de360e252974dbb7d2ab688f17b0ad6e842b48a33bd33ec9272055aca2780
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR

	termux_setup_golang

	go build -o croc -trimpath
}

termux_step_make_install() {
	install -m755 croc $TERMUX_PREFIX/bin/croc
}
