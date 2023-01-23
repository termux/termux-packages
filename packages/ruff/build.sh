TERMUX_PKG_HOMEPAGE="https://github.com/charliermarsh/ruff"
TERMUX_PKG_DESCRIPTION="An extremely fast Python linter, written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.230"
TERMUX_PKG_SRCURL="https://github.com/charliermarsh/ruff/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=f55f2caa68b9f841eeb475763040cf10085a0dd29f89f2183f9c6a440e8b5c03
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/ruff_cli"
	TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"
}
