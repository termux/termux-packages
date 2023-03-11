TERMUX_PKG_HOMEPAGE=https://bombadillo.colorfield.space/
TERMUX_PKG_DESCRIPTION="A non-web client for the terminal, supporting Gopher, Gemini and much more"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.3
TERMUX_PKG_SRCURL=https://tildegit.org/sloum/bombadillo/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2d4ec15cac6d3324f13a4039cca86fecf3141503f556a6fa48bdbafb86325f1c
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
