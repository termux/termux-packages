TERMUX_PKG_HOMEPAGE=https://ctags.io/
TERMUX_PKG_DESCRIPTION="Universal ctags: Source code index builder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2:5.9.20221106.0
TERMUX_PKG_SRCURL=https://github.com/universal-ctags/ctags/archive/p${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=8e647fa314a33088d7e8384a9aca3903ce91dfe8805676d4219051d5353cf0ab
TERMUX_PKG_DEPENDS="libiconv, libjansson, libxml2, libyaml"
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
