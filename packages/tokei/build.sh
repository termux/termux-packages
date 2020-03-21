TERMUX_PKG_HOMEPAGE=https://github.com/XAMPPRocky/tokei
TERMUX_PKG_DESCRIPTION="A blazingly fast CLOC (Count Lines Of Code) program"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_VERSION=11.0.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/XAMPPRocky/tokei/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d7b02fafc6dc08a222ac49028acfc22ce9e5baa6a8a53b0c88a38c146bed276e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--features all"

termux_step_post_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/tokei \
		"$TERMUX_PREFIX"/bin/tokei
}
