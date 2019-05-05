TERMUX_PKG_HOMEPAGE=https://ctags.io/
TERMUX_PKG_DESCRIPTION="Universal ctags: Source code index builder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.0.20190412
TERMUX_PKG_REVISION=1
local _COMMIT=61cc66cfc796e707cfb13c5fed493af280378c75
TERMUX_PKG_SHA256=479abda4686fafd11cae40f646c2b692cc0209783d233b2534b339b838af9acc
TERMUX_PKG_SRCURL=https://github.com/universal-ctags/ctags/archive/${_COMMIT}.zip
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-tmpdir=$TERMUX_PREFIX/tmp"
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_HOSTBUILD="yes"

termux_step_post_extract_package() {
	export regcomp_works=yes
	./autogen.sh
}

termux_step_pre_configure() {
	./autogen.sh
	cp $TERMUX_PKG_HOSTBUILD_DIR/packcc $TERMUX_PKG_BUILDDIR/
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/packcc
}
