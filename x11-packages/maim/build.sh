TERMUX_PKG_HOMEPAGE=https://github.com/naelstrof/maim
TERMUX_PKG_DESCRIPTION="Command-line screenshot utility for X11"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@Keytaro2"
TERMUX_PKG_VERSION=5.8.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/naelstrof/maim/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ecafe01dcbe4246071c58ff36acdcd93d290ed501f67933334b646436650450e
TERMUX_PKG_DEPENDS="libandroid-shmem, libglvnd, libicu, libjpeg-turbo, libpng, libwebp, libx11, libxcomposite, libxext, libxfixes, libxrandr, libxrender, slop, zlib"
TERMUX_PKG_BUILD_DEPENDS="glm, libglvnd-dev, xorgproto"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-shmem"
}
