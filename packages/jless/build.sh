TERMUX_PKG_HOMEPAGE=https://jless.io
TERMUX_PKG_DESCRIPTION="A command-line JSON viewer designed for reading, exploring, and searching through JSON data."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/PaulJuliusMartinez/jless/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=43527a78ba2e5e43a7ebd8d0da8b5af17a72455c5f88b4d1134f34908a594239
TERMUX_PKG_BUILD_DEPENDS="libxcb"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust
}
