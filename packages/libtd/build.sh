TERMUX_PKG_HOMEPAGE=https://core.telegram.org/tdlib/
TERMUX_PKG_DESCRIPTION="Library for building Telegram clients"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
# Upstream does not seem to do tagged releases since 1.8.0
TERMUX_PKG_VERSION=1.8.70
_COMMIT_HASH=23383aef218a3123f02b744bfa91bde21056a814
TERMUX_PKG_SRCURL=https://github.com/tdlib/td/archive/${_COMMIT_HASH}.tar.gz
TERMUX_PKG_SHA256=322517e8b7ab6b7035a998f52890d6f13c7a06909b879e30484cf806140929cc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libc++, readline, openssl (>= 1.1.1), zlib"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja
	cmake "-DCMAKE_BUILD_TYPE=Release" "$TERMUX_PKG_SRCDIR" -G"Ninja"
	cmake --build . --target prepare_cross_compiling
}

termux_step_post_make_install() {
	# Fix rebuilds without ./clean.sh.
	rm -rf $TERMUX_PKG_HOSTBUILD_DIR
}
