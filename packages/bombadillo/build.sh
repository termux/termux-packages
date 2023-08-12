TERMUX_PKG_HOMEPAGE=https://bombadillo.colorfield.space/
TERMUX_PKG_DESCRIPTION="A non-web client for the terminal, supporting Gopher, Gemini and much more"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://tildegit.org/sloum/bombadillo/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e0daed1d9d0fe7cbea52bc3e6ecff327749b54e792774e6b985e0d64b7a36437
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bombadillo
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 \
		$TERMUX_PKG_SRCDIR/bombadillo.1
}
