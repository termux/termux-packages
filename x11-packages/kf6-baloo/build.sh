TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/baloo"
TERMUX_PKG_DESCRIPTION="A framework for searching and managing metadata"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.16.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/baloo-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="8c27feeca25ab073862e433c735782f28713568d1390a84771b1ba43f6171f65"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kfilemetadata, kf6-ki18n, kf6-kidletime, kf6-kio, kf6-solid, liblmdb, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
TERMUX_PKG_POST_INSTALL_SCRIPT="
echo '#!/bin/sh' > \$PREFIX/bin/disable_baloo.sh
echo 'balooctl6 disable || true' >> \$PREFIX/bin/disable_baloo.sh
chmod +x \$PREFIX/bin/disable_baloo.sh
sh \$PREFIX/bin/disable_baloo.sh
rm -f \$PREFIX/bin/disable_baloo.sh
"
