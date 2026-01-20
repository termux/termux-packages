TERMUX_PKG_HOMEPAGE="https://github.com/minfrin/retry"
TERMUX_PKG_DESCRIPTION="Repeat a command until the command succeeds"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.5
TERMUX_PKG_SRCURL="https://github.com/minfrin/retry/archive/refs/tags/retry-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=6981f2cd5354933d732e257846f5e8391761354402b03fb89d4683e27a63e6e2

termux_step_pre_configure() {
	autoreconf -fi
}
