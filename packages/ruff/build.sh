TERMUX_PKG_HOMEPAGE="https://github.com/charliermarsh/ruff"
TERMUX_PKG_DESCRIPTION="An extremely fast Python linter, written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.15.1"
TERMUX_PKG_SRCURL="https://github.com/charliermarsh/ruff/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=bb29d8ec29910f7e15c88aac676e875842ce0e56540bef2b93c9fd7ebaab78e3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="maturin"

termux_step_pre_configure() {
	termux_setup_rust

	rm -rf _lib
	mkdir -p _lib
	cd _lib
	$CC $CPPFLAGS $CFLAGS -fvisibility=hidden \
		-c $TERMUX_PKG_BUILDER_DIR/ctermid.c
	$AR cru libctermid.a ctermid.o

	local env_host="$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)"
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$TERMUX_PKG_BUILDDIR/_lib/libctermid.a"

	export ANDROID_API_LEVEL="$TERMUX_PKG_API_LEVEL"
}

termux_step_make() {
	# --skip-auditwheel workaround for Maturin error
	# 'Cannot repair wheel, because required library libdl.so could not be located.'
	# found here in Termux-specific upstream discussion: https://github.com/PyO3/pyo3/issues/2324
	maturin build --locked --skip-auditwheel --release --all-features --target "$CARGO_TARGET_NAME" --strip
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/bin" "target/$CARGO_TARGET_NAME/release/ruff"

	# ERROR: ruff-0.11.9-py3-none-linux_armv7l.whl is not a supported wheel on this platform.
	# seems to be resolved by renaming the .whl file in this way
	local _pyver="${TERMUX_PYTHON_VERSION/./}"
	local _tag="py3-none"

	local wheel_arch
	case "$TERMUX_ARCH" in
		aarch64) wheel_arch=arm64_v8a ;;
		arm)     wheel_arch=armeabi_v7a ;;
		x86_64)  wheel_arch=x86_64 ;;
		i686)    wheel_arch=x86 ;;
		*)
			echo "ERROR: Unknown architecture: $TERMUX_ARCH"
			return 1 ;;
	esac

	mv "target/wheels/ruff-${TERMUX_PKG_VERSION}-${_tag}-android_${TERMUX_PKG_API_LEVEL}_${wheel_arch}.whl" \
		"target/wheels/ruff-${TERMUX_PKG_VERSION}-py${_pyver}-none-any.whl"

	pip install --no-deps --prefix="$TERMUX_PREFIX" --force-reinstall target/wheels/*.whl
}
