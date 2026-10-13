TERMUX_PKG_HOMEPAGE="https://github.com/containers/bubblewrap"
TERMUX_PKG_DESCRIPTION="Unprivileged sandboxing tool"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.13.0
TERMUX_PKG_SRCURL="https://github.com/containers/bubblewrap/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=caecc52894a20ad9c932af8cb2a2c1bfd251b2d085f16d6c4d0424624c6c3cf9
TERMUX_PKG_DEPENDS="libcap, bash-completion"
TERMUX_PKG_BUILD_DEPENDS="docbook-xsl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS='
-Dselinux=disabled
'
TERMUX_PKG_AUTO_UPDATE=true
