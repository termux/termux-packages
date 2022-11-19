TERMUX_PKG_HOMEPAGE=https://github.com/dandavison/delta
TERMUX_PKG_DESCRIPTION="A syntax-highlighter for git and diff output"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.0"
TERMUX_PKG_SRCURL=https://github.com/dandavison/delta/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7d1ab2949d00f712ad16c8c7fc4be500d20def9ba70394182720a36d300a967c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="git, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f Makefile release.Makefile
	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu="-O2"

	local _ORIG_CFLAGS="$CFLAGS"
	termux_setup_rust
	export CFLAGS="$_ORIG_CFLAGS"

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local _patch=$TERMUX_SCRIPTDIR/packages/libgit2/src-util-rand.c.patch
	local d
	for d in $CARGO_HOME/registry/src/github.com-*/libgit2-sys-*/libgit2; do
		(
			t=${d}/src/
			cp $TERMUX_SCRIPTDIR/packages/libgit2/getloadavg.c ${t}
			patch --silent -d ${t} < ${_patch}
		) || :
	done
}

termux_step_post_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/delta
	install -Dm600 "$TERMUX_PKG_SRCDIR"/etc/completion/completion.bash \
		"$TERMUX_PREFIX"/share/bash-completion/completions/delta
}
