TERMUX_PKG_HOMEPAGE="http://icps.u-strasbg.fr/~bastoul/development/openscop"
TERMUX_PKG_DESCRIPTION="A Specification and a Library for Data Exchange in Polyhedral Compilation Tools"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.5"
TERMUX_PKG_SRCURL="https://github.com/periscop/openscop/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=168e7c4afdf6a2d1dca1a1caa92e0a093688c98ce01272ab100fe89ec75fdd41
TERMUX_PKG_DEPENDS="libgmp"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	rm -f CMakeLists.txt
}
termux_step_pre_configure() {
	autoreconf -fi
}
