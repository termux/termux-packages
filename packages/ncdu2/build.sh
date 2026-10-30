TERMUX_PKG_HOMEPAGE=https://dev.yorhel.nl/ncdu
TERMUX_PKG_DESCRIPTION="Disk usage analyzer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSES/MIT.txt"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="2.12.0"
TERMUX_PKG_SRCURL="https://github.com/BratishkaErik/ncdu/releases/download/v${TERMUX_PKG_VERSION}/ncdu-${TERMUX_PKG_VERSION}-src.tar.gz"
TERMUX_PKG_SHA256=b01b5388bc6d87c16ecd04d5b3a079dcc9806763cd582162e499cf0cc56dfbb2
TERMUX_PKG_CONFLICTS="ncdu"
TERMUX_PKG_REPLACES="ncdu"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='^v\K2\.\d+(\.\d+)?$'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	local f
	f=$(sed -nE "s|.*SPDX-FileCopyrightText.*: (.*)|\1|p" ChangeLog)
	sed \
		-e "s|<year> <copyright holders>|${f}|" \
		-i LICENSES/MIT.txt

	cp "${TERMUX_PKG_BUILDER_DIR}/stat_shim.c" src/stat_shim.c
}

termux_step_pre_configure() {
	termux_setup_zig
	unset CFLAGS LDFLAGS
}

termux_step_make() {
	ZIG_GLOBAL_CACHE_DIR="${TERMUX_PKG_CACHEDIR}/zig-global-cache" \
		zig build --release=fast -Dstrip -Dtarget="${ZIG_TARGET_NAME}"
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" zig-out/bin/ncdu
	install -Dm644 -t "${TERMUX_PREFIX}/share/man/man1" ncdu.1
}
