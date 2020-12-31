TERMUX_PKG_HOMEPAGE=https://github.com/dandavison/delta
TERMUX_PKG_DESCRIPTION="A syntax-highlighter for git and diff output"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.0
TERMUX_PKG_SRCURL=https://github.com/dandavison/delta/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=aef2ef9e4260eabb7a04f36f0485c9b041029a7da1d69d9e6eabb03a7466ab26
TERMUX_PKG_DEPENDS="git"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f Makefile release.Makefile
	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu="-O2"
}

termux_step_post_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/delta
	install -Dm600 "$TERMUX_PKG_SRCDIR"/etc/completion/completion.bash \
		"$TERMUX_PREFIX"/share/bash-completion/completions/delta
}
