TERMUX_PKG_HOMEPAGE=https://github.com/Symbian9/azpainter
TERMUX_PKG_DESCRIPTION="Full color painting software for Unix-like systems for illustration drawing (unofficial)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1:2.1.6
TERMUX_PKG_SRCURL=https://github.com/Symbian9/azpainter/releases/download/v${TERMUX_PKG_VERSION:2}/azpainter-${TERMUX_PKG_VERSION:2}.tar.xz
TERMUX_PKG_SHA256=85f3f935e76b420f2e5e272514368fdfbe4c25c01daa1e161ac28a6e1edb0d2c
TERMUX_PKG_DEPENDS="fontconfig, hicolor-icon-theme, libandroid-shmem, libjpeg-turbo, libxfixes, libxi"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./configure --prefix="$TERMUX_PREFIX" \
		CC="$CC" \
		CFLAGS="$CFLAGS" \
		LDFLAGS="$LDFLAGS" \
		LIBS="-landroid-shmem"
}
