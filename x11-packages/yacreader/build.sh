TERMUX_PKG_HOMEPAGE=https://www.yacreader.com
TERMUX_PKG_DESCRIPTION="Comic reader and comic library manager"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@tke918"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_VERSION="10.3.0"
TERMUX_PKG_SRCURL="https://github.com/YACReader/yacreader/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7cbc09c9930da338d2b9a65b3b16e5173cdc18e3e6bdb5b69e5163de0ec5c3b1
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
