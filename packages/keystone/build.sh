TERMUX_PKG_HOMEPAGE=http://www.keystone-engine.org/
TERMUX_PKG_DESCRIPTION="Keystone is a lightweight multi-platform, multi-architecture assembler framework"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.9.1
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://github.com/keystone-engine/keystone/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e9d706cd0c19c49a6524b77db8158449b9c434b415fbf94a073968b68cf8a9f0
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="keystone-dev"
TERMUX_PKG_REPLACES="keystone-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPYTHON_EXECUTABLE=$(which python2.7)
-DBUILD_SHARED_LIBS=ON"
