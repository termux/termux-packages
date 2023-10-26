TERMUX_PKG_HOMEPAGE=https://www.netlib.org/lapack/
TERMUX_PKG_DESCRIPTION="Linear Algebra PACKage"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="Adam Jozef Labus <adam.labuznik@gmail.com>"
TERMUX_PKG_VERSION=3.11.0
TERMUX_PKG_SRCURL=https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4b9ba79bfd4921ca820e83979db76ab3363155709444a787979e81c22285ffa9
TERMUX_PKG_DEPENDS="flang, libopenblas, clang"
#Because of flang
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"
