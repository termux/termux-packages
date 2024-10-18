TERMUX_PKG_HOMEPAGE=https://github.com/lu-zero/cargo-c
TERMUX_PKG_DESCRIPTION="Cargo C-ABI helpers"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.4"
TERMUX_PKG_SRCURL=https://github.com/lu-zero/cargo-c/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3382f6c3eca404695885e79babfce6448124a481a77cec11c3bfeb5830f677c1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='^\d+\.\d+(\.\d+)?$'
TERMUX_PKG_DEPENDS="libcurl, libgit2, libssh2, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_pkg_auto_update() {
	local latest_tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" "${TERMUX_PKG_UPDATE_TAG_TYPE}")"
	if grep -qP "${TERMUX_PKG_UPDATE_VERSION_REGEXP}" <<<"${latest_tag}"; then
		termux_pkg_upgrade_version "${latest_tag}"
	else
		echo "INFO: No update needed, tag '${latest_tag}' is not a stable release."
	fi
}

termux_step_pre_configure() {
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export LIBSSH2_SYS_USE_PKG_CONFIG=1
	export PKG_CONFIG_ALLOW_CROSS=1

	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local f
	for f in $CARGO_HOME/registry/src/*/libgit2-sys-*/build.rs; do
		sed -i -E 's/\.range_version\(([^)]*)\.\.[^)]*\)/.atleast_version(\1)/g' "${f}"
	done

	local _CARGO_TARGET_LIBDIR="target/${CARGO_TARGET_NAME}/release/deps"
	mkdir -p $_CARGO_TARGET_LIBDIR

	mv $TERMUX_PREFIX/lib/libz.so.1{,.tmp}
	mv $TERMUX_PREFIX/lib/libz.so{,.tmp}

	ln -sfT $(readlink -f $TERMUX_PREFIX/lib/libz.so.1.tmp) \
		$_CARGO_TARGET_LIBDIR/libz.so.1
	ln -sfT $(readlink -f $TERMUX_PREFIX/lib/libz.so.tmp) \
		$_CARGO_TARGET_LIBDIR/libz.so

	if [[ "${TERMUX_ARCH}" == "x86_64" ]]; then
		RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
	fi
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/lib/libz.so.1{.tmp,}
	mv $TERMUX_PREFIX/lib/libz.so{.tmp,}
}

termux_step_post_massage() {
	rm -f lib/libz.so.1
	rm -f lib/libz.so
}
