TERMUX_PKG_HOMEPAGE=https://ctags.io/
TERMUX_PKG_DESCRIPTION="Universal ctags: Source code index builder"
TERMUX_PKG_VERSION=0.0.20161128
_COMMIT=ff448e2e2a08325c95f2e162ae50fb899392d99f
TERMUX_PKG_SRCURL=https://github.com/universal-ctags/ctags/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=2f90f4887695dd42969c2cdad003132c1d6ce395966c58379aafc7891d1dd0a0
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-tmpdir=$TERMUX_PREFIX/tmp"
TERMUX_PKG_FOLDERNAME=ctags-$_COMMIT
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_post_extract_package () {
	export regcomp_works=yes
	./autogen.sh
}
