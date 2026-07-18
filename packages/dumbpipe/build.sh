TERMUX_PKG_HOMEPAGE=https://www.dumbpipe.dev/
TERMUX_PKG_DESCRIPTION="A CLI tool to pipe data over the network, with NAT hole punching"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="
LICENSE-APACHE
LICENSE-MIT
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.39.0"
TERMUX_PKG_SRCURL="https://github.com/n0-computer/dumbpipe/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=89d01b0b6d25fc8baf06ab791fd0a2b35b24ac51d0bd01b64d36c35750aaf3e9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export CARGO_PROFILE_RELEASE_PANIC=unwind
	termux_setup_rust
	cargo update -p iroh --precise 1.0.2
}
