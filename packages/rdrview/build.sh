TERMUX_PKG_HOMEPAGE=https://github.com/eafer/rdrview
TERMUX_PKG_DESCRIPTION="Command line tool to extract the main content from a webpage"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:0.1.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/eafer/rdrview/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=a1a7197c7a8a813630b77fa4485fe8808f67c4c1c8aed3b0ea89eaf6f9bd84e1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libcurl, libiconv, libseccomp, libxml2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
