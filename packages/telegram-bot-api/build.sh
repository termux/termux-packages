TERMUX_PKG_HOMEPAGE=https://github.com/tdlib/telegram-bot-api
TERMUX_PKG_DESCRIPTION="Telegram Bot API server "
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.5.5
TERMUX_PKG_SRCURL=https://github.com/tdlib/telegram-bot-api.git
TERMUX_PKG_GIT_BRANCH="master"
# TERMUX_PKG_SHA256=24ba2c8beae889e6002ea7ced0e29851dee57c27fde8480fb9c64d5eb8765313
TERMUX_PKG_AUTO_UPDATE=true
# TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
# TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="gperf, zlib, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_BUILD_TYPE=Release
-DCMAKE_INSTALL_PREFIX:PATH=$TERMUX_PREFIX
"



termux_step_pre_configure() {
	# uftrace uses custom configure script implementation, so we need to provide some flags
	# export OPENSSL_INCLUDE_DIR=$TERMUX_PREFIX/include/openssl-1.1
	# export OPENSSL_LIB_DIR=$TERMUX_PREFIX/lib/openssl-1.1
	CXXFLAGS="-stdlib=libc++ $CXXFLAGS"
	
      rm -rf build/
}
