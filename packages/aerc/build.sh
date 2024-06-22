TERMUX_PKG_HOMEPAGE=https://aerc-mail.org/
TERMUX_PKG_DESCRIPTION="A pretty good email client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.17.0"
TERMUX_PKG_SRCURL=https://git.sr.ht/~rjarry/aerc/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a8a1af36b4d4989afd670601d83fc2088e14d804c66bd1e3bdd14561bd89c2cc
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="LDFLAGS="
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang
}
