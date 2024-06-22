TERMUX_PKG_HOMEPAGE=https://github.com/aeolwyr/tergent
TERMUX_PKG_DESCRIPTION="A cryptoki/PKCS#11 library for Termux that uses Android Keystore as its backend"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_REVISION=4
# Build from specific revision until patches are merged upstream, or
# we decide to maintain a fork
_COMMIT=831e300e3d75a9618963bbefbaad49bf37e2cf3c
TERMUX_PKG_SRCURL=https://github.com/termux/tergent/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=8979504a0e705fca35a6ae81ba1665c5bafebe218008ee50b6dc4f8a8d611cec
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="termux-api"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	local BUILD_TYPE=
	if [ $TERMUX_DEBUG_BUILD = false ]; then
		BUILD_TYPE=--release
	fi

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES \
		--target $CARGO_TARGET_NAME ${BUILD_TYPE}
}

termux_step_make_install() {
	local BUILD_TYPE=release
	if [ $TERMUX_DEBUG_BUILD = true ]; then
		BUILD_TYPE=debug
	fi
	install -Dm600 -t $TERMUX_PREFIX/lib \
		target/${CARGO_TARGET_NAME}/${BUILD_TYPE}/libtergent.so
}
