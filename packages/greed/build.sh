TERMUX_PKG_HOMEPAGE=http://www.catb.org/~esr/greed/
TERMUX_PKG_DESCRIPTION="Game where you try to eat as much as possible of the board before munching yourself into a corner"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.0"
TERMUX_PKG_SRCURL=http://www.catb.org/~esr/greed/greed-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=340a6f2bdb47159d1c31a435c568db52962bd9637c8d9006b6fcf5958018e8cc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"

termux_step_configure() {
	termux_setup_rust
	local -u env_host="${CARGO_TARGET_NAME//-/_}"
	export RUSTFLAGS
	RUSTFLAGS="$(env | grep CARGO_TARGET_"${env_host}"_RUSTFLAGS | cut -d'=' -f2-)"
	RUSTFLAGS+=" --target $CARGO_TARGET_NAME"
	RUSTFLAGS+=" -C linker=$CC"
}
