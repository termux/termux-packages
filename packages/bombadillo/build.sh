TERMUX_PKG_HOMEPAGE=https://bombadillo.colorfield.space/
TERMUX_PKG_DESCRIPTION="A non-web client for the terminal, supporting Gopher, Gemini and much more"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://deb.debian.org/debian/pool/main/b/bombadillo/bombadillo_${TERMUX_PKG_VERSION}.orig.tar.gz
TERMUX_PKG_SHA256=d52a753e7a77c5ab486f536a7c488e61c68a8c11a5e455143d281b3d8306afa0
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
