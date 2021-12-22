TERMUX_PKG_HOMEPAGE=https://www.kokkonen.net/tjko/projects.html
TERMUX_PKG_DESCRIPTION="JPEG optimizer that recompresses image files to a smaller size, without losing any information"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.6
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.kokkonen.net/tjko/src/jpegoptim-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=88b1eb64c2a33a2f013f068df8b0331f42c019267401ae3fa28e3277403a5ab7
TERMUX_PKG_DEPENDS="libjpeg-turbo"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --mandir=$TERMUX_PREFIX/share/man"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LD=$CC
}
