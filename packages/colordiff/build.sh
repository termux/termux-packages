TERMUX_PKG_HOMEPAGE=https://www.colordiff.org/
TERMUX_PKG_DESCRIPTION="Tool to colorize 'diff' output"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_VERSION=1.0.21
TERMUX_PKG_SRCURL=https://www.colordiff.org/colordiff-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9b30f4257ef0f0806dea5a27c9ad8edc3f7999f05ddaff6f0627064dc927e615
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make() {
	# Skip the 'make' invocation as it only tries to
	# rebuild the documentation.
	continue
}

termux_step_post_configure() {
	export INSTALL_DIR=${PREFIX}/bin
	export MAN_DIR=${PREFIX}/share/man/man1
	export ETC_DIR=${PREFIX}/etc
}
