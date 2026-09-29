TERMUX_PKG_HOMEPAGE=https://github.com/AngelJumbo/sssnake
TERMUX_PKG_DESCRIPTION="cli snake game that plays itself"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.0
TERMUX_PKG_SRCURL=https://github.com/AngelJumbo/sssnake/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7ed2e4cd9d56b3d6a524f5e8467158c675fabd7e70916fc9d858b6bc4f64d9ae
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"

termux_step_pre_configure() {
	# the release tarball ships a prebuilt host sssnake binary that is
	# newer than the sources, so make sees it as up to date and skips
	# compiling it for the target arch
	rm -f sssnake
}
