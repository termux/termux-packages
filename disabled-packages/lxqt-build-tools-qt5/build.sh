TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Building tools required by LXQt project"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="BSD-3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.13.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-build-tools/releases/download/${TERMUX_PKG_VERSION}/lxqt-build-tools-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=fd3c199d0d7c61f23040a45ead57cc9a4f888af5995371f6b0ce1fa902eb59ce
TERMUX_PKG_DEPENDS="cmake, libc++, qt5-qtbase"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
# Prevent updating to latest lxqt2-build-tools
TERMUX_PKG_AUTO_UPDATE=false
