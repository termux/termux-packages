TERMUX_PKG_HOMEPAGE=https://github.com/XAMPPRocky/tokei
TERMUX_PKG_DESCRIPTION="A blazingly fast CLOC (Count Lines Of Code) program"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=12.1.0
TERMUX_PKG_SRCURL=https://github.com/XAMPPRocky/tokei/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=cd86db17fa7e1d94c9de905f8c3afca92b21c6448a2fc4359e270cb8daad0be2
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--features all"

termux_step_post_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/tokei \
		"$TERMUX_PREFIX"/bin/tokei
}
