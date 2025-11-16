TERMUX_PKG_HOMEPAGE=https://spidermonkey.dev
TERMUX_PKG_DESCRIPTION="Mozilla's JavaScript engine"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="128.10.0"
TERMUX_PKG_REVISION=2
_REAL_VERSION=${TERMUX_PKG_VERSION}esr
TERMUX_PKG_SRCURL=https://archive.mozilla.org/pub/firefox/releases/$_REAL_VERSION/source/firefox-$_REAL_VERSION.source.tar.xz
TERMUX_PKG_SHA256=2ed83e26e41a8b3e2c7c0d13448a84dbb9b7ed65ed46bc162d629b0c6b071caf
TERMUX_PKG_DEPENDS="libicu, libnspr, libnss, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	local f="media/ffvpx/config_unix_aarch64.h"
	echo "Applying sed substitution to ${f}"
	sed -E '/^#define (CONFIG_LINUX_PERF|HAVE_SYSCTL) /s/1$/0/' -i ${f}
}

termux_step_pre_configure() {
	termux_setup_nodejs
	termux_setup_rust

	# https://github.com/rust-lang/rust/issues/49853
	# https://github.com/rust-lang/rust/issues/45854
	# Out of memory when building gkrust
	# CI shows (signal: 9, SIGKILL: kill)
	if [ "$TERMUX_DEBUG_BUILD" = false ]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C debuginfo=1"
	fi

	cargo install cbindgen

	export HOST_CC=$(command -v clang)
	export HOST_CXX=$(command -v clang++)

	# https://reviews.llvm.org/D141184
	CXXFLAGS+=" -U__ANDROID__ -D_LIBCPP_HAS_NO_C11_ALIGNED_ALLOC"
	LDFLAGS+=" -llog"
}

termux_step_configure() {
	if [ "$TERMUX_CONTINUE_BUILD" == "true" ]; then
		termux_step_pre_configure
		cd $TERMUX_PKG_SRCDIR
	fi

	sed \
		-e "s|@TERMUX_HOST_PLATFORM@|${TERMUX_HOST_PLATFORM}|" \
		-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|" \
		-e "s|@CARGO_TARGET_NAME@|${CARGO_TARGET_NAME}|" \
		$TERMUX_PKG_BUILDER_DIR/mozconfig.cfg > .mozconfig

	if [ "$TERMUX_DEBUG_BUILD" = true ]; then
		cat >>.mozconfig - <<END
ac_add_options --enable-debug-symbols
ac_add_options --disable-install-strip
END
	fi

	./mach configure
}

termux_step_make() {
	./mach build --keep-going
	./mach buildsymbols
}

termux_step_make_install() {
	local _TARGET_TRIPLE
	case "${TERMUX_ARCH}" in
		aarch64|arm) _TARGET_TRIPLE=${TERMUX_HOST_PLATFORM/-/-unknown-} ;;
		i686|x86_64) _TARGET_TRIPLE=${TERMUX_HOST_PLATFORM/-/-pc-} ;;
		*) termux_error_exit "Invalid arch: ${TERMUX_ARCH}" ;;
	esac
	cd obj-$_TARGET_TRIPLE
	make install
}

termux_step_post_make_install() {
	# Remove static library
	rm -f $TERMUX_PREFIX/lib/libjs_static.ajs
}
