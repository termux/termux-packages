TERMUX_PKG_HOMEPAGE=https://git.osgeo.org/gitea/rttopo/librttopo
TERMUX_PKG_DESCRIPTION="The RT Topology Library exposes an API to create and manage standard topologies"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://git.osgeo.org/gitea/rttopo/librttopo/archive/librttopo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=60b49acb493c1ab545116fb0b0d223ee115166874902ad8165eb39e9fd98eaa9
TERMUX_PKG_DEPENDS="libgeos, proj"
TERMUX_PKG_GROUPS="science"

termux_step_pre_configure() {
	./autogen.sh
}
