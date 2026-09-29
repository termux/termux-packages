TERMUX_PKG_HOMEPAGE="https://xplanet.sourceforge.net"
TERMUX_PKG_DESCRIPTION="Renders an image of all the major planets and most satellites"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="1.3.1"
TERMUX_PKG_SRCURL="https://master.dl.sourceforge.net/project/xplanet/xplanet/${TERMUX_PKG_VERSION}/xplanet-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=4380d570a8bf27b81fb629c97a636c1673407f4ac4989ce931720078a90aece7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libjpeg-turbo, libpng, libx11, netpbm"

termux_step_pre_configure() {
		CXXFLAGS+=" -std=gnu++98"
		export ac_cv_header_gif_lib_h=no
		export ac_cv_lib_gif_DGifOpenFileName=no
}
