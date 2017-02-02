TERMUX_PKG_HOMEPAGE=https://ctags.io/
TERMUX_PKG_DESCRIPTION="Universal ctags: Source code index builder"
TERMUX_PKG_VERSION=0.0.20170123
_COMMIT=15504fe2d0c84b6dbcb0b8a5c594424dd383185e
TERMUX_PKG_SRCURL=https://github.com/universal-ctags/ctags/archive/${_COMMIT}.zip
TERMUX_PKG_CHECKTYPE=SHA256
TERMUX_PKG_CHECKSUM=02b5572840788af5113b14067bab0e5e60eedd17c8eb305da469834c80eaa152
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-tmpdir=$TERMUX_PREFIX/tmp"
TERMUX_PKG_FOLDERNAME=ctags-$_COMMIT
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_pre_configure() {
	cd $TERMUX_PKG_SRCDIR
	export regcomp_works=yes
	./autogen.sh
}
