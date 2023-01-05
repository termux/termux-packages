TERMUX_PKG_HOMEPAGE=https://aerc-mail.org/
TERMUX_PKG_DESCRIPTION="A pretty good email client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.0"
TERMUX_PKG_SRCURL=https://git.sr.ht/~rjarry/aerc/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=60bfd15e5528a504dd11a03a33a11438ebbac7d5daca46e02d0bdc983adf9012
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="LDFLAGS="
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang
}
