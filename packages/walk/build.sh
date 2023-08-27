TERMUX_PKG_HOMEPAGE=https://github.com/antonmedv/walk
TERMUX_PKG_DESCRIPTION="A terminal file manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.2"
TERMUX_PKG_SRCURL=https://github.com/antonmedv/walk/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b6ba7a5e3873a25944e0f18c8a3ebbfdc0e8681756517905c75972c824315970
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
