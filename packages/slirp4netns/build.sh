TERMUX_PKG_HOMEPAGE=https://github.com/rootless-containers/slirp4netns
TERMUX_PKG_DESCRIPTION="User-mode networking for unprivileged network namespaces"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="1.3.6"
TERMUX_PKG_SRCURL=https://github.com/rootless-containers/slirp4netns/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1e58c3a22d1f8361c9dfd7e518f621bc5510df519d00dbdd40954b77c0e1102f
TERMUX_PKG_DEPENDS="glib, libcap, libseccomp, libslirp, resolv-conf"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	autoreconf -fis
}
