TERMUX_PKG_HOMEPAGE=https://github.com/gurgeous/tennis
TERMUX_PKG_DESCRIPTION="Stylish CSV tables in your terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.0"
TERMUX_PKG_SRCURL="https://github.com/gurgeous/tennis/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=af6c59e523e12aa4eda4f8d54316e8e21e72e1711a8c91f953d8c71e9fb1e908
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RECOMMENDS="less, sqlite"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_post_make_install() {
	install -Dm644 extra/tennis.1 "$TERMUX_PREFIX/share/man/man1/tennis.1"
	install -Dm644 extra/tennis.bash "$TERMUX_PREFIX/share/bash-completion/completions/tennis"
	install -Dm644 extra/_tennis "$TERMUX_PREFIX/share/zsh/site-functions/_tennis"
}
