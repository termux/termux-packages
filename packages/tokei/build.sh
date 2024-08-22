TERMUX_PKG_HOMEPAGE=https://github.com/XAMPPRocky/tokei
TERMUX_PKG_DESCRIPTION="A blazingly fast CLOC (Count Lines Of Code) program"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="13.0.0-alpha.4"
TERMUX_PKG_SRCURL=https://github.com/XAMPPRocky/tokei/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=49c5401e9f752a3ef93870ec720cec688b5e9bd2281e45a68d595e2bb78c02c4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--features all"

termux_step_post_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/tokei \
		"$TERMUX_PREFIX"/bin/tokei
}
