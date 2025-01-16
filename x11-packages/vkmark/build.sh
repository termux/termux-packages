TERMUX_PKG_HOMEPAGE=https://github.com/vkmark/vkmark
TERMUX_PKG_DESCRIPTION="Vulkan benchmark"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2017.08
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/vkmark/vkmark/archive/ab6e6f34077722d5ae33f6bd40b18ef9c0e99a15.tar.gz
TERMUX_PKG_SHA256=d08143e8828d5b9ed005cb6dcef4d88a49df0ac4c9e1356ace739b449c165f54
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="assimp, libc++, libxcb, vulkan-loader-generic, xcb-util-wm"
TERMUX_PKG_BUILD_DEPENDS="glm, vulkan-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dxcb=true -Dkms=false"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}
