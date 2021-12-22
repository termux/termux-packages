TERMUX_PKG_HOMEPAGE=https://aerc-mail.org/
TERMUX_PKG_DESCRIPTION="An email client that runs in your terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://git.sr.ht/~sircmpwn/aerc/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dec6560c1359d1d56124a85692e877e319036f0312ce9b7a31f9828f99b92c61
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang
}
