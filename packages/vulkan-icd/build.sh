TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-packages
TERMUX_PKG_DESCRIPTION="A metapackage that provides Vulkan ICDs"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_METAPACKAGE=true

# XXX: Make buildorder.py happy
if [ true = true ]; then
	TERMUX_PKG_DEPENDS="mesa-vulkan-icd-swrast"
	TERMUX_PKG_DEPENDS+=" | mesa-vulkan-icd-freedreno"
	TERMUX_PKG_DEPENDS+=" | swiftshader"
fi
