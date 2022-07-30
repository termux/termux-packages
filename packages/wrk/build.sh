TERMUX_PKG_HOMEPAGE=https://github.com/wg/wrk
TERMUX_PKG_DESCRIPTION="Modern HTTP benchmarking tool"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.2.0
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/wg/wrk/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e255f696bff6e329f5d19091da6b06164b8d59d62cb9e673625bdcd27fe7bdad
TERMUX_PKG_DEPENDS="openssl, luajit"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_make() {
	local _ARCH

	if [ "$TERMUX_ARCH" = "i686" ]; then
		_ARCH="x86"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		_ARCH="x64"
	elif [ "$TERMUX_ARCH" = "aarch64" ]; then
		_ARCH="arm64"
	else
		_ARCH=$TERMUX_ARCH
	fi

	make WITH_OPENSSL=$TERMUX_PREFIX WITH_LUAJIT=$TERMUX_PREFIX _ARCH=$_ARCH
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin wrk
	install -Dm600 -t "$TERMUX_PREFIX"/share/doc/wrk/examples/ scripts/*.lua
	install -Dm600 -t "$TERMUX_PREFIX"/share/lua/5.1/ src/wrk.lua
}
