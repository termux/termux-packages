TERMUX_PKG_HOMEPAGE=https://github.com/kokkos
TERMUX_PKG_DESCRIPTION="Implements a programming model in C++ for writing performance portable applications"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="Copyright.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5.00
TERMUX_PKG_SRCURL=https://github.com/kokkos/kokkos/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=748f06aed63b1e77e3653cd2f896ef0d2c64cb2e2d896d9e5a57fec3ff0244ff
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DKokkos_ENABLE_LIBDL=OFF
"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"
