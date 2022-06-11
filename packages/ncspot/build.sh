TERMUX_PKG_HOMEPAGE=https://github.com/hrkfdn/ncspot
TERMUX_PKG_DESCRIPTION="An ncurses Spotify client written in Rust"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.0"
TERMUX_PKG_SRCURL=https://github.com/hrkfdn/ncspot/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=18617de29ba4d96b3c4b17139fc3b0fcdfa0adb205cbec96afb817b7981a33d2
TERMUX_PKG_DEPENDS="dbus, pulseaudio"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_CONFLICTS="ncspot-mpris"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--no-default-features
--features cursive/termion-backend,share_clipboard,pulseaudio_backend
"
# NOTE: ncurses-rs runs a test while building which fails while cross compiling:
# therefore, we use cursive/termion-backend instead.
