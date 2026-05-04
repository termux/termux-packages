TERMUX_PKG_HOMEPAGE=https://github.com/fulhax/ncpamixer
TERMUX_PKG_DESCRIPTION="An ncurses mixer for PulseAudio"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.11"
TERMUX_PKG_SRCURL=https://github.com/fulhax/ncpamixer/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dcc4a0ce20e9fff3f1ff710697971369aed28b6ed2f6c67c42039670eaf0f717
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libc++, ncurses-ui-libs, pulseaudio"
TERMUX_PKG_BUILD_DEPENDS="libandroid-wordexp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DUSE_WIDE=ON"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/src"
}
