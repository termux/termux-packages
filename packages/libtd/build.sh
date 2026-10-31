TERMUX_PKG_HOMEPAGE=https://core.telegram.org/tdlib/
TERMUX_PKG_DESCRIPTION="Library for building Telegram clients"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
# Upstream does not seem to do tagged releases since 1.8.0
TERMUX_PKG_VERSION=1.8.69
_COMMIT_HASH=4c6377aa7386c39217878a9a56d581922ad37ca4
TERMUX_PKG_SRCURL=https://github.com/tdlib/td/archive/${_COMMIT_HASH}.tar.gz
TERMUX_PKG_SHA256=472015605fffa826bfba6ccf7d888905b436ecce94c8a6826203792edfbe5731
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
