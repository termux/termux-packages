TERMUX_PKG_HOMEPAGE=https://gitlab.com/surfraw/Surfraw
TERMUX_PKG_DESCRIPTION="Shell Users' Revolutionary Front Rage Against the Web"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_REVISION=10
TERMUX_PKG_SRCURL=https://gitlab.com/surfraw/Surfraw/-/archive/surfraw-${TERMUX_PKG_VERSION}/Surfraw-surfraw-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b5e2b451a822ed437b165a5c81d8448570ee590db902fcd8174d6c51fcc4a16d
TERMUX_PKG_DEPENDS="lynx, perl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./prebuild
}
