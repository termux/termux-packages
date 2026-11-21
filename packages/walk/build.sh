TERMUX_PKG_HOMEPAGE=https://github.com/antonmedv/walk
TERMUX_PKG_DESCRIPTION="A terminal file manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.14.0"
TERMUX_PKG_SRCURL=https://github.com/antonmedv/walk/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1d611d683c6764de089971e838dd8462dc1d6e63b3faf1a8f8d2a144d7264a3e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

# Package was previously named as "llama".
TERMUX_PKG_BREAKS="llama (<< 1.4.0-2)"
TERMUX_PKG_REPLACES="llama (<< 1.4.0-2)"

termux_step_make() {
	termux_setup_golang

	go mod init || :
	go mod tidy
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin walk
}
