TERMUX_PKG_HOMEPAGE=https://github.com/aeolwyr/tergent
TERMUX_PKG_DESCRIPTION="A cryptoki/PKCS#11 library for Termux that uses Android Keystore as its backend"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/aeolwyr/tergent/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0b59cf0ced3f693fb19396a986326963f3763e6bf65d3e56af0a03d206d69428
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="termux-api"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	local BUILD_TYPE=
	if [ $TERMUX_DEBUG_BUILD = false ]; then
		BUILD_TYPE=--release
	fi

	cargo build --jobs $TERMUX_MAKE_PROCESSES \
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
