TERMUX_PKG_HOMEPAGE=https://ctags.io/
TERMUX_PKG_DESCRIPTION="Universal ctags: Source code index builder"
TERMUX_PKG_VERSION=0.0.20180120
local _COMMIT=cbb7fb49c39c4c09d0188010b2879eccd7d465a8
TERMUX_PKG_SHA256=a8bcc4a8158e10ec94ff14a0c91d9fcc46050ff5abc22b8e9045d72da538b68f
TERMUX_PKG_SRCURL=https://github.com/universal-ctags/ctags/archive/${_COMMIT}.zip
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-tmpdir=$TERMUX_PREFIX/tmp"
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_pre_configure() {
	export regcomp_works=yes
	./autogen.sh
}
