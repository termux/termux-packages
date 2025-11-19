TERMUX_PKG_HOMEPAGE=https://github.com/jart/hiptext
TERMUX_PKG_DESCRIPTION="Turn images into text better than caca/aalib"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=https://github.com/jart/hiptext/releases/download/$TERMUX_PKG_VERSION/hiptext-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7f2217dec8775b445be6745f7bd439c24ce99c4316a9faf657bee7b42bc72e8f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ffmpeg, freetype, gflags, google-glog, libjpeg-turbo, libpng, ncurses"
TERMUX_PKG_BUILD_DEPENDS="ragel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	#Font reference on file font.cc --> Patch by font.cc.patch
	#Because of ttf-dejavu is x11 package, the hiptext is not a x11 package.
	install -Dm600 -t "$TERMUX_PREFIX"/share/hiptext/ \
		"$TERMUX_PKG_SRCDIR"/DejaVuSansMono.ttf
}
