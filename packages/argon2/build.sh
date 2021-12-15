TERMUX_PKG_HOMEPAGE=https://github.com/P-H-C/phc-winner-argon2
TERMUX_PKG_DESCRIPTION="A password-hashing function (reference C implementation)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20190702
TERMUX_PKG_SRCURL=https://github.com/P-H-C/phc-winner-argon2/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=daf972a89577f8772602bf2eb38b6a3dd3d922bf5724d45e7f9589b5e830442c
TERMUX_PKG_EXTRA_MAKE_ARGS="LIBRARY_REL=lib"
TERMUX_PKG_BUILD_IN_SRC=true
