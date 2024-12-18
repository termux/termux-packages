TERMUX_PKG_HOMEPAGE=https://github.com/stsp/djstub
TERMUX_PKG_DESCRIPTION="go32-compatible stub that supports COFF, PE and ELF payloads"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@stsp"
TERMUX_PKG_VERSION=0.2
TERMUX_PKG_SRCURL=git+https://github.com/stsp/djstub.git
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="smallerc-cross"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	local _PREFIX_FOR_BUILD=${TERMUX_PREFIX}/opt/djstub
	local _PREFIX_FOR_SMALLERC=${TERMUX_PREFIX}/opt/smallerc/cross
	export PATH="$PATH:$_PREFIX_FOR_SMALLERC/bin"
	cd $TERMUX_PKG_SRCDIR
	make -j $TERMUX_PKG_MAKE_PROCESSES prefix=$_PREFIX_FOR_BUILD
	make install prefix=$_PREFIX_FOR_BUILD
	make clean
}

termux_step_make() {
	local _PREFIX_FOR_SMALLERC=${TERMUX_PREFIX}/opt/smallerc/cross
	export PATH="$PATH:$_PREFIX_FOR_SMALLERC/bin"
	make -j $TERMUX_PKG_MAKE_PROCESSES prefix=$PREFIX
}

termux_step_make_install() {
	make install prefix=$PREFIX
}
