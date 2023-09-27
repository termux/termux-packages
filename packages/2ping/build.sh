TERMUX_PKG_HOMEPAGE=https://www.finnie.org/software/2ping/
TERMUX_PKG_DESCRIPTION="A bi-directional ping utility"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.5.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/rfinnie/2ping/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0f85dc21be1266daccfbba903819ca8935ebdbe002b1e0305bfda258af44fdcd
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 doc/2ping.1
}
