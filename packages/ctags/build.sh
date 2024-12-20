TERMUX_PKG_HOMEPAGE=https://ctags.io/
TERMUX_PKG_DESCRIPTION="Universal ctags: Source code index builder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2:6.1.0"
TERMUX_PKG_SRCURL=https://github.com/universal-ctags/ctags/archive/refs/tags/v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=1eb6d46d4c4cace62d230e7700033b8db9ad3d654f2d4564e87f517d4b652a53
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libiconv, libjansson, libxml2, libyaml"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-tmpdir=$TERMUX_PREFIX/tmp --disable-static"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	export regcomp_works=yes
	./autogen.sh
}

termux_step_host_build() {
	local _PREFIX_FOR_BUILD=${TERMUX_PREFIX}/opt/$TERMUX_PKG_NAME
	cd $TERMUX_PKG_SRCDIR
	./configure $TERMUX_PKG_EXTRA_CONFIGURE_ARGS --prefix=$_PREFIX_FOR_BUILD
	make -j $TERMUX_PKG_MAKE_PROCESSES
	make install
	make clean
}

termux_step_pre_configure() {
	./autogen.sh
}
