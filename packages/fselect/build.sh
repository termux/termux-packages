TERMUX_PKG_HOMEPAGE=https://fselect.rocks/
TERMUX_PKG_DESCRIPTION="Find files with SQL-like queries"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/jhspetersson/fselect/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d0a9cdaafd8c8ceba1a2f02545171b0caa41ca575f9e30871bbd00f231ef44d2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="zlib"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_rust

	# Dummy CMake toolchain file to workaround build error:
	# error: failed to run custom build command for `libz-ng-sys v1.1.15`
	# ...
	# CMake Error at /home/builder/.termux-build/_cache/cmake-3.28.3/share/cmake-3.28/Modules/Platform/Android-Determine.cmake:217 (message):
	# Android: Neither the NDK or a standalone toolchain was found.
	export TARGET_CMAKE_TOOLCHAIN_FILE="${TERMUX_PKG_BUILDDIR}/android.toolchain.cmake"
	touch "${TERMUX_PKG_BUILDDIR}/android.toolchain.cmake"

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	rm -rf $CARGO_HOME/registry/src/*/libmimalloc-sys-*
	cargo fetch --target "${CARGO_TARGET_NAME}"

	p="libmimalloc-sys-tls.diff"
	for d in $CARGO_HOME/registry/src/*/libmimalloc-sys-*; do
		patch --silent -p1 -d ${d} < "${TERMUX_PKG_BUILDER_DIR}/${p}"
	done

	# ld.lld: error: undefined symbol: __atomic_load_8
	if [[ "${TERMUX_ARCH}" == "i686" ]]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)"
	fi
}

termux_step_post_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/fselect \
		"$TERMUX_PREFIX"/bin/fselect
}

termux_step_post_massage() {
	rm -rf $CARGO_HOME/registry/src/*/libmimalloc-sys-*
}
