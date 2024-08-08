TERMUX_PKG_HOMEPAGE=https://core.telegram.org/bots
TERMUX_PKG_DESCRIPTION="Telegram Bot API server"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="Maria Lisina @Sarisan"
TERMUX_PKG_VERSION="1:7.8"
TERMUX_PKG_SRCURL=https://github.com/Sarisan/telegram-bot-api/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=07c4ed2404c4648446104ffe6aad988dd30bb0ac0256e6f43bf616103e49be42
TERMUX_PKG_DEPENDS="libc++, openssl, zlib"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_host_build() {
	termux_setup_cmake

	cmake -S $TERMUX_PKG_SRCDIR -B $TERMUX_PKG_HOSTBUILD_DIR -DCMAKE_BUILD_TYPE=Release
	cmake --build $TERMUX_PKG_HOSTBUILD_DIR --target prepare_cross_compiling
}
