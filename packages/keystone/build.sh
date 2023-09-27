TERMUX_PKG_HOMEPAGE=https://www.keystone-engine.org/
TERMUX_PKG_DESCRIPTION="Keystone is a lightweight multi-platform, multi-architecture assembler framework"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.2
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/keystone-engine/keystone/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c9b3a343ed3e05ee168d29daf89820aff9effb2c74c6803c2d9e21d55b5b7c24
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="keystone-dev"
TERMUX_PKG_REPLACES="keystone-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPYTHON_EXECUTABLE=$(command -v python2.7)
-DBUILD_SHARED_LIBS=ON
-DLLVM_LIBDIR_SUFFIX=
"
