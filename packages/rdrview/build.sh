TERMUX_PKG_HOMEPAGE=https://github.com/eafer/rdrview
TERMUX_PKG_DESCRIPTION="Command line tool to extract the main content from a webpage"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:0.1
TERMUX_PKG_SRCURL=https://github.com/eafer/rdrview/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=6cb6688b3465f71ced13b889708cbd728193d7137f4108511a3fd2d4331d7f0c
TERMUX_PKG_DEPENDS="libcurl, libiconv, libseccomp, libxml2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
