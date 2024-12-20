TERMUX_PKG_HOMEPAGE=https://github.com/stsp/dj64dev
TERMUX_PKG_DESCRIPTION="development suite that allows to cross-build 64-bit programs for DOS"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@stsp"
TERMUX_PKG_VERSION=0.2
TERMUX_PKG_SRCURL=git+https://github.com/stsp/dj64dev.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="ctags, thunk-gen, libelf"
TERMUX_PKG_DEPENDS="djstub, thunk-gen"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	cd $TERMUX_PKG_SRCDIR
	autoreconf -v -i -I m4
}

termux_step_make() {
	local _PREFIX_FOR_CTAGS=${TERMUX_PREFIX}/opt/ctags
	local _PREFIX_FOR_THUNK_GEN=${TERMUX_PREFIX}/opt/thunk-gen
	export PATH="$PATH:${_PREFIX_FOR_CTAGS}/bin"
	export PKG_CONFIG_PATH="${_PREFIX_FOR_THUNK_GEN}/share/pkgconfig"
	cd $TERMUX_PKG_SRCDIR
	make
}
