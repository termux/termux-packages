TERMUX_PKG_HOMEPAGE=https://www.finnie.org/software/2ping/
TERMUX_PKG_DESCRIPTION="A bi-directional ping utility"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.6.1
TERMUX_PKG_SRCURL="https://github.com/rfinnie/2ping/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c8352b6653c3194af1f869107655df3f98ab18b560e8bce86eabac08d73c72eb
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_make_install() {
	install -Dm600 -t "$TERMUX_PREFIX/share/man/man1" doc/2ping.1
}
