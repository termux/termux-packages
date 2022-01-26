TERMUX_PKG_HOMEPAGE=https://github.com/TheLocehiliosan/yadm
TERMUX_PKG_DESCRIPTION="Yet Another Dotfiles Manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/TheLocehiliosan/yadm/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9f848c80deed2725c012d058bd60d1ea13539fd6fbacd5245bf97d442cb89263
TERMUX_PKG_DEPENDS="git"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	# Do not try to run 'make' as it causes a build failure.
	return
}

termux_step_make_install() {
	install -Dm700 "$TERMUX_PKG_SRCDIR"/yadm "$TERMUX_PREFIX"/bin/
	install -Dm600 "$TERMUX_PKG_SRCDIR"/yadm.1 "$TERMUX_PREFIX"/share/man/man1/
	install -Dm600 "$TERMUX_PKG_SRCDIR"/completion/bash/yadm \
		"$TERMUX_PREFIX"/share/bash-completion/completions/yadm
	install -Dm600 "$TERMUX_PKG_SRCDIR"/completion/zsh/_yadm \
		"$TERMUX_PREFIX"/share/zsh/site-functions/_yadm
	install -Dm600 "$TERMUX_PKG_SRCDIR"/completion/fish/yadm.fish \
		"$TERMUX_PREFIX"/share/fish/vendor_completions.d/yadm.fish
}
