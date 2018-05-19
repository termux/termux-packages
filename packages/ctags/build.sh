TERMUX_PKG_HOMEPAGE=https://ctags.io/
TERMUX_PKG_DESCRIPTION="Universal ctags: Source code index builder"
TERMUX_PKG_VERSION=0.0.20180513
local _COMMIT=6418097e63c837c097f04727e3508ef2db0a7339
TERMUX_PKG_SHA256=a20c5a4729325df486a048d75fe05ba45ec4248db977cfc1e8b7ddfe87e1696c
TERMUX_PKG_SRCURL=https://github.com/universal-ctags/ctags/archive/${_COMMIT}.zip
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-tmpdir=$TERMUX_PREFIX/tmp"
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_pre_configure() {
	export regcomp_works=yes
	./autogen.sh
}
