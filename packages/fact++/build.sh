TERMUX_PKG_HOMEPAGE=https://bitbucket.org/dtsarkov/factplusplus
TERMUX_PKG_DESCRIPTION="Re-implementation of the well-known FaCT Description Logic (DL) Reasoner"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="licensing/FaCT++.license.txt, licensing/lgpl-2.1.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.5
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://bitbucket.org/dtsarkov/factplusplus/downloads/FaCTpp-src-v${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=d76ce04073ad6523eeb3fc761c012b20e3062ff78406f9da3fd2076828264e4e
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/src"
}
