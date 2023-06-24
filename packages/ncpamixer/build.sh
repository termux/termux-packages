TERMUX_PKG_HOMEPAGE=https://github.com/fulhax/ncpamixer
TERMUX_PKG_DESCRIPTION="An ncurses mixer for PulseAudio"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.3.4
TERMUX_PKG_SRCURL=https://github.com/fulhax/ncpamixer/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=78be1b229c0325d58d34efd50cec3d2b0a1cb04fd2b34e4914e6ad29c7c17658
TERMUX_PKG_DEPENDS="libc++, ncurses-ui-libs, pulseaudio"
TERMUX_PKG_BUILD_DEPENDS="libandroid-wordexp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DUSE_WIDE=ON"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/src"
}
