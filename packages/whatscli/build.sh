TERMUX_PKG_HOMEPAGE=https://github.com/normen/whatscli
TERMUX_PKG_DESCRIPTION="A command line interface for WhatsApp"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="README.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.11
TERMUX_PKG_SRCURL=https://github.com/normen/whatscli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b4b2ceb1c4babe5fc53284714aebf102477543df247e2a25b533e4271d0622d7
termux_step_pre_configure() {
	termux_setup_golang
}
