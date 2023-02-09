TERMUX_PKG_HOMEPAGE="https://github.com/charliermarsh/ruff"
TERMUX_PKG_DESCRIPTION="An extremely fast Python linter, written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="../../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.244"
TERMUX_PKG_SRCURL="https://github.com/charliermarsh/ruff/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=39365408b40c1917635daf879cc1c9f2083a549ccec4f0f41c1fe135b7aa44ac
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/crates/ruff_cli"
	TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"
}
