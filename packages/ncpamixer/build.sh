TERMUX_PKG_HOMEPAGE=https://github.com/fulhax/ncpamixer
TERMUX_PKG_DESCRIPTION="An ncurses mixer for PulseAudio"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.7"
TERMUX_PKG_SRCURL=https://github.com/fulhax/ncpamixer/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8a647b333875e117449fdfa3167ed50cfebe2c2254ae2618eaa5e64a5e5db3a6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libc++, ncurses-ui-libs, pulseaudio"
TERMUX_PKG_BUILD_DEPENDS="libandroid-wordexp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DUSE_WIDE=ON"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/src"
}
