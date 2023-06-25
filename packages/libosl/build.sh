TERMUX_PKG_HOMEPAGE="http://icps.u-strasbg.fr/~bastoul/development/openscop"
TERMUX_PKG_DESCRIPTION="A Specification and a Library for Data Exchange in Polyhedral Compilation Tools"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.6"
TERMUX_PKG_SRCURL="https://github.com/periscop/openscop/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=fbff4cf0153ac1174897aa26315e2f32ad34786f9b27e20420ff4801bde6c668
TERMUX_PKG_DEPENDS="libgmp"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	rm -f CMakeLists.txt
}
termux_step_pre_configure() {
	autoreconf -fi
}
