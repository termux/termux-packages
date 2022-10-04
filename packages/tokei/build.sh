TERMUX_PKG_HOMEPAGE=https://github.com/XAMPPRocky/tokei
TERMUX_PKG_DESCRIPTION="A blazingly fast CLOC (Count Lines Of Code) program"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=12.1.2
TERMUX_PKG_SRCURL=https://github.com/XAMPPRocky/tokei/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=81ef14ab8eaa70a68249a299f26f26eba22f342fb8e22fca463b08080f436e50
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--features all"

termux_step_post_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/tokei \
		"$TERMUX_PREFIX"/bin/tokei
}
