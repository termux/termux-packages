TERMUX_PKG_HOMEPAGE=https://github.com/aristocratos/btop
TERMUX_PKG_DESCRIPTION="Resource monitor that shows usage and stats for processor, memory, disks, network and processes."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@tstein <me@tedstein.net>"
TERMUX_PKG_VERSION="1.4.6"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL=https://github.com/aristocratos/btop/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4beb90172c6acaac08c1b4a5112fb616772e214a7ef992bcbd461453295a58be
TERMUX_PKG_BUILD_DEPENDS="aosp-libs, lowdown"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	-DBTOP_LTO=OFF
	-DBTOP_GPU=OFF
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	termux_setup_proot
	mkdir "${TERMUX_PKG_TMPDIR}/bin"
	printf '%s\ntermux-proot-run %s "$@"\n' \
		"#!/bin/sh" \
		"${TERMUX_PREFIX}/bin/lowdown" \
	> "${TERMUX_PKG_TMPDIR}/bin/lowdown"
	chmod +x "${TERMUX_PKG_TMPDIR}/bin/lowdown"

	PATH="${TERMUX_PKG_TMPDIR}/bin:$PATH"

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLOWDOWN_EXECUTABLE=${TERMUX_PKG_TMPDIR}/bin/lowdown"
}
