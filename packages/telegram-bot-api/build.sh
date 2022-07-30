TERMUX_PKG_HOMEPAGE=https://github.com/tdlib/telegram-bot-api
TERMUX_PKG_DESCRIPTION="Telegram Bot API server"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=https://github.com/tdlib/telegram-bot-api.git
_COMMIT=8a0f1dd730aa41ab7b792b9ff03d92b1c5022c9f
_COMMIT_DATE=2022.05.05
TERMUX_PKG_VERSION=${_COMMIT_DATE//./}
TERMUX_PKG_REVISION=0
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="readline, openssl, zlib"

termux_step_post_get_source() {
	rm -rf $TERMUX_PKG_HOSTBUILD_DIR
	git fetch --unshallow
	git checkout $_COMMIT
}

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT
}

termux_step_host_build() {
	termux_setup_cmake
	cmake "-DCMAKE_BUILD_TYPE=Release" "$TERMUX_PKG_SRCDIR"
	cmake --build . --target prepare_cross_compiling
}
