TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Utilities for core application functionality and accessing the OS (KDE)"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=5.71.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL="http://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kcoreaddons-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=e95008b032e299cf47f596739d9236701e2f55e507734f33b8ea497882fd130b
TERMUX_PKG_DEPENDS="qt5-qtbase, shared-mime-info"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

# Keep share/mime/packages/kde5.xml only which would trigger an update after installation
TERMUX_PKG_RM_AFTER_INSTALL="
share/mime/a*
share/mime/font
share/mime/g*
share/mime/i*
share/mime/m*
share/mime/subclasses
share/mime/t*
share/mime/v*
share/mime/x*
share/mime/XMLnamespaces
"
