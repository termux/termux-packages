TERMUX_PKG_HOMEPAGE=https://ctags.io/
TERMUX_PKG_DESCRIPTION="Universal ctags: Source code index builder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.0.20180830
local _COMMIT=f9bbb35e7b4b053f04a1b6f0c2bbcea55641b2b6
TERMUX_PKG_SHA256=3585f1b9df43d7ecf31c06877fb7bfed4429a47fe95a8ab65da5738e76a442aa
TERMUX_PKG_SRCURL=https://github.com/universal-ctags/ctags/archive/${_COMMIT}.zip
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-tmpdir=$TERMUX_PREFIX/tmp"
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_pre_configure() {
	export regcomp_works=yes
	./autogen.sh
}
