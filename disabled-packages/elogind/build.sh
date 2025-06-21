TERMUX_PKG_HOMEPAGE=https://github.com/elogind/elogind
TERMUX_PKG_DESCRIPTION="The systemd project's logind, extracted to a standalone package"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=255.17
TERMUX_PKG_SRCURL=https://github.com/elogind/elogind/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a9725ae3f73f8d910de84c108bc11bfd4c782bef6a4190b2ec70c5d2f22344db
TERMUX_PKG_DEPENDS="libcap, libmount, libudev-zero"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dmode=release
-Dsysconfdir=$TERMUX_PREFIX/etc
-Dlocalstatedir=$TERMUX_PREFIX/var
-Dhalt-path=$TERMUX_PREFIX/bin/false
-Dpoweroff-path=$TERMUX_PREFIX/bin/false
-Dreboot-path=$TERMUX_PREFIX/bin/false
-Dkexec-path=$TERMUX_PREFIX/bin/false
-Dnologin-path=$TERMUX_PREFIX/bin/false
-Ddefault-user-shell=$TERMUX_PREFIX/bin/bash
-Duser-path=$TERMUX_PREFIX/bin:/system/bin
-Ddefault-kill-user-processes=false
-Dsplit-bin=false
-Dutmp=false
-Defi=false
"

termux_step_post_get_source() {
	# Prefer meson build
	rm -f configure
}

termux_step_pre_configure() {
	termux_setup_meson
}
