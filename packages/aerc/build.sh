TERMUX_PKG_HOMEPAGE=https://aerc-mail.org/
TERMUX_PKG_DESCRIPTION="A pretty good email client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.1
TERMUX_PKG_SRCURL=https://git.sr.ht/~rjarry/aerc/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e149236623c103c8526b1f872b4e630e67f15be98ac604c0ea0186054dbef0cc
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang
}
