TERMUX_PKG_HOMEPAGE=https://www.radare.org
TERMUX_PKG_DESCRIPTION="Ghidra Decompiler plugin for radare2"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.8.4"
TERMUX_PKG_SRCURL=https://github.com/radareorg/r2ghidra/releases/download/${TERMUX_PKG_VERSION}/r2ghidra-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=20c2a9e006836c7291a1bad2010fd787c31c8eac2576ec5c8d9fd2116ae15809
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="radare2"
TERMUX_PKG_BUILD_DEPENDS="radare2"

termux_step_pre_configure () {
	unset CXXFLAGS
	unset CPPFLAGS
	unset CFLAGS
	bash ./preconfigure
}
