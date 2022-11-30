TERMUX_PKG_HOMEPAGE=https://tomclegg.ca/mp3cat
TERMUX_PKG_DESCRIPTION="Copies a byte stream, skipping everything except mp3 frames with valid headers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5
TERMUX_PKG_SRCURL=https://github.com/tomclegg/mp3cat/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b1ec915c09c7e1c0ff48f54844db273505bc0157163bed7b2940792dca8ff951
TERMUX_PKG_CONFLICTS="mp3cat-go"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
PREFIX=$TERMUX_PREFIX
INSTALL_COMMAND=install
"
