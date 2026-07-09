TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config
TERMUX_PKG_DESCRIPTION="X keyboard configuration files"
TERMUX_PKG_LICENSE="HPND, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.48"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config/-/archive/xkeyboard-config-${TERMUX_PKG_VERSION}/xkeyboard-config-xkeyboard-config-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1e304d3c7a74bfbad0bae16b25d4c2b2eda06714b988953607a06cc013bf3077
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_DEPENDS="python"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="StrEnum"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dcompat-rules=true
-Dxorg-rules-symlinks=true
"
