TERMUX_PKG_HOMEPAGE=https://www.yacreader.com
TERMUX_PKG_DESCRIPTION="Comic reader and comic library manager"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@tke918"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_VERSION="10.3.2"
TERMUX_PKG_SRCURL="https://github.com/YACReader/yacreader/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ca4e7ac2df896af9d569d357b0ec5966ca67ebdc165ff25fab278b7d1b3ab188
TERMUX_PKG_DEPENDS="libarchive, libc++, poppler, poppler-qt, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative, qt6-qtimageformats, qt6-qtmultimedia, qt6-qtspeech, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="qt6-qttools, qt6-qtshadertools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DCMAKE_CXX_SCAN_FOR_MODULES=OFF
-DCMAKE_BUILD_TYPE=Release
-DDECOMPRESSION_BACKEND=libarchive
-DPDF_BACKEND=poppler
-DBUILD_TESTS=OFF
"
