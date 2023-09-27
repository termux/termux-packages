TERMUX_PKG_HOMEPAGE=https://etsh.nl
TERMUX_PKG_DESCRIPTION="An enhanced, backward-compatible port of Thompson Shell"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.4.0
TERMUX_PKG_SRCURL=https://etsh.nl/src/etsh_${TERMUX_PKG_VERSION}/etsh-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=fd4351f50acbb34a22306996f33d391369d65a328e3650df75fb3e6ccacc8dce
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	sh ./mkconfig
}
