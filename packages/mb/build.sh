TERMUX_PKG_HOMEPAGE=https://github.com/Maxix-git/mb
TERMUX_PKG_DESCRIPTION="Terminal browser with a sandboxed JavaScript engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@Maxix-git"
TERMUX_PKG_VERSION=0.6.1
# A release tarball that ALREADY CONTAINS node_modules. Termux builds run with
# no network, so npm install is not allowed inside the build.
TERMUX_PKG_SRCURL=https://github.com/Maxix-git/mb/releases/download/v${TERMUX_PKG_VERSION}/mb-${TERMUX_PKG_VERSION}-vendor.tar.gz
TERMUX_PKG_SHA256=8ff7d46194158696958bd78b89fca2aaf1da98bead2b68e7c4116b9acd26eb59
TERMUX_PKG_DEPENDS="nodejs"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_get_source() {
	# Fail loudly instead of shipping a package that cannot start.
	if [ ! -d "$TERMUX_PKG_SRCDIR/node_modules/quickjs-emscripten" ]; then
		termux_error_exit "the release tarball must vendor node_modules/quickjs-emscripten (builds are offline)"
	fi
	if [ ! -f "$TERMUX_PKG_SRCDIR/terminal/index.js" ]; then
		termux_error_exit "terminal/index.js missing from the release tarball"
	fi
}

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX/lib/mb"
	cp -a "$TERMUX_PKG_SRCDIR"/. "$TERMUX_PREFIX/lib/mb/"

	# Program files in lib, launcher in bin, per Termux convention.
	find "$TERMUX_PREFIX/lib/mb" -type d -exec chmod 755 {} +
	find "$TERMUX_PREFIX/lib/mb" -type f -exec chmod 644 {} +

	mkdir -p "$TERMUX_PREFIX/bin"
	cat > "$TERMUX_PREFIX/bin/mb" <<-EOF
	#!$TERMUX_PREFIX/bin/sh
	exec $TERMUX_PREFIX/bin/node $TERMUX_PREFIX/lib/mb/terminal/index.js "\$@"
	EOF
	chmod 755 "$TERMUX_PREFIX/bin/mb"
	ln -sf mb "$TERMUX_PREFIX/bin/maxbrowser"
}
