TERMUX_PKG_HOMEPAGE=https://github.com/alobbs/macchanger
TERMUX_PKG_DESCRIPTION="Utility that makes the maniputation of MAC addresses of network interfaces easier"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/alobbs/macchanger/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1d75c07a626321e07b48a5fe2dbefbdb98c3038bb8230923ba8d32bda5726e4f

termux_step_pre_configure() {
	./autogen.sh
}
