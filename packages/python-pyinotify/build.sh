TERMUX_PKG_HOMEPAGE=https://github.com/seb-m/pyinotify
TERMUX_PKG_DESCRIPTION="Python module for watching filesystems changes"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="0.9.6"
TERMUX_PKG_SRCURL="https://github.com/seb-m/pyinotify/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7943f198c5cef2bdc121d847937fbe565daaa7d4daaf1b8de8ef5689812f481c
TERMUX_PKG_AUTO_UPDATE=true
# Upstream publishes tags only, no GitHub releases.
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
