TERMUX_PKG_HOMEPAGE=https://ctags.io/
TERMUX_PKG_DESCRIPTION="Universal ctags: Source code index builder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2:5.9.20210613.0
TERMUX_PKG_SRCURL=https://github.com/universal-ctags/ctags/archive/p${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=74c9e515f0cb71d92b4422392effba21794b11fc34f0971aa4dc44e9a86708f4
TERMUX_PKG_DEPENDS="libiconv, libjansson, liblzma, libxml2, libyaml"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-tmpdir=$TERMUX_PREFIX/tmp --disable-static"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	export regcomp_works=yes
	./autogen.sh
}

termux_step_pre_configure() {
	./autogen.sh
	cp $TERMUX_PKG_HOSTBUILD_DIR/packcc $TERMUX_PKG_BUILDDIR/
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/packcc
}
