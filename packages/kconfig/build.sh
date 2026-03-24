TERMUX_PKG_HOMEPAGE=https://api.kde.org/frameworks/kconfig/html/index.html
TERMUX_PKG_DESCRIPTION="KDE Frameworks 6 tier 1 addon with advanced configuration system"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@codingWiz-rick"
TERMUX_PKG_VERSION="6.9.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kconfig-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b8b9dfb0bc5bc0f9c45164e02c988dd8ab10a34aea0c80b1945fd0b3267ac6f9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
