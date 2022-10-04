TERMUX_PKG_HOMEPAGE="https://github.com/containers/bubblewrap"
TERMUX_PKG_DESCRIPTION="Unprivileged sandboxing tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.2"
TERMUX_PKG_SRCURL="https://github.com/containers/bubblewrap/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=f8d21707b492d318380f0a76966e8cfa40c2df283de8bcf1ac51e7a4dcc12e97
TERMUX_PKG_DEPENDS="libcap, bash-completion"
TERMUX_PKG_BUILD_DEPENDS="docbook-xsl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS='
-Dselinux=disabled
'
# patch was based on v0.6.2
TERMUX_PKG_AUTO_UPDATE=false
