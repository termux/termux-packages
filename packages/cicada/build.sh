TERMUX_PKG_HOMEPAGE=https://github.com/mitnk/cicada
TERMUX_PKG_DESCRIPTION="A bash like Unix shell"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION="1.2.2"
TERMUX_PKG_SRCURL=https://github.com/mitnk/cicada/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=64e2c42b800dd7ea502ffd4eb9a99d4c5e4d40bf354d7d2e1f9aae5eafda04e6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_pre_configure() {
	termux_setup_rust

	rm -f Makefile

	if [ "$TERMUX_ARCH" == "x86_64" ]; then
		local libdir=target/x86_64-linux-android/release/deps
		mkdir -p $libdir
		pushd $libdir
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)"
		echo "INPUT(-l:libunwind.a)" > libgcc.so
		popd
	fi
}
