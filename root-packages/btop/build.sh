TERMUX_PKG_HOMEPAGE=https://github.com/aristocratos/btop
TERMUX_PKG_DESCRIPTION="Resource monitor that shows usage and stats for processor, memory, disks, network and processes."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.5"
TERMUX_PKG_SRCURL=https://github.com/aristocratos/btop/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0ffe03d3e26a3e9bbfd5375adf34934137757994f297d6b699a46edd43c3fc02
TERMUX_PKG_BUILD_DEPENDS="aosp-libs, lowdown"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	-DBTOP_LTO=OFF
	-DBTOP_GPU=OFF
	-DLOWDOWN_EXECUTABLE="${TERMUX_PKG_TMPDIR}/bin/lowdown"
"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	[[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]] && termux_setup_proot
	mkdir "${TERMUX_PKG_TMPDIR}/bin"
	printf '%s\ntermux-proot-run %s "$@"\n' \
		"#!/bin/sh" \
		"${TERMUX_PREFIX}/bin/lowdown" \
	> "${TERMUX_PKG_TMPDIR}/bin/lowdown"
	chmod +x "${TERMUX_PKG_TMPDIR}/bin/lowdown"

	PATH="${TERMUX_PKG_TMPDIR}/bin:$PATH"
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/var/btop"
	cp -L "$TERMUX_PKG_BUILDER_DIR/procstat" "$TERMUX_PREFIX/var/btop/stat"
}
