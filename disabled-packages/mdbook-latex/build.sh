TERMUX_PKG_HOMEPAGE=https://github.com/lbeckman314/mdbook-latex
TERMUX_PKG_DESCRIPTION="An mdbook backend for generating LaTeX and PDF documents"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1.42
TERMUX_PKG_SRCURL=https://github.com/lbeckman314/mdbook-latex/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4b480a79e491a49653104de51d3ee409929093ffef04b2b2c707f09e7ce2e1f8
TERMUX_PKG_DEPENDS="fontconfig, freetype, harfbuzz, libexpat, libgraphite, libicu, libpng, openssl-1.1, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# openssl-sys supports OpenSSL 3 in >= 0.9.69
	export OPENSSL_INCLUDE_DIR=$TERMUX_PREFIX/include/openssl-1.1
	export OPENSSL_LIB_DIR=$TERMUX_PREFIX/lib/openssl-1.1
	CFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CFLAGS"
	CPPFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CPPFLAGS"
	CXXFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CXXFLAGS"
	LDFLAGS="-L$TERMUX_PREFIX/lib/openssl-1.1 -Wl,-rpath=$TERMUX_PREFIX/lib/openssl-1.1 $LDFLAGS"
	RUSTFLAGS+=" -C link-arg=-Wl,-rpath=$TERMUX_PREFIX/lib/openssl-1.1"

	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local c
	for c in {expat,servo-{fontconfig,freetype}}-sys; do
		local p=$TERMUX_PKG_BUILDER_DIR/${c}-build.rs.diff
		local d
		for d in $CARGO_HOME/registry/src/github.com-*/${c}-*; do
			patch --silent -p1 -d ${d} < ${p} || :
		done
	done

	local d
	for d in $CARGO_HOME/registry/src/github.com-*/usvg-*; do
		sed 's|@TERMUX_PREFIX@|'"${TERMUX_PREFIX}"'|g' \
			$TERMUX_PKG_BUILDER_DIR/usvg-src-fontdb.rs.diff \
			| patch --silent -p1 -d ${d} || :
	done

	local _patch=$TERMUX_PKG_BUILDER_DIR/mdbook-src-renderer-html_handlebars-helpers-navigation.rs.diff
	for d in $CARGO_HOME/registry/src/github.com-*/mdbook-*; do
		patch --silent -p1 -d ${d} < ${_patch} || :
	done
}

termux_step_make() {
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-latex
}
