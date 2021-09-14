TERMUX_PKG_HOMEPAGE="https://github.com/TheDarkBug/uwufetch"
TERMUX_PKG_DESCRIPTION="A meme system info tool for Linux, based on nyan/uwu trend on r/linuxmasterrace"
TERMUX_PKG_VERSION="1.6"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Yonle <yonle@protonmail.com>"
TERMUX_PKG_SRCURL="https://github.com/TheDarkBug/uwufetch/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="252cddab47309bc1707d060e4b90ead34e48092b666005d2c137886fc86556ed"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make termux
}

termux_step_make_install() {
	# Copy manpage file to ${TERMUX_PREFIX}
	mkdir -p ${TERMUX_PREFIX}/share/man/man1
	cp uwufetch.1.gz ${TERMUX_PREFIX}/share/man/man1
}

termux_step_install_license() {
	# Copy license file to ${TERMUX_PREFIX}
	mkdir -p ${TERMUX_PREFIX}/share/doc/uwufetch
	cp LICENSE ${TERMUX_PREFIX}/share/doc/uwufetch
}
