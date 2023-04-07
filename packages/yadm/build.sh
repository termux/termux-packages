TERMUX_PKG_HOMEPAGE=https://github.com/TheLocehiliosan/yadm
TERMUX_PKG_DESCRIPTION="Yet Another Dotfiles Manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.2"
TERMUX_PKG_SRCURL=https://github.com/TheLocehiliosan/yadm/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c5fb508748995ce4c08a21d8bcda686ad680116ccf00a5318bbccf147f4c33ad
TERMUX_PKG_DEPENDS="git"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

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
