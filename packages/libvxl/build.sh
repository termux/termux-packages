TERMUX_PKG_HOMEPAGE="https://vxl.github.io"
TERMUX_PKG_DESCRIPTION="A multi-platform collection of C++ software libraries for Computer Vision and Image Understanding"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="core/vxl_copyright.h"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.3.2"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL="https://github.com/vxl/vxl/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=95ecde4b02bbe00aec0d656fd2c43373de2a5d41487a68135f0b565254919411
TERMUX_PKG_DEPENDS="libc++, libgeotiff, zlib, libpng, libjpeg-turbo, libexpat, dcmtk"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DVCL_HAS_LFS=NO
-DVXL_HAS_SSE2_HARDWARE_SUPPORT=NO
-DVXL_SSE2_HARDWARE_SUPPORT_POSSIBLE=NO
"
