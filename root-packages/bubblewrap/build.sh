TERMUX_PKG_HOMEPAGE="https://github.com/containers/bubblewrap"
TERMUX_PKG_DESCRIPTION="Unprivileged sandboxing tool"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_SRCURL="https://github.com/containers/bubblewrap/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=8ede2b605d5aaf68aaa6ef1a5264ba7a31108c98417a8f88d289d0b5fa820c1b
TERMUX_PKG_DEPENDS="libcap, bash-completion"
TERMUX_PKG_BUILD_DEPENDS="docbook-xsl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS='
-Dselinux=disabled
'
# patch was based on v0.6.2
TERMUX_PKG_AUTO_UPDATE=false
