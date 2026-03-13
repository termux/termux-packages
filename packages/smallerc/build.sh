TERMUX_PKG_HOMEPAGE=https://github.com/alexfru/SmallerC
TERMUX_PKG_DESCRIPTION="Simple and small C compiler for DOS, Windows, Linux and MacOS"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.2
TERMUX_PKG_SRCURL=https://github.com/alexfru/SmallerC/archive/refs/tags/v${TERMUX_PKG_VERSION}+dos.win.b120a9c.tar.gz
TERMUX_PKG_SHA256=1e26ed8da461614da26379b7be1510f0e39f52a292fd0d9e54d747664f0c7ef4
TERMUX_PKG_BUILD_DEPENDS="nasm"
TERMUX_PKG_DEPENDS="nasm"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	local _PREFIX_FOR_BUILD=${TERMUX_PREFIX}/opt/$TERMUX_PKG_NAME/cross
	cd $TERMUX_PKG_SRCDIR
	make prefix=$_PREFIX_FOR_BUILD
	make install prefix=$_PREFIX_FOR_BUILD
	make clean
	export PATH="$PATH:$_PREFIX_FOR_BUILD/bin"
}

termux_step_make() {
	local _PREFIX_FOR_BUILD=${TERMUX_PREFIX}/opt/$TERMUX_PKG_NAME/cross
	make prefix=$PREFIX SMLRCC="${_PREFIX_FOR_BUILD}/bin/smlrcc"
}

termux_step_make_install() {
	make install prefix=$PREFIX
}
