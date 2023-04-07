TERMUX_PKG_HOMEPAGE="https://vxl.github.io"
TERMUX_PKG_DESCRIPTION="A multi-platform collection of C++ software libraries for Computer Vision and Image Understanding"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="core/vxl_copyright.h"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5.0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL="https://github.com/vxl/vxl/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=f044d2a9336f45cd4586d68ef468c0d9539f9f1b30ceb4db85bd9b6fdb012776
TERMUX_PKG_DEPENDS="dcmtk, libc++, libgeotiff, libjpeg-turbo, libpng, libtiff, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DVCL_HAS_LFS=NO
-DVXL_HAS_SSE2_HARDWARE_SUPPORT=NO
-DVXL_SSE2_HARDWARE_SUPPORT_POSSIBLE=NO
"
