TERMUX_PKG_HOMEPAGE=https://github.com/tsujan/Arqiver
TERMUX_PKG_DESCRIPTION="A simple Qt archiver manager based on libarchive"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="1.0.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tsujan/Arqiver/releases/download/V${TERMUX_PKG_VERSION}/Arqiver-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=03b388ca53d4b68b7e6716189a2a489e4135b2fbb653c8ae261b8edbbffd009d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtsvg"
TERMUX_PKG_RECOMMENDS="bsdtar, gzip, hicolor-icon-theme"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_QT5=OFF"
