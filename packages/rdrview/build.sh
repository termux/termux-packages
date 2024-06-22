TERMUX_PKG_HOMEPAGE=https://github.com/eafer/rdrview
TERMUX_PKG_DESCRIPTION="Command line tool to extract the main content from a webpage"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:0.1.2"
TERMUX_PKG_SRCURL=https://github.com/eafer/rdrview/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=1c328d91730abde45c352c5879fa51ce8c1918609826f0f0485d3bd895bfb50b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libcurl, libiconv, libseccomp, libxml2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
