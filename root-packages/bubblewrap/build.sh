TERMUX_PKG_HOMEPAGE="https://github.com/containers/bubblewrap"
TERMUX_PKG_DESCRIPTION="Unprivileged sandboxing tool"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.11.0
TERMUX_PKG_SRCURL="https://github.com/containers/bubblewrap/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=cfeeb15fcc47d177d195f06fdf0847e93ee3aa6bf46f6ac0a141fa142759e2c3
TERMUX_PKG_DEPENDS="libcap, bash-completion"
TERMUX_PKG_BUILD_DEPENDS="docbook-xsl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS='
-Dselinux=disabled
'
# patch was based on v0.6.2
TERMUX_PKG_AUTO_UPDATE=false
