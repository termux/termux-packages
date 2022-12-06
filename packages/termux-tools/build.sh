TERMUX_PKG_HOMEPAGE=https://termux.dev/
TERMUX_PKG_DESCRIPTION="Basic system tools for Termux"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.33.0
TERMUX_PKG_SRCURL=https://github.com/termux/termux-tools/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d899251f7fcfd1789c22bf43ac9b17f4961ef4783d534154bd9c0e54e68594cc
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_BREAKS="termux-keyring (<< 1.9)"
TERMUX_PKG_CONFLICTS="procps (<< 3.3.15-2)"
TERMUX_PKG_SUGGESTS="termux-api"
TERMUX_PKG_CONFFILES="
etc/motd
etc/motd.sh
etc/motd-playstore
etc/profile.d/init-termux-properties.sh
etc/termux-login.sh
"

# Some of these packages are not dependencies and used only to ensure
# that core packages are installed after upgrading (we removed busybox
# from essentials).
TERMUX_PKG_DEPENDS="bzip2, coreutils, curl, dash, diffutils, findutils, gawk, grep, gzip, less, procps, psmisc, sed, tar, termux-am, termux-am-socket (>= 1.5.0), termux-exec, util-linux, xz-utils, dialog"

# Optional packages that are distributed as part of bootstrap archives.
TERMUX_PKG_RECOMMENDS="ed, dos2unix, inetutils, net-tools, patch, unzip"

termux_step_pre_configure() {
	autoreconf -vfi
}

termux_step_post_make_install() {
	cd "$TERMUX_PREFIX"
	TERMUX_PKG_CONFFILES+=" $(find etc/termux/mirrors -type f)"
}
