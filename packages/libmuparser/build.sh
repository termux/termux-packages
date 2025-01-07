TERMUX_PKG_HOMEPAGE="https://beltoforion.de/en/muparser"
TERMUX_PKG_DESCRIPTION="An extensible high performance math expression parser library written in C++"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.5"
TERMUX_PKG_SRCURL="https://github.com/beltoforion/muparser/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=20b43cc68c655665db83711906f01b20c51909368973116dfc8d7b3c4ddb5dd4
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	LDFLAGS+=" -fopenmp -static-openmp"
}
