TERMUX_PKG_HOMEPAGE="https://github.com/charliermarsh/ruff"
TERMUX_PKG_DESCRIPTION="An extremely fast Python linter, written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.6"
TERMUX_PKG_SRCURL="https://github.com/charliermarsh/ruff/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=58ebb8ec4479e8b307c5364fcf562f94d1debf65a0f9821c153f2b3aa019243c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="maturin"

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
	if [[ "${TERMUX_ARCH}" == "arm" ]]; then
		local _whl_arch="armv7l"
	else
		local _whl_arch="$TERMUX_ARCH"
	fi
	local _whl="ruff-$TERMUX_PKG_VERSION-py3-none-linux_$_whl_arch.whl"
	if [[ "${TERMUX_ARCH}" == "arm" ]]; then
		local _dest_whl="ruff-$TERMUX_PKG_VERSION-py3-none-linux_$TERMUX_ARCH.whl"
		mv "target/wheels/$_whl" "target/wheels/$_dest_whl"
		_whl="$_dest_whl"
	fi
	pip install --no-deps --prefix=$TERMUX_PREFIX --force-reinstall "target/wheels/$_whl"
}
