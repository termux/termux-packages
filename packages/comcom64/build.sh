TERMUX_PKG_HOMEPAGE=https://github.com/dosemu2/comcom64
TERMUX_PKG_DESCRIPTION="64bit command.com"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@stsp"
TERMUX_PKG_VERSION="0.3"
TERMUX_PKG_SRCURL=git+https://github.com/dosemu2/comcom64.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="dj64dev"
TERMUX_PKG_DEPENDS="dj64dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	local _PREFIX_FOR_DJSTUB=${TERMUX_PREFIX}/opt/djstub
	local _PREFIX_FOR_THUNK_GEN=${TERMUX_PREFIX}/opt/thunk-gen
	export PATH="$PATH:$_PREFIX_FOR_DJSTUB/bin"
	export PKG_CONFIG_PATH="${_PREFIX_FOR_THUNK_GEN}/share/pkgconfig"
}

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR
	make -j $TERMUX_PKG_MAKE_PROCESSES prefix=$PREFIX
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR
	make install prefix=$PREFIX
}
