TERMUX_PKG_HOMEPAGE=https://forge.soutade.fr/soutade/libgourou/
TERMUX_PKG_DESCRIPTION="libgourou is a free implementation of Adobe's ADEPT protocol used to add DRM on ePub/PDF files."
TERMUX_PKG_LICENSE="LGPL-3.0, BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.7"
TERMUX_PKG_SRCURL="https://forge.soutade.fr/soutade/libgourou/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e3df256e75a64aa18ca815080feccab4eabe49c177f39cec79d36f481660d6fd

TERMUX_PKG_DEPENDS="libzip, libpugixml"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	export CXXFLAGS+=" -I$TERMUX_PREFIX/include -v -v"
	export LDFLAGS+=" -L$TERMUX_PREFIX/lib"

	make
}

termux_step_make_install() {
	make install
}
