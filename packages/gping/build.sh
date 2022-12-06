TERMUX_PKG_HOMEPAGE=https://github.com/orf/gping
TERMUX_PKG_DESCRIPTION="Ping, but with a graph"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION="1.5.1"
TERMUX_PKG_SRCURL=https://github.com/orf/gping/archive/refs/tags/gping-v$TERMUX_PKG_VERSION.zip
TERMUX_PKG_SHA256=c2b895968279fef6462e199d74a461202217ed42b13c6050488ab3f52dfadee4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	mv $TERMUX_PREFIX/lib/libz.so.1{,.tmp}
	mv $TERMUX_PREFIX/lib/libz.so{,.tmp}
}

termux_step_make() {
	cd gping
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
	cd ..
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/gping
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/lib/libz.so.1{.tmp,}
	mv $TERMUX_PREFIX/lib/libz.so{.tmp,}
}

termux_step_post_massage() {
	rm -f lib/libz.so.1
	rm -f lib/libz.so
}
