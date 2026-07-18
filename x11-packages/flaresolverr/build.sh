TERMUX_PKG_HOMEPAGE=https://github.com/FlareSolverr/FlareSolverr
TERMUX_PKG_DESCRIPTION="Proxy server to bypass Cloudflare protection"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.5.0"
TERMUX_PKG_SRCURL="https://github.com/FlareSolverr/FlareSolverr/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256="63c22bcbd2f4136b43d0469ad16701a5266b6e024c3aa8964ee47aec71235556"
TERMUX_PKG_DEPENDS="python, chromium, xorg-server-xvfb, python-pip, python-xvfbwrapper"
TERMUX_PKG_PYTHON_RUNTIME_DEPS="bottle, waitress, selenium, func-timeout, prometheus-client, requests, certifi, websockets, packaging"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_EXCLUDED_ARCHES="i686"

termux_step_make_install() {
	# Install main application files
	mkdir -p "$TERMUX_PREFIX/share/flaresolverr"
	cp -r "$TERMUX_PKG_SRCDIR/src" "$TERMUX_PREFIX/share/flaresolverr/"
	cp "$TERMUX_PKG_SRCDIR/package.json" "$TERMUX_PREFIX/share/flaresolverr/"

	# Create launcher script wrapper
	mkdir -p "$TERMUX_PREFIX/bin"
	cat <<-EOF >"$TERMUX_PREFIX/bin/flaresolverr"
		#!/bin/sh
		exec python "$TERMUX_PREFIX/share/flaresolverr/src/flaresolverr.py" "\$@"
	EOF
	chmod 755 "$TERMUX_PREFIX/bin/flaresolverr"
}
