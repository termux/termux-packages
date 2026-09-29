# Contributor: @Neo-Oli
TERMUX_PKG_HOMEPAGE=https://www.colordiff.org/
TERMUX_PKG_DESCRIPTION="Tool to colorize 'diff' output"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_VERSION=1.0.22
TERMUX_PKG_SRCURL="https://www.colordiff.org/colordiff-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f96f73c54521c53f14dc164d5a3920c9ca21a0e5f8e9613f43812a98af3e22af
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true

# Skip the 'make' build invocation
# as it only tries to rebuild the documentation.
termux_step_make() {
	:
}

termux_step_post_configure() {
	export INSTALL_DIR=${PREFIX}/bin
	export MAN_DIR=${PREFIX}/share/man/man1
	export ETC_DIR=${PREFIX}/etc
}
