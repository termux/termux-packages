TERMUX_PKG_HOMEPAGE=https://github.com/tdlib/telegram-bot-api
TERMUX_PKG_DESCRIPTION="Telegram Bot API server"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=git+https://github.com/tdlib/telegram-bot-api
_COMMIT=251589221708a8280ffcad32fcdc5348d014a6ae
_COMMIT_DATE=2023.04.21
TERMUX_PKG_VERSION=${_COMMIT_DATE//./}
TERMUX_PKG_GIT_BRANCH=master
_TD_SRCURL=https://github.com/tdlib/td.git
_TD_COMMIT=328b8649d859c5ed4088a875cbb059db6029dc0d
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="libc++, openssl, zlib"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	rm -rf td
	git clone $_TD_SRCURL td
	cd td
	git checkout $_TD_COMMIT
}

termux_step_host_build() {
	termux_setup_cmake
	cmake "-DCMAKE_BUILD_TYPE=Release" "$TERMUX_PKG_SRCDIR"
	cmake --build . --target prepare_cross_compiling
}
