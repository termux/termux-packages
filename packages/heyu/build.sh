TERMUX_PKG_HOMEPAGE=https://www.heyu.org/
TERMUX_PKG_DESCRIPTION="Program for remotely controlling lights and appliances"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:2.10.3
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL="https://github.com/HeyuX10Automation/heyu/archive/v${TERMUX_PKG_VERSION:2}.tar.gz"
TERMUX_PKG_SHA256=0c3435ea9cd57cd78c29047b9c961f4bfbec39f42055c9949acd10dd9853b628
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# rindex is an obsolete version of strrchr which is not available in Android:
	CFLAGS+=" -Drindex=strrchr"
	sed -e "s|@TERMUX_CC@|${CC}|g" \
		-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"${TERMUX_PKG_BUILDER_DIR}"/Configure.diff | patch -p1
}

termux_step_configure() {
	./Configure linux
}
