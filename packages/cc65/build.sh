TERMUX_PKG_HOMEPAGE=https://cc65.github.io/
TERMUX_PKG_DESCRIPTION="A free compiler for 6502 based system"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.19
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/cc65/cc65/archive/refs/tags/V${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=157b8051aed7f534e5093471e734e7a95e509c577324099c3c81324ed9d0de77
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	cd $TERMUX_PKG_SRCDIR
	make clean
	make
}

termux_step_pre_configure() {
	# hostbuild step have to be run everytime currently
	rm -Rf $TERMUX_PKG_HOSTBUILD_DIR
}

termux_step_make() {
	make clean -C src
	make bin
}

termux_pkg_auto_update() {
	local latest_tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" newest-tag)"
	[[ -z "${latest_tag}" ]] && termux_error_exit "ERROR: Unable to get tag from ${TERMUX_PKG_SRCURL}"
	termux_pkg_upgrade_version "${latest_tag#V}"
}
