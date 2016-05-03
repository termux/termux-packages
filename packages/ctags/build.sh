TERMUX_PKG_HOMEPAGE=https://ctags.io/
TERMUX_PKG_DESCRIPTION="Universal ctags: Source code index builder"
TERMUX_PKG_VERSION=0.0.20160502
_COMMIT=c82fb5e615de043ef98926ef21fc3f8cb4a57ae7
TERMUX_PKG_SRCURL=https://github.com/universal-ctags/ctags/archive/${_COMMIT}.zip
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-tmpdir=$TERMUX_PREFIX/tmp"
TERMUX_PKG_FOLDERNAME=ctags-$_COMMIT
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_post_extract_package () {
	export regcomp_works=yes
	cd $TERMUX_PKG_SRCDIR
	./autogen.sh
}
