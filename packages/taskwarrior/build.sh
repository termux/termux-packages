TERMUX_PKG_HOMEPAGE=https://taskwarrior.org
TERMUX_PKG_DESCRIPTION="Utility for managing your TODO list"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.5.0"
TERMUX_PKG_SRCURL="https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v${TERMUX_PKG_VERSION}/task-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=9ea64b411f8314414f440ec765dfdf5a86c9f6159df47e2f60cff3db6b31157a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob, libc++, libgnutls, libuuid"
TERMUX_PKG_CMAKE_BUILD="Unix Makefiles"

termux_step_pre_configure() {
	termux_setup_rust
	cargo install --force --locked bindgen-cli

	CXXFLAGS+=" -Wno-c++11-narrowing"
	LDFLAGS+=" -landroid-glob"
	export ANDROID_STANDALONE_TOOLCHAIN="$TERMUX_STANDALONE_TOOLCHAIN"
	export CARGO_TARGET_$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)_RUSTFLAGS+=" -C linker=$(command -v $CC)"

	export CMAKE_POLICY_VERSION_MINIMUM=3.5
	export BINDGEN_EXTRA_CLANG_ARGS="--sysroot ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot"
	case "${TERMUX_ARCH}" in
	arm) BINDGEN_EXTRA_CLANG_ARGS+=" --target=arm-linux-androideabi" ;;
	*) BINDGEN_EXTRA_CLANG_ARGS+=" --target=${TERMUX_ARCH}-linux-android" ;;
	esac

	if [ "$TERMUX_ARCH" = "arm" ]; then
		# See https://cmake.org/cmake/help/latest/variable/CMAKE_ANDROID_ARM_MODE.html
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_ANDROID_ARM_MODE=ON"
	fi
}

termux_step_post_make_install() {
	install -Dm600 -T "$TERMUX_PKG_SRCDIR"/scripts/bash/task.sh \
		$TERMUX_PREFIX/share/bash-completion/completions/task
	install -Dm600 -t $TERMUX_PREFIX/share/fish/vendor_completions.d \
		"$TERMUX_PKG_SRCDIR"/scripts/fish/task.fish
}
