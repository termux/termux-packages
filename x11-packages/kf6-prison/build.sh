TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/prison"
TERMUX_PKG_DESCRIPTION="A barcode API to produce QRCode barcodes and DataMatrix barcodes"
TERMUX_PKG_LICENSE="BSD 3-Clause, CC0-1.0, MIT"
TERMUX_PKG_LICENSE_FILE="
LICENSES/BSD-3-Clause.txt
LICENSES/CC0-1.0.txt
LICENSES/MIT.txt
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.18.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/prison-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=38a4f154b39b4d2e4b86d16f84846039d27bd70cb26ecd488b591f612dd4141e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libdmtx, libqrencode, qt6-qtbase, qt6-qtmultimedia, libzxing-cpp"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtdeclarative, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
