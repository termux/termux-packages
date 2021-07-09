TERMUX_PKG_HOMEPAGE=https://github.com/gravitational/teleport
TERMUX_PKG_DESCRIPTION="Secure Access for Developers that doesn't get in the way"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.2.7
TERMUX_PKG_SRCURL=https://github.com/gravitational/teleport/archive/refs/tags/v$TERMUX_PKG_VERSION.zip
TERMUX_PKG_SHA256=89ac7e5164f6e40c00b469065727d4c71d8c4c6180b60c43958b2154e18069d5

termux_step_make_install() {
	termux_setup_golang
	# TODO: Cache Golang dependency
	make full
}
