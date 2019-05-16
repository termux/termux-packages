TERMUX_PKG_HOMEPAGE=http://www.capstone-engine.org/
TERMUX_PKG_DESCRIPTION="Lightweight multi-platform, multi-architecture disassembly framework"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=4.0.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/aquynh/capstone/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=79bbea8dbe466bd7d051e037db5961fdb34f67c9fac5c3471dd105cfb1e05dc7
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DINSTALL_LIB_DIR=$TERMUX_PREFIX/lib"
