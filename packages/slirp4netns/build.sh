TERMUX_PKG_HOMEPAGE=https://github.com/rootless-containers/slirp4netns
TERMUX_PKG_DESCRIPTION="User-mode networking for unprivileged network namespaces"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="1.3.7"
TERMUX_PKG_SRCURL="https://github.com/rootless-containers/slirp4netns/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=79079c69149c9d7ec81f5f5a7e705951dc788bc5e300849e3adfef69f8232836
TERMUX_PKG_DEPENDS="glib, libcap, libseccomp, libslirp, resolv-conf"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	autoreconf -fis
}
