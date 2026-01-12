TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config
TERMUX_PKG_DESCRIPTION="X keyboard configuration files"
TERMUX_PKG_LICENSE="HPND, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.47"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config/-/archive/xkeyboard-config-${TERMUX_PKG_VERSION}/xkeyboard-config-xkeyboard-config-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b199d506aed1a03d00f11411091f6db8f136ef68f308d4747c76151e59cba874
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_DEPENDS="python"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="StrEnum"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dcompat-rules=true
-Dxorg-rules-symlinks=true
"
