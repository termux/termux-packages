TERMUX_PKG_HOMEPAGE=https://github.com/containers/conmon
TERMUX_PKG_DESCRIPTION="An OCI container runtime monitor."
# License: GPL-2.0-with-OpenSSL-exception
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@xingguangcuican6666"
TERMUX_PKG_VERSION="2.2.1"
TERMUX_PKG_SRCURL=https://github.com/containers/conmon/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=814fb5979a3a4b8576b1f901e606b482bebb41cb7e57926e6d5765ee786b96d3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libseccomp"

termux_step_pre_configure() {
	CFLAGS+=" -Wno-error"
}
