TERMUX_PKG_HOMEPAGE=https://github.com/dandavison/delta
TERMUX_PKG_DESCRIPTION="A syntax-highlighter for git and diff output"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.0.16
TERMUX_PKG_SRCURL=https://github.com/dandavison/delta/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=631349484bb52f3bb1c22385e19d98903c094212e83fe109f97aeff0281cf00e
TERMUX_PKG_DEPENDS="git"
TERMUX_PKG_BUILD_IN_SRC=true
# Build fails on these arches when cross-compiling with error
#  cargo:warning=error: unknown target CPU
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_pre_configure() {
	rm -f Makefile
}

termux_step_post_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/delta
	install -Dm600 "$TERMUX_PKG_SRCDIR"/completion/bash/completion.sh \
		"$TERMUX_PREFIX"/share/bash-completion/completions/delta
}
