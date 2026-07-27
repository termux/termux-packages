TERMUX_PKG_HOMEPAGE="https://xplanet.sourceforge.net"
TERMUX_PKG_DESCRIPTION="Renders an image of all the major planets and most satellites"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="1.3.0"
TERMUX_PKG_SRCURL="https://master.dl.sourceforge.net/project/xplanet/xplanet/${TERMUX_PKG_VERSION}/xplanet-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=44fb742bb93e5661ea8b11ccabcc12896693e051f3dd5083c9227224c416b442
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libjpeg-turbo, libpng, libx11, netpbm"

termux_step_pre_configure() {
		CXXFLAGS+=" -std=gnu++98"
		export ac_cv_header_gif_lib_h=no
		export ac_cv_lib_gif_DGifOpenFileName=no
}
