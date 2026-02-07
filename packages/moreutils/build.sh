TERMUX_PKG_HOMEPAGE=https://joeyh.name/code/moreutils/
TERMUX_PKG_DESCRIPTION="A growing collection of the unix tools that nobody thought to write thirty years ago"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.70"
TERMUX_PKG_REVISION=1
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_SRCURL=git+https://git.joeyh.name/git/moreutils.git
TERMUX_PKG_SHA256=2170c46219ce8d6f17702321534769dfbfece52148a78cd12ea73b5d3a72ff7c
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

# chronic requires set of external perl modules.
TERMUX_PKG_RM_AFTER_INSTALL="
bin/chronic
share/man/man1/chronic.1
share/man/man1/parallel.1
"

termux_step_get_source() {
	# The source repo for this package only provides dumb http transport.
	# So this is mostly a duplicate of `termux_git_clone_src`
	# without `--depth 1` to avoid:
	#
	# fatal: dumb http transport does not support shallow capabilities
	local TMP_CHECKOUT="$TERMUX_PKG_CACHEDIR/tmp-checkout"
	local TMP_CHECKOUT_VERSION="$TERMUX_PKG_CACHEDIR/tmp-checkout-version"

	if [[ ! -f $TMP_CHECKOUT_VERSION || "$(< "$TMP_CHECKOUT_VERSION")" != "$TERMUX_PKG_VERSION" ]]; then
		rm -rf "$TMP_CHECKOUT"
		git clone \
			--branch "$TERMUX_PKG_GIT_BRANCH" \
			"${TERMUX_PKG_SRCURL:4}" \
			"$TMP_CHECKOUT"
		echo "$TERMUX_PKG_VERSION" > "$TMP_CHECKOUT_VERSION"
	fi
	rm -rf "$TERMUX_PKG_SRCDIR"
	cp -Rf "$TMP_CHECKOUT" "$TERMUX_PKG_SRCDIR"
}


termux_step_post_get_source() {
	git checkout "$TERMUX_PKG_VERSION"
}
