TERMUX_PKG_HOMEPAGE=https://ctags.io/
TERMUX_PKG_DESCRIPTION="Universal ctags: Source code index builder"
TERMUX_PKG_VERSION=0.0.20170224
_COMMIT=a39f842455fdcc47b812c35c6bf0f19735034de0
TERMUX_PKG_SRCURL=https://github.com/universal-ctags/ctags/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=afec9c48d631204c7ec7c61e1c6b3cf0a8b7c5ac8737bb2313618e77595f3eb8
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-tmpdir=$TERMUX_PREFIX/tmp"
TERMUX_PKG_FOLDERNAME=ctags-$_COMMIT
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_pre_configure() {
	export regcomp_works=yes
	./autogen.sh
}
