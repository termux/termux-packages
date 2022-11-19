TERMUX_PKG_HOMEPAGE=https://github.com/coin-or/Clp
TERMUX_PKG_DESCRIPTION="An open-source linear programming solver"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:1.17.7
TERMUX_PKG_SRCURL=https://github.com/coin-or/Clp/archive/refs/tags/releases/${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=c4c2c0e014220ce8b6294f3be0f3a595a37bef58a14bf9bac406016e9e73b0f5
TERMUX_PKG_DEPENDS="libc++, libcoinor-osi, libcoinor-utils"
