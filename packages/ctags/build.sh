TERMUX_PKG_HOMEPAGE=https://ctags.io/
TERMUX_PKG_DESCRIPTION="Universal ctags: Source code index builder"
TERMUX_PKG_VERSION=0.0.20170901
local _COMMIT=8a60622839c98ef6fac1c57a5563812393c56c1d
TERMUX_PKG_SHA256=33bd6ada4889d4d023fb44f44d440a5bcf82606c99a378a694f2a001cb6d1a56
TERMUX_PKG_SRCURL=https://github.com/universal-ctags/ctags/archive/${_COMMIT}.zip
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-tmpdir=$TERMUX_PREFIX/tmp"
TERMUX_PKG_FOLDERNAME=ctags-$_COMMIT
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_pre_configure() {
	export regcomp_works=yes
	./autogen.sh
}
