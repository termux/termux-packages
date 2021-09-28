TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/autoconf/autoconf.html
TERMUX_PKG_DESCRIPTION="Creator of shell scripts to configure source code packages"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.71
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/autoconf/autoconf-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f14c83cfebcc9427f2c3cea7258bd90df972d92eb26752da4ddad81c87a0faa4
TERMUX_PKG_DEPENDS="m4, make, perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_GROUPS="base-devel"

termux_step_post_get_source() {
	perl -p -i -e "s|/bin/sh|$TERMUX_PREFIX/bin/sh|" lib/*/*.m4
}

termux_step_post_massage() {
	perl -p -i -e "s|/usr/bin/m4|$TERMUX_PREFIX/bin/m4|" bin/*
	perl -p -i -e "s|CONFIG_SHELL-/bin/sh|CONFIG_SHELL-$TERMUX_PREFIX/bin/sh|" bin/autoconf
}
