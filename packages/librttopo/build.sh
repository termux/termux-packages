TERMUX_PKG_HOMEPAGE=https://git.osgeo.org/gitea/rttopo/librttopo
TERMUX_PKG_DESCRIPTION="The RT Topology Library exposes an API to create and manage standard topologies"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://git.osgeo.org/gitea/rttopo/librttopo/archive/librttopo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2e2fcabb48193a712a6c76ac9a9be2a53f82e32f91a2bc834d9f1b4fa9cd879f
TERMUX_PKG_DEPENDS="libgeos, proj"

termux_step_pre_configure() {
	./autogen.sh
}
