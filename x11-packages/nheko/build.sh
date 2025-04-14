TERMUX_PKG_HOMEPAGE=https://nheko-reborn.github.io/
TERMUX_PKG_DESCRIPTION="Desktop client for the Matrix protocol"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.3"
TERMUX_PKG_SRCURL="https://nheko.im/nheko-reborn/nheko/-/archive/v${TERMUX_PKG_VERSION}/nheko-v${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=12203b08b4d777d2fc3c0b2e5fa2733824e78da42ba0108340442c89dda24978
# TODO:
# - mtxclient
TERMUX_PKG_DEPENDS="blurhash, cmark, cpp-httplib, fmt, glib, gst-plugins-bad, gst-plugins-base, gst-plugins-good, gstreamer, libc++, liblmdb, libolm, libspdlog, libxcb, mtxclient, qt5-qtbase, qt5-qtdeclarative, qt5-qtgraphicaleffects, qt5-qtmultimedia, qt5-qtquickcontrols2, qt5-qtsvg, qt5keychain, xcb-util-wm"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DUSE_BUNDLED_CPPHTTPLIB=OFF -DUSE_BUNDLED_BLURHASH=OFF"
TERMUX_PKG_BUILD_DEPENDS="asciidoc, lmdb++, nlohmann-json, qt5-qttools-cross-tools"
TERMUX_PKG_RECOMMENDS="qt-jdenticon"
TERMUX_PKG_AUTO_UPDATE=true
