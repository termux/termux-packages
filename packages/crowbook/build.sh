TERMUX_PKG_HOMEPAGE=https://github.com/lise-henry
TERMUX_PKG_DESCRIPTION="Allows you to write a book in Markdown without worrying about formatting or typography"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.15.2e
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/lise-henry/crowbook/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ac950c051faece985821c28c17206188a6211247a040a8e7afaa34a5f45cf81f
TERMUX_PKG_DEPENDS="openssl-1.1"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# openssl-sys supports OpenSSL 3 in >= 0.9.69
	# We can switch to OpenSSL 3 once new version of crowbook is released
	export OPENSSL_INCLUDE_DIR=$TERMUX_PREFIX/include/openssl-1.1
	export OPENSSL_LIB_DIR=$TERMUX_PREFIX/lib/openssl-1.1
	CFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CFLAGS"
	CPPFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CPPFLAGS"
	CXXFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CXXFLAGS"
	LDFLAGS="-L$TERMUX_PREFIX/lib/openssl-1.1 -Wl,-rpath=$TERMUX_PREFIX/lib/openssl-1.1 $LDFLAGS"
	RUSTFLAGS+=" -C link-arg=-Wl,-rpath=$TERMUX_PREFIX/lib/openssl-1.1"
}

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/crowbook
}
