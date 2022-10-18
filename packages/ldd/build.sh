TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-packages
TERMUX_PKG_DESCRIPTION="Fake ldd command"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_DEPENDS="bash, binutils-is-llvm"
TERMUX_PKG_CONFLICTS="binutils"

termux_step_make_install() {
	local ldd="$TERMUX_PREFIX/bin/ldd"
	mkdir -p "$(dirname "${ldd}")"
	rm -rf "${ldd}"
	sed "$TERMUX_PKG_BUILDER_DIR/ldd.in" \
		-e "s|@ARCH_BITS@|${TERMUX_ARCH_BITS}|g" \
		> "${ldd}"
	chmod 0700 "${ldd}"
}
