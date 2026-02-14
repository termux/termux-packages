TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/prison"
TERMUX_PKG_DESCRIPTION="A barcode API to produce QRCode barcodes and DataMatrix barcodes"
TERMUX_PKG_LICENSE="BSD 3-Clause, CC0-1.0, MIT"
TERMUX_PKG_LICENSE_FILE="
LICENSES/BSD-3-Clause.txt
LICENSES/CC0-1.0.txt
LICENSES/MIT.txt
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.23.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/prison-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9d0c917649f39b685fd1b9298674680869ee013fbb82a2cfd6e733500b080236
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libdmtx, libqrencode, qt6-qtbase, qt6-qtmultimedia, libzxing-cpp"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtdeclarative, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
