TERMUX_PKG_HOMEPAGE=https://lastpass.com/
TERMUX_PKG_DESCRIPTION="LastPass command line interface tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.0"
TERMUX_PKG_SRCURL=https://github.com/lastpass/lastpass-cli/archive/v$TERMUX_PKG_VERSION/lastpass-cli-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=152d76e43891fe1ccafed903a1a8cee5fc2361a14701f493715b03d336bb49ff
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcurl, libxml2, openssl, pinentry"
TERMUX_PKG_BUILD_DEPENDS="bash-completion"
TERMUX_PKG_SUGGESTS="termux-api"

termux_step_post_make_install() {
	ninja install-doc

	install -Dm600 "$TERMUX_PKG_SRCDIR"/contrib/lpass_zsh_completion \
		"$TERMUX_PREFIX"/share/zsh/site-functions/_lpass

	install -Dm600 "$TERMUX_PKG_SRCDIR"/contrib/completions-lpass.fish \
		"$TERMUX_PREFIX"/share/fish/vendor_completions.d/lpass.fish
}
